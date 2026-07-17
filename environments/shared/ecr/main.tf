terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "managed-aws-terraform-state"
    key            = "shared/ecr/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "managed-terraform-locks"
  }
}

provider "aws" { region = var.aws_region }

module "ecr" {
  source = "../../../modules/ecr"

  project_name         = var.project_name
  repository_names     = var.repository_names
  image_tag_mutability = var.image_tag_mutability
  max_image_count      = var.max_image_count
  tags                 = var.tags
}