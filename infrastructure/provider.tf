# Configure Terraform and AWS provider version requirements
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS provider configuration
provider "aws" {
  region = var.aws_region
}
