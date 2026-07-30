aws_region   = "us-west-1"
project_name = "margbooks"

# Shared VPC — from shared/vpc outputs
shared_vpc_id                 = "vpc-0ecda9eda26ce55a4"
shared_vpc_cidr               = "10.0.0.0/16"
shared_private_route_table_id = "rtb-06e3c3612ce75dd17"
shared_public_route_table_id  = "rtb-0f20024a2749ac275"

# Prod VPC — fill after prod/vpc is applied
prod_vpc_id                 = "vpc-078ed36170e262bd5"
prod_vpc_cidr               = "10.2.0.0/16"
prod_private_route_table_id = "rtb-095f88363c7e53f2b"
prod_public_route_table_id  = "rtb-0a121c79ad08da565"

vpn_cidr = "10.8.0.0/24"

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}