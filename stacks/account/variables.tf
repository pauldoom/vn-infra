variable "lock_table" {
  description = "DynamoDB table to use for Terraform locking"
  type        = string
}

variable "region" {
  description = "AWS region to create resources in by default"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket" {
  description = "S3 bucket to store Terraform state in"
  type        = string
}
