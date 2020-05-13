# Terraform backend for remote state
terraform {
  backend "s3" {
    encrypt                 = true
    bucket                  = "terraform-remote-state-adsoft"
    dynamodb_table          = "terraform-state-lock-dynamo"
    region                  = "us-east-2"
    workspace_key_prefix    = "testing"
    key                     = "eks/terraform.tfstate"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
}
