aws_region   = "us-west-1"
project_name = "margbooks"

# From shared/vpc outputs
vpc_id           = ""
public_subnet_id = ""

# Ubuntu 22.04 LTS us-west-1
ami_id        = "ami-0d50b6db6cff8ab82"
instance_type = "t3.small"
key_name      = "vikas-k8s-key"

# VPN tunnel network
vpn_cidr = "10.8.0.0/24"

# VPC CIDRs — pushed to VPN clients as routes
vpc_cidr      = "10.0.0.0/16"
dev_vpc_cidr  = "10.1.0.0/16"
prod_vpc_cidr = "10.2.0.0/16"

root_volume_size = 20

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}