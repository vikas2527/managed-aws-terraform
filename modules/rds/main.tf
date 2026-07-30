# ── Subnet Group ──────────────────────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name        = "${local.prefix}-rds-subnet-group"
  subnet_ids  = var.private_subnet_ids
  description = "RDS subnet group for ${local.prefix}"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-rds-subnet-group"
  })
}

# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${local.prefix}-rds-sg"
  description = "Security group for ${local.prefix} RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-rds-sg"
  })
}

# ── Ingress from EKS Node Security Group ─────────────────────────────────────
resource "aws_security_group_rule" "rds_from_eks" {
  count = length(var.allowed_security_group_ids)

  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  description              = "Allow PostgreSQL from EKS nodes"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
}

# ── Ingress from VPN CIDR ─────────────────────────────────────────────────────
resource "aws_security_group_rule" "rds_from_vpn" {
  count = length(var.allowed_cidr_blocks)

  type              = "ingress"
  security_group_id = aws_security_group.rds.id
  description       = "Allow PostgreSQL from VPN"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_cidr_blocks[count.index]]
}

# ── Ingress from EKS Cluster Security Group ───────────────────────────────────
resource "aws_security_group_rule" "rds_from_eks_cluster" {
  count = var.eks_cluster_security_group_id != "" ? 1 : 0

  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = var.eks_cluster_security_group_id
  description              = "Allow PostgreSQL from EKS cluster SG"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
}

# ── Egress ────────────────────────────────────────────────────────────────────
resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  security_group_id = aws_security_group.rds.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound"
}

# ── Parameter Group ───────────────────────────────────────────────────────────
resource "aws_db_parameter_group" "main" {
  name        = "${local.prefix}-rds-pg"
  family      = "postgres18ye"
  description = "Custom parameter group for ${local.prefix} PostgreSQL"


  tags = merge(local.common_tags, {
    Name = "${local.prefix}-rds-pg"
  })
}

# ── RDS Instance ──────────────────────────────────────────────────────────────
resource "aws_db_instance" "main" {
  identifier = "${local.prefix}-postgres"

  # Engine
  engine               = "postgres"
  engine_version       = var.postgres_version
  instance_class       = var.instance_class

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  # Database
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.main.name
  publicly_accessible    = false

  # Availability
  multi_az = var.multi_az

  # Protection
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.prefix}-final-snapshot"

  # Logs
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-postgres"
  })
}