aws_region   = "us-west-1"
project_name = "margbooks"

# From shared/vpc outputs
vpc_id    = "vpc-0ecda9eda26ce55a4"
subnet_id = "subnet-08fe0a2331e30d209"

# Ubuntu 22.04 LTS us-west-1
ami_id        = "ami-009e3ea390d774636"
instance_type = "t3.micro"
key_name      = "vikas-k8s-key"
vpn_cidr      = "10.8.0.0/24"

root_volume_size = 30

# Fill after dev/eks and prod/eks are created
eks_cluster_names = [
  "margbooks-dev-eks",
  "margbooks-prod-eks"
]

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}