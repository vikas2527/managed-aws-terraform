aws_region   = "us-west-1"
project_name = "margbooks"
vpc_cidr     = "10.1.0.0/16"

availability_zones   = ["us-west-1a", "us-west-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
  Environment = "dev"
}