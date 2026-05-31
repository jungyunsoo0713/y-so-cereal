output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_names" {
  description = "Map of service name to ECS service name"
  value       = { for k, v in aws_ecs_service.services : k => v.name }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecr_repository_urls" {
  description = "Map of service name to ECR repository URL"
  value       = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}
