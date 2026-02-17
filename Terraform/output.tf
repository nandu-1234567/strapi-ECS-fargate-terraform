output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.strapi.repository_url
}

output "ecs_service_name" {
  value = aws_ecs_service.strapi.name
}
