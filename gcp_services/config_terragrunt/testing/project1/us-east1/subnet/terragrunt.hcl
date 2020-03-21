# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules_terraform/gcp/networking/subnet"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../network/vpc/"]
}

dependency "vpc" {
  config_path = "../../network/vpc/"
  mock_outputs = {
    vpc_name = "temporary-vpc-name"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  #VPC and subnet
  vpc_name    = dependency.vpc.outputs.vpc_name

  subnet_cidr = "172.19.255.128/25"
  subnet_name = "testing-project1"

  range_services = [
    {
      range_name = "testing-project1-pods"
      ip_cidr_range = "10.243.0.0/16"
    },
    {
      range_name = "testing-project1"
      ip_cidr_range = "10.242.0.0/16"
    }
  ]

  # Cloud router
  cloud_nat             = "nat-testing-project1"
  nat_name              = "nat-testing-project1"
  number_of_nat_address = 6
  cloud_router          = "router-testing-project1"
  nat_gateway_count     = 2
  min_ports_per_vm      = "1028"
}