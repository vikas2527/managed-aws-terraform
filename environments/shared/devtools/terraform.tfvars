aws_region   = "us-west-1"
project_name = "margbooks"

# From shared/vpc outputs
vpc_id    = ""
subnet_id = ""

# Ubuntu 22.04 LTS us-west-1
ami_id        = "ami-0d50b6db6cff8ab82"
instance_type = "t3.medium"
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