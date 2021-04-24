variable "lock_table" {
  description = "DynamoDB table to use for Terraform locking"
  type        = string
}

variable "log_bucket" {
  description = "Where to store general logs"
  type        = string
}

variable "region" {
  description = "AWS region to create resources in by default"
  type        = string
  default     = "us-east-1"
}

variable "root_zone" {
  description = "Parent DNS zone name"
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket to store Terraform state in"
  type        = string
}

variable "static_dns_record_file" {
  description = "Optional Yaml file with static DNS records for root zone"
  type        = string
  default     = ""
}
