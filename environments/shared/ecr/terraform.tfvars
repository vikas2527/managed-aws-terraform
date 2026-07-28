aws_region   = "us-west-1"
project_name = "margbooks"

repository_names = [
  "margbooks/catalog-api",
  "margbooks/inventory-api",
  "margbooks/customer-api",
  "margbooks/order-api",
  "margbooks/notification-api",
  "margbooks/ui"
]

image_tag_mutability = "MUTABLE"
max_image_count      = 20

tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}