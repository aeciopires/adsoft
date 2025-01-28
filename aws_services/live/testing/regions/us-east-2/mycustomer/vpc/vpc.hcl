locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  vpc_name    = "${basename(get_terragrunt_dir())}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/vpc/aws//?version=5.18.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name                      = local.vpc_name
  create_vpc                = true
  cidr                      = ""
  azs                       = []
  public_subnets            = []
  private_subnets           = []
  create_igw                = true
  enable_dns_support        = true
  enable_dns_hostnames      = true
  enable_vpn_gateway        = false
  enable_ipv6               = false
  enable_s3_endpoint        = true
  enable_public_s3_endpoint = true
  enable_nat_gateway        = true
  single_nat_gateway        = false
  one_nat_gateway_per_az    = true
  public_subnet_tags        = {}
  private_subnet_tags       = {}
  vpc_tags                  = {}
  vpc_endpoint_tags         = {}
  tags                      = {}
}
