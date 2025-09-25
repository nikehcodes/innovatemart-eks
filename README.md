# InnovateMart EKS Deployment

## Project Overview
This repository contains the Terraform and Kubernetes configurations for deploying the InnovateMart Retail Store Application on AWS EKS. The project, codenamed **Project Bedrock**, demonstrates:

- Infrastructure as Code (Terraform)
- Kubernetes deployment on EKS
- CI/CD automation using GitHub Actions
- Secure developer access with IAM roles

## Repository Structure
- `terraform/` – Terraform configurations for VPC, EKS, IAM, and other AWS resources.
- `k8s-manifests/` – Kubernetes manifests for the retail-store app and ingress setup.
- `scripts/` – Deployment scripts and developer access setup.
- `.github/workflows/` – GitHub Actions workflows for Terraform automation.

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

## Verification
After deployment, verify the cluster:

```bash
kubectl get pods -A
kubectl get svc -A

