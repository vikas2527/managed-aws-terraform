aws_region   = "us-west-1"
project_name = "margbooks"
vpc_cidr     = "10.2.0.0/16"

availability_zones   = ["us-west-1a", "us-west-1c"]
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24"]

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "prod"
}