variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "container_port" {
  description = "Port exposed by all containers"
  type        = number
  default     = 8080
}

variable "container_cpu" {
  description = "CPU units per task"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory in MiB per task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks per service"
  type        = number
  default     = 1
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "services" {
  description = "List of microservice names to deploy"
  type        = list(string)
  default     = ["cart", "catalog", "checkout", "orders", "ui"]
}
