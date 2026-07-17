aws_region   = "us-west-1"
project_name = "margbooks"

repository_names = [
  "margbooks/service-a",
  "margbooks/service-b",
  "margbooks/service-c"
]

image_tag_mutability = "MUTABLE"
max_image_count      = 20

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}