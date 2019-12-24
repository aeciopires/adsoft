# Configure the AWS Cloud provider
provider "aws" {
  region = var.aws_zone
}

# Creating module
module "instances" {
  # Module location  
  source               = "./modules/application"
}