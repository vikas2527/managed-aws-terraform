variable "aws_region" {
    description = "AWS region for the backend resources"
    type = string
    default = "us-west-1"
}

variable "state_bucket_name" {
    description = "S3 bucket name for terraform state"
    type = string
}

variable "lock_table_name" {
    description = "DynamoDB table name for state locking"
    type = string
    default = "managed-terraform-locks"
}