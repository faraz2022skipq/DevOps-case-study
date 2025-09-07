# RDS PostgreSQL instance for application database
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  db_name                = "appdb"
  username               = var.db_username
  password               = random_password.db_password.result
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
}

# DB subnet group spanning multiple subnets
resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

# Securely generate random DB password
resource "random_password" "db_password" {
  length  = 16
  special = false
}
