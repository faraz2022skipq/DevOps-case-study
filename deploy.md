# Deployment Guide

This document provides detailed steps for deploying and tearing down the infrastructure and application.

---

## Prerequisites

Before starting, ensure you have the following installed and configured:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5  
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with valid credentials  
- [Docker](https://docs.docker.com/get-docker/) for local builds (optional)  
- Git  

---

## Deployment Steps

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd DevOps-case-study
   ```

2. **Provision infrastructure with Terraform**
    ## Initialize Terraform
    ```bash
    terraform init
    ```
    ## Validate Terraform
    ```bash
    terraform validate
    ```
    ## Plan Terraform
    ```bash
    terraform plan
    ```

    ## Apply changes
    ```bash
    terraform apply -auto-approve
    ```


This will create the required AWS resources (VPC, subnets, EC2, RDS, S3, ECR, IAM roles, etc.).

3. **Make required changes in the code (Update application files as needed) then push changes to the main branch**

  ```bash
  git add .
  git commit -m "Your message"
  git push origin main
  ```

## Teardown / Cleanup

- Empty the S3 bucket  
- Delete all images from the ECR repository  
- Run `terraform destroy` to remove all infrastructure  
