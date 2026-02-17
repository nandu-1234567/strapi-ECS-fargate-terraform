variable "AWS_REGION" {}
variable "image_url" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
