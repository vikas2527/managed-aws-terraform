aws_region   = "us-west-1"
project_name = "margbooks"

# From prod/vpc outputs
vpc_id            = "vpc-078ed36170e262bd5"
public_subnet_ids = ["subnet-056de7cf4ee65e4a1", "subnet-0652431c6008686d2"]

# No ACM cert — using HTTP only for testing with vikasmargbooks.com
certificate_arn = ""

# Allow all internet traffic
allowed_cidr_blocks = ["0.0.0.0/0"]

tags = {
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Environment = "prod"
}