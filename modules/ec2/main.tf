# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "main" {
    name = "${local.prefix}-${var.instance_name}-sg"
    description = "Security group for ${local.prefix}-${var.instance_name}"
    vpc_id = var.vpc_id

    tags = merge(local.common_tags,{
        Name = "${local.prefix}-${var.instance_name}"-sg
    })
}

# ── Ingress Rules ─────────────────────────────────────────────────────────────
resource "aws_security_group_rule" "ingress" {
  count = length(var.ingress_rules)

  type = "ingress"
  security_group_id = aws_security_group.main.id
  description = var.ingress_rules[count.index].description
  from_port   = var.ingress_rules[count.index].from_port
  to_port     = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = var.ingress_rules[count.index].cidr_blocks
}

# ── Egress Rule — allow all outbound ─────────────────────────────────────────
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  security_group_id = aws_security_group.main.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# ── IAM Role ──────────────────────────────────────────────────────────────────
resource "aws_iam_role" "main" {
  name = "${local.prefix}-${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${var.instance_name}-role"
  })
}

# ── IAM Instance Profile ──────────────────────────────────────────────────────
resource "aws_iam_instance_profile" "main" {
  name = "${local.prefix}-${var.instance_name}-profile"
  role = aws_iam_role.main.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${var.instance_name}-profile"
  })
}

# ── SSM Policy — allows Session Manager access without SSH ───────────────────
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────

# ── EC2 Instance ──────────────────────────────────────────────────────────────
resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = aws_iam_instance_profile.main.name
  user_data                   = var.user_data

  vpc_security_group_ids = concat(
    [aws_security_group.main.id],
    var.security_group_ids
  )

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    delete_on_termination = true

    tags = merge(local.common_tags, {
      Name = "${local.prefix}-${var.instance_name}-root-volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${var.instance_name}"
  })

  lifecycle {
    ignore_changes = [ami_id, user_data]
  }
}