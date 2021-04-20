variable "environ" {
  description = "Environment name"
  type        = string
}

variable "fqdn" {
  description = "FQDN to serve"
  type        = string
}

variable "root_zone" {
  description = "Parent DNS zone name"
  type        = string
}
