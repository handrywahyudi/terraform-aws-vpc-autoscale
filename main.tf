terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure AWS provider
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}