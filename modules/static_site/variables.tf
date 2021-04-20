variable "acm_certificate_arn" {
  description = "ARN of ACM certificate to use"
  type        = string
}

variable "bucket_suffix" {
  description = "Name to append to end of S3 bucket name for global uniqueness"
  type        = string
}

variable "environ" {
  description = "Environment name"
  type        = string
}

variable "fqdn" {
  description = "FQDN to serve"
  type        = string
}

variable "log_bucket" {
  description = "Where to dump logs"
  type        = string
}

variable "root_zone" {
  description = "Parent DNS zone name"
  type        = string
}
