terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
  
  backend "s3" {
    bucket = "innovatemart-terraform-state-us-west-2"
    key    = "eks/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
    dynamodb_table = "terraform-locks"
  }
}
