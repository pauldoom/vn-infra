provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
  }
}

# Terraform lock table
resource "aws_dynamodb_table" "tf_lock" {
  name           = var.lock_table
  read_capacity  = 2
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
