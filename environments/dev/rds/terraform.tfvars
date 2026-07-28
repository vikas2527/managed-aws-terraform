aws_region   = "us-west-1"
project_name = "margbooks"

# From dev/vpc outputs
vpc_id             = "vpc-0167795b6052eeed6"
private_subnet_ids = ["subnet-0fbe5fe0a3f3f8a5f", "subnet-0ac2f3f3eb2b9a0f0"]

# From dev/eks outputs — EKS node SG
allowed_security_group_ids = ["sg-0509cb5b90cae9a96"]

# VPN CIDR — psql access from devtools
allowed_cidr_blocks = ["10.8.0.0/24"]

# Database config
db_name     = "margbooksdb"
db_username = "margbooks"
db_password = "vikas115"

instance_class        = "db.t4g.micro"
allocated_storage     = 20
max_allocated_storage = 50
postgres_version      = "18.3"

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "dev"
}