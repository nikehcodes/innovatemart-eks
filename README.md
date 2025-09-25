# InnovateMart EKS Deployment

🧑‍💻 Author: Adefehinti Mary – ALT/SOE/024/2406

## Project Overview
This repository contains the Terraform and Kubernetes configurations for deploying the InnovateMart Retail Store Application on AWS EKS. The project, codenamed **Project Bedrock**, demonstrates:

- Infrastructure as Code (Terraform)
- Kubernetes deployment on EKS
- CI/CD automation using GitHub Actions
- Secure developer access with IAM roles

Key objectives:
Provision AWS resources programmatically with Terraform (IaC).
Deploy microservices in a Kubernetes cluster (EKS).
Secure developer access via IAM with least privilege.
Automate deployments via GitHub Actions.
Bonus: Managed persistence and networking (optional).

## Repository Structure

1. Create local project directory:
   ```
   mkdir -p ~/innovatemart-eks
   cd ~/innovatemart-eks
2. Initialize Git repository:
   ```
   git init
3. Create repository structure:
   ```
   mkdir -p terraform k8s-manifests/retail-store-app k8s-manifests/ingress scripts .github/workflows

## Directory Tree
```
innovatemart-eks/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── vpc.tf
│   ├── eks.tf
│   ├── iam.tf
│   └── versions.tf
├── k8s-manifests/
│   ├── retail-store-app/
│   └── ingress/
├── scripts/
│   └── setup-developer-access/
├── .github/
│   └── workflows/
└── README.md
```

- `terraform/` – Terraform configurations for VPC, EKS, IAM, and other AWS resources.
- `k8s-manifests/` – Kubernetes manifests for the retail-store app and ingress setup.
- `scripts/` – Deployment scripts and developer access setup.
- `.github/workflows/` – GitHub Actions workflows for Terraform automation.
## Push To Github
```
git add .
git commit -m "Initial commit: project structure"
git branch -M main
git remote add origin https://github.com/nikehcodes/innovatemart-eks.git
git push -u origin main
```
## Deployment
The GitHub Actions workflow automates:

1. Terraform initialization, planning, and applying.
2. Configuring `kubectl` to access the EKS cluster.
3. Deploying the retail-store application to the cluster.
4. Verifying pods and services.

## Access & Credentials
- **AWS Region:** `us-west-2`
- **Terraform state S3 bucket:** `innovatemart-terraform-state-us-west-2`
- **Terraform lock table:** `terraform-locks`
- **Developer IAM user:** Read-only access to view pods, services, and logs.

## Terraform Backend Setup
Create S3 bucket for Terraform state (manually via AWS Console):
Bucket name: innovatemart-terraform-state-us-west-2
Enable encryption (SSE-S3 or SSE-KMS)
Create DynamoDB table for locks:
Table name: terraform-locks
Configure backend in terraform/versions.tf:

## Deployment Scripts
Configured IAM read-only access and kubernetes RBAC
```
#!/bin/bash
kubectl apply -f k8s-manifests/retail-store-app/
kubectl apply -f k8s-manifests/ingress/
```
## GitHubs Actions Workflow
GitHub Actions workflow automates the entire deployment process. On every push, it checks out the repository, configures AWS credentials securely, and runs Terraform to provision the infrastructure. Then it installs kubectl, sets up access to the EKS cluster, and deploys all Kubernetes manifests. Finally, it verifies that all pods and services are running, ensuring the Retail Store Application is live and ready for use.


## Verification
After deployment, verification of the cluster:

```
kubectl get pods -A
kubectl get svc -A

