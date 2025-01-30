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

data "aws_ssm_parameter" "github_token" {
  name            = "/github/token"
  with_decryption = true
}

provider "github" {
  token = data.aws_ssm_parameter.github_token.value
}