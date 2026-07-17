terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    tls = { source = "hashicorp/tls", version = "~> 4.0" }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "managed-aws-terraform-state"
    key            = "dev/eks/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "managed-terraform-locks"
  }
}

provider "aws" { region = var.aws_region }
provider "tls" {}

module "eks" {
  source = "../../../modules/eks"

  project_name        = var.project_name
  environment         = "dev"
  vpc_id              = var.vpc_id
  private_subnet_ids  = var.private_subnet_ids
  public_subnet_ids   = var.public_subnet_ids
  cluster_version     = var.cluster_version
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_disk_size      = var.node_disk_size
  allowed_cidr_blocks = var.allowed_cidr_blocks
  tags                = var.tags
}