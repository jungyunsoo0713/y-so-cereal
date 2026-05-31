output "parameter_arns" {
  description = "ARNs of plain text parameters"
  value       = { for k, v in aws_ssm_parameter.app_env : k => v.arn }
}

output "secret_arns" {
  description = "ARNs of SecureString parameters"
  value       = { for k, v in aws_ssm_parameter.app_secrets : k => v.arn }
}

output "base_path" {
  description = "Base SSM path for this environment"
  value       = "/${var.project_name}/${var.environment}"
}
