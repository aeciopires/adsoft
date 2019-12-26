# Configure the AWS Cloud provider
provider "aws" {
  region = var.aws_zone
}

# Creating module
module "instances" {
  # Module location  
  source = "./modules/application"
}

# Not yet used
#terraform {
#  backend "s3" {
#    bucket = "zabbixbr_terraform"
#    key    = "terraformt.tfstate"
#    region = "us-east-1"
#  }
#}