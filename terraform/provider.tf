terraform {
  backend "s3" {
    bucket = "cicd-demo-tfstate-660452448280"
    key = "infra/terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=3.51.0"
    }
  }

  required_version = ">=1.0.0"
}

provider "aws" {
  region = "eu-central-1"
  profile = "cicd-demo"
}