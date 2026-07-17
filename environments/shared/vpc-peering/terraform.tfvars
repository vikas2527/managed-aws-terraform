aws_region   = "us-west-1"
project_name = "margbooks"

# From shared/vpc outputs
shared_vpc_id                 = ""
shared_vpc_cidr               = "10.0.0.0/16"
shared_private_route_table_id = ""

# From dev/vpc outputs
dev_vpc_id                 = ""
dev_vpc_cidr               = "10.1.0.0/16"
dev_private_route_table_id = ""

# From prod/vpc outputs
prod_vpc_id                 = ""
prod_vpc_cidr               = "10.2.0.0/16"
prod_private_route_table_id = ""

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}