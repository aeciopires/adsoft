# Configure the AWS Cloud provider
provider "aws" {
  region = var.aws_zone
}

# Saving state in AWS-S3
terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  # Terragrunt config is defined in environment directory.
  backend "s3" {}
}

#----------
# OLD configuration without using Terragrunt
# Using variables does NOT work here!
#terraform {
#  backend "s3" {
#    encrypt        = true
#    bucket         = "adsoft"
#    key            = "aws_services/terraform.tfstate"
#    region         = "us-east-2"
#    dynamodb_table = "terraform"
#  }
#}
#----------