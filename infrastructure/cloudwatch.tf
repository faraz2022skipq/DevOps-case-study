# Create CloudWatch Log Groups for Django and Nginx logs
resource "aws_cloudwatch_log_group" "django_app" {
  name              = "/aws/ec2/${var.project_name}/django"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-django-logs"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/aws/ec2/${var.project_name}/nginx"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-nginx-logs"
    Environment = var.environment
  }
}

# Alarm when EC2 instance CPU utilization exceeds threshold
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  tags = {
    Name        = "${var.project_name}-high-cpu-alarm"
    Environment = var.environment
  }
}

# Alarm when RDS instance CPU utilization exceeds threshold
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "${var.project_name}-database-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors RDS cpu utilization"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgres.id
  }

  tags = {
    Name        = "${var.project_name}-database-cpu-alarm"
    Environment = var.environment
  }
}

# CloudWatch dashboard showing CPU and DB metrics
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.app.id],
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.postgres.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", aws_db_instance.postgres.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Database Connections"
        }
      }
    ]
  })
}
