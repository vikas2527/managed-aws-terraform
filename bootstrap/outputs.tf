output "state_bucket_name" {
    description = "S3 bucket used for Terraform state file"
    value = aws_s3_bucket.state.bucket
}

output "lock_table_name" {
    description = "DynamoDB table used for state locking"
    value = aws_dynamodb_table.locks.name  
}