terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "managed-aws-terraform-state"
    key            = "shared/vpn/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "managed-terraform-locks"
  }
}

provider "aws" { region = var.aws_region }

module "vpn" {
  source = "../../../modules/vpn"

  project_name     = var.project_name
  environment      = "shared"
  vpc_id           = var.vpc_id
  public_subnet_id = var.public_subnet_id
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  vpn_cidr         = var.vpn_cidr
  vpc_cidr         = var.vpc_cidr
  dev_vpc_cidr     = var.dev_vpc_cidr
  prod_vpc_cidr    = var.prod_vpc_cidr
  root_volume_size = var.root_volume_size
  tags             = var.tags
}