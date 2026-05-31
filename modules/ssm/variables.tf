variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_parameters" {
  description = "Plain text parameters (non-sensitive)"
  type        = map(string)
  default     = {}
}

variable "app_secrets" {
  description = "Sensitive parameters stored as SecureString"
  type        = map(string)
  default     = {}
}
