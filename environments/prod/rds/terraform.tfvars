aws_region   = "us-west-1"
project_name = "margbooks"

# From prod/vpc outputs
vpc_id             = "vpc-078ed36170e262bd5"
private_subnet_ids = ["subnet-0b6b83eabc840576f", "subnet-0ed0195de14a5349d"]

# From prod/eks outputs — fill after prod/eks apply
allowed_security_group_ids    = ["sg-043b394ae2788e486"]
eks_cluster_security_group_id = "sg-079de26fe3267159d"

# VPN CIDR — psql access from devtools
allowed_cidr_blocks = ["10.8.0.0/24"]

# Database config
db_name     = "margbooksdb"
db_username = "margbooks"
db_password = "vikas115"

instance_class        = "db.t4g.micro"
allocated_storage     = 100
max_allocated_storage = 500
postgres_version      = "18.3"

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "prod"
}