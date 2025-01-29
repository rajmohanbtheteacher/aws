terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source = "integrations/github"
      version = "6.5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

provider "github" {
 token = var.github_token
}