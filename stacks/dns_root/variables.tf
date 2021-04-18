variable "region" {
  description = "AWS region to create resources in by default"
  type        = string
  default     = "us-east-1"
}

variable "root_domain" {
  description = "Top level DNS zone name"
}

variable "default_ttl" {
  description = "Default TTL for records"
  type        = string
  default     = "300"
}

variable "static_rrs" {
  description = "List of additional resource records to manage for zone"
  type        = list(map(string))

  # Each entry is a map with a name, type, and list of records (values)
  # You can supply and optional TTL.
  #
  # Example:
  # static_rrs = [
  #   {
  #     name = "donuts",
  #     type = "A",
  #     ttl  = "300",
  #     records = [
  #       "1.2.3.4"
  #     ]
  #   },
  #   {
  #     name    = "fritters",
  #     type    = "CNAME",
  #     records = ["donuts.fqdn."],
  #   }
  # ]

  default = []
}
