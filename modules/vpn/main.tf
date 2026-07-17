# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "vpn" {
  name        = "${local.prefix}-vpn-sg"
  description = "Security group for ${local.prefix} OpenVPN"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpn-sg"
  })
}

# ── Ingress: OpenVPN UDP port ─────────────────────────────────────────────────
resource "aws_security_group_rule" "vpn_udp" {
  type              = "ingress"
  security_group_id = aws_security_group.vpn.id
  description       = "Allow OpenVPN UDP from internet"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ── Ingress: SSH for VPN server management ────────────────────────────────────
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.vpn.id
  description       = "Allow SSH for VPN server management"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ── Egress: all outbound ──────────────────────────────────────────────────────
resource "aws_security_group_rule" "vpn_egress" {
  type              = "egress"
  security_group_id = aws_security_group.vpn.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ── IAM Role ──────────────────────────────────────────────────────────────────
resource "aws_iam_role" "vpn" {
  name = "${local.prefix}-vpn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpn-role"
  })
}

# ── IAM Instance Profile ──────────────────────────────────────────────────────
resource "aws_iam_instance_profile" "vpn" {
  name = "${local.prefix}-vpn-profile"
  role = aws_iam_role.vpn.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpn-profile"
  })
}

# ── IAM Policy: SSM ───────────────────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "vpn_ssm" {
  role       = aws_iam_role.vpn.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── Elastic IP — static public IP for VPN ────────────────────────────────────
resource "aws_eip" "vpn" {
  domain   = "vpc"
  instance = aws_instance.vpn.id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpn-eip"
  })
}

# ── User Data: OpenVPN setup script ──────────────────────────────────────────
locals {
  vpn_userdata = <<-EOF
    #!/bin/bash
    set -e

    # Update system
    apt-get update -y
    apt-get upgrade -y

    # Install OpenVPN and easy-rsa
    apt-get install -y openvpn easy-rsa

    # Setup PKI
    make-cadir /etc/openvpn/easy-rsa
    cd /etc/openvpn/easy-rsa

    ./easyrsa init-pki
    echo "CA" | ./easyrsa build-ca nopass
    ./easyrsa gen-req server nopass
    echo "yes" | ./easyrsa sign-req server server
    ./easyrsa gen-dh
    openvpn --genkey secret /etc/openvpn/ta.key

    # Copy server certs
    cp pki/ca.crt              /etc/openvpn/
    cp pki/issued/server.crt   /etc/openvpn/
    cp pki/private/server.key  /etc/openvpn/
    cp pki/dh.pem              /etc/openvpn/

    # Write server config
    cat > /etc/openvpn/server.conf <<EOL
    port 1194
    proto udp
    dev tun
    ca ca.crt
    cert server.crt
    key server.key
    dh dh.pem
    tls-auth ta.key 0
    server ${var.vpn_cidr}
    ifconfig-pool-persist /var/log/openvpn/ipp.txt

    # Push routes to clients
    push "route ${var.vpc_cidr}"
    push "route ${var.dev_vpc_cidr}"
    push "route ${var.prod_vpc_cidr}"

    keepalive 10 120
    cipher AES-256-CBC
    user nobody
    group nogroup
    persist-key
    persist-tun
    status /var/log/openvpn/openvpn-status.log
    log-append /var/log/openvpn/openvpn.log
    verb 3
    EOL

    # Enable IP forwarding
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p

    # NAT rule for VPN clients to reach VPC
    iptables -t nat -A POSTROUTING -s ${var.vpn_cidr} -o eth0 -j MASQUERADE
    apt-get install -y iptables-persistent
    netfilter-persistent save

    # Start OpenVPN
    mkdir -p /var/log/openvpn
    systemctl enable openvpn@server
    systemctl start openvpn@server

    echo "OpenVPN setup complete"
  EOF
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────
resource "aws_instance" "vpn" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vpn.name
  user_data                   = local.vpn_userdata
  source_dest_check           = false

  vpc_security_group_ids = [aws_security_group.vpn.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(local.common_tags, {
      Name = "${local.prefix}-vpn-root-volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpn"
  })

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}