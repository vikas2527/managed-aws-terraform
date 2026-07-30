# ── IAM Role: EKS Cluster ─────────────────────────────────────────────────────
resource "aws_iam_role" "cluster" {
  name = "${local.prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-cluster-role"
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_vpc_controller" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# ── IAM Role: EKS Node Group ──────────────────────────────────────────────────
resource "aws_iam_role" "node_group" {
  name = "${local.prefix}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-node-role"
  })
}

resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_ecr_readonly" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ssm" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── Security Group: Cluster ───────────────────────────────────────────────────
resource "aws_security_group" "cluster" {
  name        = "${local.prefix}-eks-cluster-sg"
  description = "EKS cluster control plane security group"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-cluster-sg"
  })
}

resource "aws_security_group_rule" "cluster_ingress_vpn" {
  count             = length(var.allowed_cidr_blocks)
  type              = "ingress"
  security_group_id = aws_security_group.cluster.id
  description       = "Allow kubectl from VPN and shared VPC"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_cidr_blocks[count.index]]
}

resource "aws_security_group_rule" "cluster_egress" {
  type              = "egress"
  security_group_id = aws_security_group.cluster.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound"
}

# ── Security Group: Nodes ─────────────────────────────────────────────────────
resource "aws_security_group" "nodes" {
  name        = "${local.prefix}-eks-nodes-sg"
  description = "EKS worker nodes security group"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-nodes-sg"
  })
}

resource "aws_security_group_rule" "nodes_ingress_self" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.nodes.id
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
}

resource "aws_security_group_rule" "nodes_ingress_cluster" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Allow control plane to communicate with nodes"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "nodes_egress" {
  type              = "egress"
  security_group_id = aws_security_group.nodes.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound"
}

# ── EKS Cluster ───────────────────────────────────────────────────────────────
resource "aws_eks_cluster" "main" {
  name     = "${local.prefix}-eks"
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks"
  })

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_controller,
  ]
}

# ── EKS Managed Node Group ────────────────────────────────────────────────────
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.prefix}-node-group"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types
  disk_size       = var.node_disk_size

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-node-group"
  })

  depends_on = [
    aws_iam_role_policy_attachment.node_worker_policy,
    aws_iam_role_policy_attachment.node_ecr_readonly,
    aws_iam_role_policy_attachment.node_cni_policy,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# ── OIDC Provider ─────────────────────────────────────────────────────────────
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-oidc"
  })
}

# ── EKS Access Entries ────────────────────────────────────────────────────────
resource "aws_eks_access_entry" "devtools" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.devtools_role_arn
  type          = "STANDARD"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-devtools-access"
  })

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.jenkins_role_arn
  type          = "STANDARD"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-eks-jenkins-access"
  })

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_access_policy_association" "devtools" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.devtools_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.devtools]
}

resource "aws_eks_access_policy_association" "jenkins" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.jenkins_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.jenkins]
}

