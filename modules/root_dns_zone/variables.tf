variable "alarm_actions" {
  description = "List of actions to trigger on transition between OK and ALARM states"
  # See https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarms-and-actions
  # for more on the types of actions.
  type    = list(string)
  default = []
}

variable "default_ttl" {
  description = "Default TTL for records"
  type        = string
  default     = "300"
}
variable "region" {
  description = "AWS region to create resources in by default"
  type        = string
  default     = "us-east-1"
}

variable "root_zone" {
  description = "Top level DNS zone name"
}

terraform {
  # Allow use of optional() below
  experiments = [module_variable_optional_attrs]
}

variable "static_records" {
  description = "List of additional resource records to manage for zone"
  type = list(object({
    name    = string,
    type    = string,
    ttl     = optional(string),
    records = list(string)
  }))
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
  #   },
  #     # Record with name of root and the default ttl
  #     name    = "",
  #     type    = "A",
  #     records = ["10.11.12.14"]
  # ]
  default = []
}
