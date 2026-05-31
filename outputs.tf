output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name (entry point for all services)"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_names" {
  description = "ECS service names per microservice"
  value       = module.ecs.service_names
}

output "ecr_repository_urls" {
  description = "ECR repository URLs per microservice"
  value       = module.ecs.ecr_repository_urls
}

output "github_actions_role_arn" {
  description = "IAM Role ARN for GitHub Actions OIDC"
  value       = module.iam.github_actions_role_arn
}
