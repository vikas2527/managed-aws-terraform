aws_region   = "us-west-1"
project_name = "margbooks"

# From prod/vpc outputs
vpc_id             = ""
private_subnet_ids = []
public_subnet_ids  = []

cluster_version     = "1.29"
node_instance_types = ["t3.large"]
node_desired_size   = 3
node_min_size       = 2
node_max_size       = 10
node_disk_size      = 100

# VPN CIDR — only way to reach EKS API
allowed_cidr_blocks = ["10.8.0.0/24"]

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "prod"
}