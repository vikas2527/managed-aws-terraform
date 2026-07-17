aws_region   = "us-west-1"
project_name = "margbooks"

# From dev/vpc outputs
vpc_id             = ""
private_subnet_ids = []

# From dev/eks outputs — EKS node SG
allowed_security_group_ids = []

# VPN CIDR — psql access from devtools
allowed_cidr_blocks = ["10.8.0.0/24"]

# Database config
db_name     = "margbooksdb"
db_username = "margbooks"
db_password = "vikas115"

instance_class        = "db.t3.medium"
allocated_storage     = 20
max_allocated_storage = 50
postgres_version      = "15.4"

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "dev"
}