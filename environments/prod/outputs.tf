output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_names" {
  value = module.ecs.service_names
}

output "ecr_repository_urls" {
  value = module.ecs.ecr_repository_urls
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}
