terraform {
  backend "s3" {
    bucket         = "become-techgeek-tfstate-demo"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}