# EC2 instance with Docker, AWS CLI, and CloudWatch Agent installed via user_data
resource "aws_instance" "app" {
  ami                         = "ami-00271c85bf8a52b84"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  key_name                    = aws_key_pair.case_study_key_pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
      #!/bin/bash
      set -e

      # Update system
      apt-get update -y
      apt-get upgrade -y

      # Install dependencies
      apt-get install -y ca-certificates curl gnupg lsb-release unzip

      # Add Docker’s official GPG key and repository
      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

      # Install Docker and plugins
      apt-get update -y
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      usermod -aG docker ubuntu

      # Install AWS CLI v2
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      ./aws/install
      rm -rf awscliv2.zip aws/

      # Install CloudWatch Agent
      curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
      dpkg -i -E ./amazon-cloudwatch-agent.deb
      rm amazon-cloudwatch-agent.deb
      mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
      systemctl enable amazon-cloudwatch-agent

      # Verify installations
      docker --version
      docker compose version
      aws --version
      /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -version

      # Create app directory
      mkdir -p /home/ubuntu/app/
      chown ubuntu:ubuntu /home/ubuntu/app/

      echo "All installations completed successfully!"
      EOF

  tags = { Name = "${var.project_name}-ec2" }
}

# Generate TLS private key for SSH
resource "tls_private_key" "case_study_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair using the generated TLS key
resource "aws_key_pair" "case_study_key_pair" {
  key_name   = "case_study_key_pair"
  public_key = tls_private_key.case_study_key.public_key_openssh
}

# Save private key locally as PEM file for SSH access
resource "local_file" "private_key" {
  content         = tls_private_key.case_study_key.private_key_pem
  filename        = "${path.module}/case_study_key_pair.pem"
  file_permission = "0600"
}

