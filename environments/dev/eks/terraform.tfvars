aws_region   = "us-west-1"
project_name = "margbooks"

# From dev/vpc outputs
vpc_id             = "vpc-0167795b6052eeed6"
private_subnet_ids = ["subnet-0fbe5fe0a3f3f8a5f", "subnet-0ac2f3f3eb2b9a0f0"]
public_subnet_ids  = ["subnet-02ebd18da4da797f0", "subnet-0513407c6288618a9"]

cluster_version     = "1.36"
node_instance_types = ["c7i-flex.large"]
node_desired_size   = 2
node_min_size       = 1
node_max_size       = 4
node_disk_size      = 50

# VPN CIDR — only way to reach EKS API
allowed_cidr_blocks = ["10.8.0.0/24"]

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "dev"
}