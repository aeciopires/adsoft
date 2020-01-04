# Configure the AWS Cloud provider
provider "aws" {
  region = var.aws_zone
}

# Creating module
module "instances" {
  source = "./modules/application"
  #aws_key_name         = var.aws_key_name
  #aws_connection_type  = var.aws_connection_type
  #aws_key_private_path = var.aws_key_private_path
  #aws_key_public_path  = var.aws_key_public_path
  #aws_instance_user    = var.aws_instance_user
  #operating_system     = var.operating_system
  #permission_read_only = var.permission_read_only
  #port_ssh_external    = var.port_ssh_external
  #port_http_external   = var.port_http_external
  #port_protocol        = var.port_protocol
  #address_allowed      = var.address_allowed
}
