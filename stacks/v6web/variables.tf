variable "bucket_suffix" {
  description = "Name to append to end of S3 bucket name for global uniqueness"
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

variable "environ" {
  type    = string
  default = "dev"
}

variable "root_zone" {
  description = "Parent DNS zone name"
  type        = string
}

variable "static_site_fqdn" {
  description = "FQDN of static site"
  type        = string
}
