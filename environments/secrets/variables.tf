variable "project_name" {
  type    = string
  default = "y-so-cereal"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "app_secrets" {
  description = "Sensitive secrets - set in terraform.tfvars (never commit)"
  type        = map(string)
  default     = {}
}
