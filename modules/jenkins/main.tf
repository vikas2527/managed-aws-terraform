# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "jenkins" {
  name        = "${local.prefix}-jenkins-sg"
  description = "Security group for ${local.prefix} Jenkins"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-jenkins-sg"
  })
}

# ── Ingress: Jenkins UI from VPN only ─────────────────────────────────────────
resource "aws_security_group_rule" "jenkins_ui" {
  type              = "ingress"
  security_group_id = aws_security_group.jenkins.id
  description       = "Allow Jenkins UI from VPN"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [var.vpn_cidr]
}

# ── Ingress: SSH from VPN only ────────────────────────────────────────────────
resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.jenkins.id
  description       = "Allow SSH from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.vpn_cidr]
}

# ── Ingress: Jenkins agent JNLP port ─────────────────────────────────────────
resource "aws_security_group_rule" "jenkins_jnlp" {
  type              = "ingress"
  security_group_id = aws_security_group.jenkins.id
  description       = "Allow Jenkins agent JNLP"
  from_port         = 50000
  to_port           = 50000
  protocol          = "tcp"
  cidr_blocks       = [var.vpn_cidr]
}

# ── Egress: all outbound ──────────────────────────────────────────────────────
resource "aws_security_group_rule" "jenkins_egress" {
  type              = "egress"
  security_group_id = aws_security_group.jenkins.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ── IAM Role ──────────────────────────────────────────────────────────────────
resource "aws_iam_role" "jenkins" {
  name = "${local.prefix}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-jenkins-role"
  })
}

# ── IAM Instance Profile ──────────────────────────────────────────────────────
resource "aws_iam_instance_profile" "jenkins" {
  name = "${local.prefix}-jenkins-profile"
  role = aws_iam_role.jenkins.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-jenkins-profile"
  })
}

# ── IAM Policy: ECR access ────────────────────────────────────────────────────
resource "aws_iam_role_policy" "jenkins_ecr" {
  name = "${local.prefix}-jenkins-ecr-policy"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages"
        ]
        Resource = "*"
      }
    ]
  })
}

# ── IAM Policy: EKS access ────────────────────────────────────────────────────
resource "aws_iam_role_policy" "jenkins_eks" {
  name = "${local.prefix}-jenkins-eks-policy"
  role = aws_iam_role.jenkins.id

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

# ── IAM Policy: Terraform state access ───────────────────────────────────────
resource "aws_iam_role_policy" "jenkins_terraform" {
  name = "${local.prefix}-jenkins-terraform-policy"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::managed-aws-terraform-state",
          "arn:aws:s3:::managed-aws-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/managed-terraform-locks"
      }
    ]
  })
}

# ── IAM Policy: SSM ───────────────────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "jenkins_ssm" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── User Data: Jenkins setup script ──────────────────────────────────────────
locals {
  jenkins_userdata = <<-EOF
#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install Java
apt-get install -y fontconfig openjdk-21-jre

# Add Jenkins repo with 2026 key
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
apt-get update -y
apt-get install -y jenkins

# Install Docker
apt-get install -y docker.io
usermod -aG docker jenkins
systemctl enable docker
systemctl start docker

# Install AWS CLI
apt-get install -y unzip curl
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

# Install Trivy
apt-get install -y wget apt-transport-https gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb generic main | tee /etc/apt/sources.list.d/trivy.list
apt-get update -y
apt-get install -y trivy

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

echo "Jenkins setup complete" >> /var/log/jenkins-setup.log
EOF
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────
resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  user_data                   = local.jenkins_userdata

  vpc_security_group_ids = [aws_security_group.jenkins.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(local.common_tags, {
      Name = "${local.prefix}-jenkins-root-volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-jenkins"
  })

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}