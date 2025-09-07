# ECR repository for storing backend Docker images with image scanning enabled
resource "aws_ecr_repository" "backend" {
  name = "${var.project_name}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}
  