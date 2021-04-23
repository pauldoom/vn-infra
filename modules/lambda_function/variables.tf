variable "environ" {
  description = "Environment name"
  type        = string
}

variable "function_name" {
  description = "Function name - Must exist under top level functions/ directory"
  type        = string
}

variable "function_entrypoint" {
  description = "Entry method in function"
  type        = string
  default     = "handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
}
