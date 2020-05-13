# Terraform backend for remote state
terraform {
  backend "s3" {
    encrypt                 = true
    bucket                  = "adsoft-eks-testing"
    dynamodb_table          = "terraform-eks"
    region                  = "us-east-2"
    workspace_key_prefix    = "testing"
    key                     = "terraform.tfstate"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
}
