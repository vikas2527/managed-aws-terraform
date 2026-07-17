terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "managed-aws-terraform-state"
    key            = "shared/vpc-peering/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "managed-terraform-locks"
  }
}

provider "aws" { region = var.aws_region }

# ── Shared ↔ Dev peering ──────────────────────────────────────────────────────
module "peering_shared_dev" {
  source = "../../../modules/vpc-peering"

  project_name        = var.project_name
  environment         = "shared-dev"
  vpc_id              = var.shared_vpc_id
  peer_vpc_id         = var.dev_vpc_id
  vpc_cidr            = var.shared_vpc_cidr
  peer_vpc_cidr       = var.dev_vpc_cidr
  vpc_route_table_id  = var.shared_private_route_table_id
  peer_route_table_id = var.dev_private_route_table_id
  tags                = var.tags
}

# ── Shared ↔ Prod peering ─────────────────────────────────────────────────────
module "peering_shared_prod" {
  source = "../../../modules/vpc-peering"

  project_name        = var.project_name
  environment         = "shared-prod"
  vpc_id              = var.shared_vpc_id
  peer_vpc_id         = var.prod_vpc_id
  vpc_cidr            = var.shared_vpc_cidr
  peer_vpc_cidr       = var.prod_vpc_cidr
  vpc_route_table_id  = var.shared_private_route_table_id
  peer_route_table_id = var.prod_private_route_table_id
  tags                = var.tags
}