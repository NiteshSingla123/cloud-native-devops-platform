provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "nitesh-terraform-state-bucket-12345"
    key            = "devops-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nitesh-terraform-state-lock"
  }
}


