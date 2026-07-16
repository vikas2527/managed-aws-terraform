terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket = "vikas-k8s-terraform-state"
    key = "shared/jenkins/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "vikas-k8s-terraform-locks"
    encrypt = "true"    
  }
}

provider "aws"{
    region = var.aws_region
}

# Jenkins user_data — installs Java, Jenkins, Docker, kubectl, helm on boot


