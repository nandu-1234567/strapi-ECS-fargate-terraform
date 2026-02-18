variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "strapi"
}

variable "vpc_id" {
  description = "VPC ID where ECS runs"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS EC2 instances"
  type        = list(string)
}

variable "image_tag" {
  description = "Docker image tag pushed from GitHub Actions"
  type        = string
}

variable "ecs_instance_profile_name" {
  description = "Existing EC2 instance profile name (IAM already created)"
  type        = string
}
