# Terraform Rollback Strategy

If a deployment issue is caused by **infrastructure changes in Terraform**, simply reverting the application code will solve the problem. In such cases, the Terraform-managed infrastructure must also be rolled back to its previous state using GitHub versioning.

## When to Rollback Terraform

- Incorrectly modified **VPC, subnets, or networking** configuration.
- Changes to **IAM roles/policies** that break application permissions.
- Misconfigured **RDS, EC2, or ALB** resources.
- Accidental deletion or replacement of critical resources.


## Rollback Process

1. **Identify the last known good commit**
   - Find the last stable version of Terraform code in GitHub.

2. **Revert GitHub**
   - Revert Terraform files to the previous working commit.
   - Commit and push to the repository.

3. **Redeploy Infrastructure**
   - Run the Terraform workflow again to apply the reverted code:
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

# Frontend Rollback Strategy

This part of the document outlines the strategy for rolling back the frontend in case of deployment issues.


## 1. When Rollback Occurs

Rollback is needed if the deployed frontend:

- Shows broken UI or fails to load correctly.
- Connects incorrectly to the backend API.


## 2. Rollback Mechanism

1. **Revert Code in GitHub**
   - Identify the last stable commit in the frontend repository.
   - Revert the repository to that commit:

     ```bash
     git revert <commit-sha-of-failed-deploy>
     git push origin main
     ```

2. **Trigger Pipeline**
   - Pushing the reverted commit triggers the existing GitHub Actions pipeline.
   - The pipeline will:
     - Install dependencies.
     - Build the frontend from the reverted code.
     - Deploy the build to the configured S3 bucket.

3. **Deployment**
   - The S3 bucket now serves the previous stable frontend build.
   - Versioning in S3 ensures that previous builds can be restored if needed.

# Backend Rollback Strategy

This part of rollback document outlines the automated rollback strategy for the backend service in the AWS deployment pipeline.


## 1. When Rollback Occurs

Rollback is triggered automatically if the **health-check job** fails after deployment. The failure indicates that the backend is not functioning correctly (e.g., API endpoints are failing, application errors).


## 2. Mechanism

1. **Health Check Failure Detection**
   - After deploying the backend and frontend, the workflow runs health checks:
     - `http://${{ secrets.EC2_HOST }}/healthz`
     - `http://${{ secrets.EC2_HOST }}/api/items/`
   - If any check fails, the `rollback-backend` job is triggered.

2. **Fetch Previous Docker Image**
   - The workflow lists images in **AWS ECR**.
   - It automatically identifies the **second latest image** (previous stable image) using:

     ```bash
     PREVIOUS_TAG=$(aws ecr describe-images \
       --repository-name <ECR_REPOSITORY> \
       --region <AWS_REGION> \
       --query "sort_by(imageDetails,& imagePushedAt)[-2].imageTags[0]" \
       --output text)
     ```

3. **Redeploy Previous Image on EC2**
   - SSH into the EC2 host and perform the following:
     1. Pull the previous Docker image from ECR.
     2. Tag it as `latest`.
     3. Restart containers using `docker-compose`:

     ```bash
     docker pull $ECR_REPOSITORY_URL:$PREVIOUS_TAG
     docker tag $ECR_REPOSITORY_URL:$PREVIOUS_TAG $ECR_REPOSITORY_URL:latest
     docker compose down
     docker compose up -d
     ```

4. **Run Post-Deployment Commands**
   - Ensure database is in sync and static files are updated:

     ```bash
     docker compose exec -T backend python manage.py makemigrations
     docker compose exec -T backend python manage.py migrate
     docker compose exec -T backend python manage.py collectstatic --noinput

     bash seed-values.sh $POSTGRES_HOST $POSTGRES_DB $POSTGRES_USER $POSTGRES_PASSWORD
     ```


## 3. Key Notes

- **No Rebuild Needed:** The rollback uses the **already built Docker image** from ECR, making it fast and reliable.  
- **Secrets:** Database credentials and other sensitive environment variables are fetched from **AWS SSM Parameter Store** at runtime.  
- **Automation:** The rollback is fully automated in the workflow and does not require manual intervention. 
---
