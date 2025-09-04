resource "aws_ssm_parameter" "django_secret_key" {
  name  = "/${var.project_name}/django/secret_key"
  type  = "SecureString"
  value = "very-secret-key"

  tags = {
    Name        = "${var.project_name}-django-secret"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "database_url" {
  name  = "/${var.project_name}/django/database_url"
  type  = "SecureString"
  value = "postgresql://${aws_db_instance.postgres.username}:${random_password.db_password.result}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"

  tags = {
    Name        = "${var.project_name}-database-url"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "database_host" {
  name  = "/${var.project_name}/django/database_host"
  type  = "String"
  value = aws_db_instance.postgres.address

  tags = {
    Name        = "${var.project_name}-database-host"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "database_name" {
  name  = "/${var.project_name}/django/database_name"
  type  = "String"
  value = aws_db_instance.postgres.db_name

  tags = {
    Name        = "${var.project_name}-database-name"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "database_user" {
  name  = "/${var.project_name}/django/database_user"
  type  = "String"
  value = aws_db_instance.postgres.username

  tags = {
    Name        = "${var.project_name}-database-user"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "database_password" {
  name  = "/${var.project_name}/django/database_password"
  type  = "SecureString"
  value = random_password.db_password.result

  tags = {
    Name        = "${var.project_name}-database-password"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "region" {
  name  = "/${var.project_name}/aws/region"
  type  = "String"
  value = var.aws_region

  tags = {
    Name        = "${var.project_name}-aws-region"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "ecr_image_tag" {
  name  = "/${var.project_name}/ecr/image_tag"
  type  = "String"
  value = var.image_tag

  tags = {
    Name        = "${var.project_name}-ecr-image-tag"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "ecr_repo_url" {
  name  = "/${var.project_name}/ecr/repo_url"
  type  = "String"
  value = aws_ecr_repository.backend.repository_url

  tags = {
    Name        = "${var.project_name}-ecr-repo-url"
    Environment = var.environment
  }
}
