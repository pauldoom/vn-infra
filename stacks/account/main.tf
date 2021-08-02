provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

terraform {
  backend "s3" {
  }
}

# Terraform lock table
# tfsec:ignore:AWS086 No need to have backups for a lock file
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
