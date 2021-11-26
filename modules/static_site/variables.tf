variable "acm_certificate_arn" {
  description = "ARN of ACM certificate to use"
  type        = string
}

variable "always_allow" {
  description = "Map of items to always allow, bypassing Lambda@Edge logic"
  type        = map(string)
  default = {
    css         = "/css/*",
    fontawesome = "/fontawesome/*",
    fonts       = "/fonts/*",
    images      = "/images/*",
    img         = "/img/*",
    js          = "/js/*",
    robots      = "/robots.txt",
    sitemap     = "/sitemap.xml",
  }
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

variable "redirect_lambda_arn" {
  description = "ARN for Lambda to run at edge for handling redirects / defaults"
  type        = string
}

variable "root_zone" {
  description = "Parent DNS zone name"
  type        = string
}

variable "waiting_room_lambda_arn" {
  description = "ARN for Lambda to run at edge for managing the waiting room"
  type        = string
  default     = ""
}

variable "ipv6_only" {
  description = "Set to true to stop serving A records"
  type        = bool
  default     = false
}
