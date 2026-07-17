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

# ── Route: shared VPC → peer VPC ─────────────────────────────────────────────
resource "aws_route" "shared_to_peer" {
  route_table_id            = var.vpc_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ── Route: peer VPC → shared VPC ─────────────────────────────────────────────
resource "aws_route" "peer_to_shared" {
  route_table_id            = var.peer_route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}