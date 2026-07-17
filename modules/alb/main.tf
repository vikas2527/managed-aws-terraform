# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "alb" {
  name        = "${local.prefix}-alb-sg"
  description = "Security group for ${local.prefix} ALB"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-alb-sg"
  })
}

# ── Ingress HTTP ──────────────────────────────────────────────────────────────
resource "aws_security_group_rule" "alb_http" {
  count             = length(var.allowed_cidr_blocks)
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_cidr_blocks[count.index]]
}

# ── Ingress HTTPS ─────────────────────────────────────────────────────────────
resource "aws_security_group_rule" "alb_https" {
  count             = length(var.allowed_cidr_blocks)
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS from internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_cidr_blocks[count.index]]
}

# ── Egress ────────────────────────────────────────────────────────────────────
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ── Application Load Balancer ─────────────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "${local.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-alb"
  })
}

# ── HTTP Listener — redirects to HTTPS ───────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ── HTTPS Listener ────────────────────────────────────────────────────────────
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No route matched"
      status_code  = "404"
    }
  }
}