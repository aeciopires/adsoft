# Configure the AWS Cloud provider
provider "aws" {
  region = var.aws_zone
}

# Saving state in AWS-S3
#terraform {
#  backend "s3" {
#    encrypt = true
#    bucket  = var.s3_bucket_name
#    key     = "aws_services/terraform.tfstate"
#    region  = var.aws_zone
#  }
#}