provider "aws" {
  region = var.region
}

# -------------------------
# ECR REPOSITORY
# -------------------------
resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-repo"
}

# -------------------------
# ECS CLUSTER
# -------------------------
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
}

# -------------------------
# ECS-OPTIMIZED AMI
# -------------------------
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# -------------------------
# LAUNCH TEMPLATE (USES EXISTING IAM ROLE)
# -------------------------
resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = data.aws_ami.ecs.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = var.ecs_instance_profile_name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config
EOF
  )
}

# -------------------------
# AUTO SCALING GROUP
# -------------------------
resource "aws_autoscaling_group" "ecs" {
  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
}

# -------------------------
# ECS TASK DEFINITION
# -------------------------
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "${aws_ecr_repository.this.repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
    }
  ])
}

# -------------------------
# ECS SERVICE
# -------------------------
resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "EC2"
}

