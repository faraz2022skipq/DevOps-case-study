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

1. ## **Clone the repository**
   ```bash
   git clone <repo-url>
   cd DevOps-case-study
   ```

2. ## **Provision infrastructure with Terraform**
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

3. ### **Configure GitHub Actions: add repository Secrets & Variables**

    Go to your GitHub repo: **Settings → Secrets and variables → Actions**.

    - Click **New repository secret** and add all items from the *Required repository secrets* table below.  
    - Click **New variable** and add all items from the *Required repository variables* table below.  

    > **Note**: Secrets are encrypted and masked in logs; Variables are plain config values used by workflows.

    ---

    #### Required repository secrets

    | Name            | Description |
    |-----------------|-------------|
    | **AWS_ROLE_ARN** | ARN of the IAM role that GitHub Actions assumes via OIDC to access your AWS account. |
    | **EC2_HOST**     | Public IPv4 address of the target EC2 instance used for deployment/SSH. |
    | **EC2_SSH_KEY**  | Private SSH key (PEM) for the above EC2 host; paste the key contents as the secret. |
    | **EC2_USER**     | SSH username for EC2 (e.g., `ubuntu` or `ec2-user`). |
    | **S3_BUCKET_NAME** | Name of the S3 bucket used by the pipeline (e.g., for static files or artifacts). |

    ---

    #### Required repository variables

    | Name             | Description |
    |------------------|-------------|
    | **AWS_REGION**     | AWS region used by the workflows (e.g., `ap-south-1`). |
    | **ECR_REPOSITORY** | Name of the ECR repository where images are pushed. |
    | **PROJECT_NAME**   | Short project identifier used for tagging and resource names. |


4. **Make required changes in the code (Update application files as needed) then push changes to the main branch**

    ```bash
    git add .
    git commit -m "Your message"
    git push origin main
    ```

## Teardown / Cleanup

  - Empty the S3 bucket  
  - Delete all images from the ECR repository  
  - Run `terraform destroy` to remove all infrastructure  
