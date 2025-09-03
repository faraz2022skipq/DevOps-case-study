variable "aws_region" {
  default = "us-west-1"
}

variable "project_name" {
  default = "junior-devops-case-study"
}

variable "db_username" {
  default = "appuser"
}

variable "db_password" {
  description = "DB password"
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "github_org" {
  description = "GitHub organization/username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "image_tag" {
  description = "ECR image tag"
  type        = string
  default     = "latest"
}
