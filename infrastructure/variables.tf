# AWS region for resource deployment
variable "aws_region" {
  description = "AWS region where all resources will be created"
  default     = "us-west-1"
}

# Project name used for tagging and resource naming
variable "project_name" {
  description = "Name prefix for project resources"
  default     = "junior-devops-case-study"
}

# Database username
variable "db_username" {
  description = "Master username for the PostgreSQL database"
  default     = "appuser"
}

# Environment name
variable "environment" {
  description = "Environment identifier (e.g., dev, staging, production)"
  type        = string
  default     = "production"
}

# GitHub organization or username for repository
variable "github_org" {
  description = "GitHub organization or user that owns the repository"
  type        = string
}

# GitHub repository name
variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

# ECR image tag to deploy
variable "image_tag" {
  description = "Docker image tag for the backend service (default: latest)"
  type        = string
  default     = "latest"
}
