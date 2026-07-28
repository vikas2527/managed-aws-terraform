aws_region   = "us-west-1"
project_name = "margbooks"

shared_vpc_id                 = "vpc-0ecda9eda26ce55a4"
shared_vpc_cidr               = "10.0.0.0/16"
shared_private_route_table_id = "rtb-06e3c3612ce75dd17"

dev_vpc_id                 = "vpc-0167795b6052eeed6"
dev_vpc_cidr               = "10.1.0.0/16"
dev_private_route_table_id = "rtb-03d32bfbc9d3c4bab"

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}