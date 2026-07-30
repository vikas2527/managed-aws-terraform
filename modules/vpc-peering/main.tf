# ── VPC Peering Connection ────────────────────────────────────────────────────
resource "aws_vpc_peering_connection" "main" {
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true

  tags = {
    Name      = "${var.project_name}-${var.environment}-peering"
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

# ── Route: shared VPC private RT → peer VPC ──────────────────────────────────
resource "aws_route" "shared_to_peer" {
  route_table_id            = var.vpc_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ── Route: peer VPC private RT → shared VPC ──────────────────────────────────
resource "aws_route" "peer_to_shared" {
  route_table_id            = var.peer_route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ── Route: VPN CIDR in shared VPC private RT ─────────────────────────────────
# skip if add_vpn_route_to_shared = false (already exists from dev peering)
resource "aws_route" "vpn_to_peer" {
  count                     = var.vpn_cidr != "" && var.add_vpn_route_to_shared ? 1 : 0
  route_table_id            = var.vpc_route_table_id
  destination_cidr_block    = var.vpn_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ── Route: VPN CIDR in peer VPC public RT → shared VPC ───────────────────────
resource "aws_route" "vpn_in_peer_public" {
  count                     = var.vpn_cidr != "" && var.peer_public_route_table_id != "" ? 1 : 0
  route_table_id            = var.peer_public_route_table_id
  destination_cidr_block    = var.vpn_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ── Route: VPN CIDR in peer VPC private RT → shared VPC ──────────────────────
resource "aws_route" "vpn_in_peer_private" {
  count                     = var.vpn_cidr != "" ? 1 : 0
  route_table_id            = var.peer_route_table_id
  destination_cidr_block    = var.vpn_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ── Route: shared VPC public RT → peer VPC ───────────────────────────────────
# skip if add_vpn_route_to_shared = false (already exists from dev peering)
resource "aws_route" "shared_public_to_peer" {
  count                     = var.vpc_public_route_table_id != "" ? 1 : 0
  route_table_id            = var.vpc_public_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}