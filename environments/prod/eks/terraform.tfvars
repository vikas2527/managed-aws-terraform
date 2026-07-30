aws_region   = "us-west-1"
project_name = "margbooks"

# From prod/vpc outputs
vpc_id             = "vpc-078ed36170e262bd5"
private_subnet_ids = ["subnet-0b6b83eabc840576f", "subnet-0ed0195de14a5349d"]
public_subnet_ids  = ["subnet-056de7cf4ee65e4a1", "subnet-0652431c6008686d2"]

cluster_version     = "1.36"
node_instance_types = ["t3.micro"]
node_desired_size   = 3
node_min_size       = 2
node_max_size       = 10
node_disk_size      = 100

# VPN CIDR + shared VPC CIDR
allowed_cidr_blocks = ["10.8.0.0/24", "10.0.0.0/16"]

# IAM roles for EKS access
devtools_role_arn = "arn:aws:iam::144410073815:role/margbooks-shared-devtools-role"
jenkins_role_arn  = "arn:aws:iam::144410073815:role/margbooks-shared-jenkins-role"

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "prod"
}