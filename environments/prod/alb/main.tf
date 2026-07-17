terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "managed-aws-terraform-state"
    key            = "prod/alb/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "managed-terraform-locks"
  }
}

provider "aws" { region = var.aws_region }

module "alb" {
  source = "../../../modules/alb"

  project_name               = var.project_name
  environment                = "prod"
  vpc_id                     = var.vpc_id
  public_subnet_ids          = var.public_subnet_ids
  certificate_arn            = var.certificate_arn
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  enable_deletion_protection = true
  tags                       = var.tags
}