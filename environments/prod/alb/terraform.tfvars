aws_region   = "us-west-1"
project_name = "margbooks"

# From prod/vpc outputs
vpc_id            = ""
public_subnet_ids = []

# ACM certificate ARN — add after creating certificate in AWS
certificate_arn = ""

# Allow all internet traffic
allowed_cidr_blocks = ["0.0.0.0/0"]

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "prod"
}