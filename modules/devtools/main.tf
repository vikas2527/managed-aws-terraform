# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "devtools" {
  name        = "${local.prefix}-devtools-sg"
  description = "Security group for ${local.prefix} devtools"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-devtools-sg"
  })
}

# ── Ingress: SSH from VPN only ────────────────────────────────────────────────
resource "aws_security_group_rule" "devtools_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.devtools.id
  description       = "Allow SSH from VPN only"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.vpn_cidr]
}

# ── Egress: all outbound ──────────────────────────────────────────────────────
resource "aws_security_group_rule" "devtools_egress" {
  type              = "egress"
  security_group_id = aws_security_group.devtools.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ── IAM Role ──────────────────────────────────────────────────────────────────
resource "aws_iam_role" "devtools" {
  name = "${local.prefix}-devtools-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-devtools-role"
  })
}

# ── IAM Instance Profile ──────────────────────────────────────────────────────
resource "aws_iam_instance_profile" "devtools" {
  name = "${local.prefix}-devtools-profile"
  role = aws_iam_role.devtools.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-devtools-profile"
  })
}

# ── IAM Policy: EKS access ────────────────────────────────────────────────────
resource "aws_iam_role_policy" "devtools_eks" {
  name = "${local.prefix}-devtools-eks-policy"
  role = aws_iam_role.devtools.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}

# ── IAM Policy: ECR read only ─────────────────────────────────────────────────
resource "aws_iam_role_policy" "devtools_ecr" {
  name = "${local.prefix}-devtools-ecr-policy"
  role = aws_iam_role.devtools.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages"
        ]
        Resource = "*"
      }
    ]
  })
}

# ── IAM Policy: SSM ───────────────────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "devtools_ssm" {
  role       = aws_iam_role.devtools.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── IAM Policy: RDS describe ──────────────────────────────────────────────────
resource "aws_iam_role_policy" "devtools_rds" {
  name = "${local.prefix}-devtools-rds-policy"
  role = aws_iam_role.devtools.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

# ── User Data: devtools setup script ─────────────────────────────────────────
locals {
  devtools_userdata = <<-EOF
    #!/bin/bash
    set -e

    # Update system
    apt-get update -y
    apt-get upgrade -y

    # Install essential tools
    apt-get install -y \
      curl \
      wget \
      unzip \
      git \
      vim \
      jq \
      postgresql-client

    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    rm -rf awscliv2.zip aws/

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/

    # Install Helm
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    # Install k9s — terminal UI for kubernetes
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
    tar -xzf k9s_Linux_amd64.tar.gz
    mv k9s /usr/local/bin/
    rm k9s_Linux_amd64.tar.gz

    # Install Terraform
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update -y
    apt-get install -y terraform

    # Configure kubectl for EKS clusters
    %{for cluster in var.eks_cluster_names}
    aws eks update-kubeconfig --name ${cluster} --region us-west-1
    %{endfor}

    echo "Devtools setup complete"
  EOF
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────
resource "aws_instance" "devtools" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.devtools.name
  user_data                   = local.devtools_userdata

  vpc_security_group_ids = [aws_security_group.devtools.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(local.common_tags, {
      Name = "${local.prefix}-devtools-root-volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-devtools"
  })

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}