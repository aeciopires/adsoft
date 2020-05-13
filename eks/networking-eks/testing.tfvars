# Provider config
profile = "default"
region  = "us-east-2"

# General
tags = {
  Scost       = "testing",
  Terraform   = "true",
  Environment = "testing",
}

environment                = "testing"
aws_key_name               = "aws-teste"
aws_public_key_path        = "/home/aws-teste.pub"
# MyIPAdress
address_allowed            = "179.159.238.22/32"
bucket_name                = "terraform-remote-state-adsoft"
dynamodb_table_name        = "terraform-state-lock-dynamo"
vpc1_cidr_block            = "10.0.0.0/16"
subnet_public1_cidr_block  = "10.0.1.0/24"
subnet_private1_cidr_block = "10.0.3.0/24"
