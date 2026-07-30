terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "managed-aws-terraform-state"
    key            = "prod/rds/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "managed-terraform-locks"
  }
}

provider "aws" { region = var.aws_region }

module "rds" {
  source = "../../../modules/rds"

  project_name                  = var.project_name
  environment                   = "prod"
  vpc_id                        = var.vpc_id
  private_subnet_ids            = var.private_subnet_ids
  allowed_security_group_ids    = var.allowed_security_group_ids
  allowed_cidr_blocks           = var.allowed_cidr_blocks
  eks_cluster_security_group_id = var.eks_cluster_security_group_id
  db_name                       = var.db_name
  db_username                   = var.db_username
  db_password                   = var.db_password
  instance_class                = var.instance_class
  allocated_storage             = var.allocated_storage
  max_allocated_storage         = var.max_allocated_storage
  postgres_version              = var.postgres_version
  multi_az                      = true
  backup_retention_period       = 7
  deletion_protection           = true
  skip_final_snapshot           = false
  tags                          = var.tags
}