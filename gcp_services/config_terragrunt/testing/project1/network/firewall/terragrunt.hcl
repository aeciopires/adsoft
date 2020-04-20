# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules_terraform/gcp/networking/firewall"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../vpc",
    "../../us-east1/kubernetes/"
  ]
}

dependency "vpc" {
  config_path = "../vpc"
  #skip_outputs = true
  #mock_outputs = {
  #  vpc_name = "testing-project1"
  #}
}

# Reference about error "set the skip_outputs flag to true on the dependency block"
# https://myshittycode.wordpress.com/author/choonchern-2/ 
#https://community.gruntwork.io/t/dependency-mock-outputs-and-terragrunt-plan/346/2

#US-EAST1 Resources

dependency "us_east1_subnet" {
  config_path = "../../us-east1/subnet"
}

dependency "us_east1_testing_project1_k8s" {
  config_path = "../../us-east1/kubernetes/"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  network_customer  = dependency.vpc.outputs.vpc_name
  myipaddress_public = "179.159.238.22/32" //my IP address

  # List Source valid IP (my IP address)
  list_valid_ip = [
    "179.159.238.22/32", 
    "157.245.67.254/32",
  ]

  subnet_cidr       = [
    dependency.us_east1_subnet.outputs.subnet_ip_cidr_range,
  ]

  testing_project1_cluster_name = [
    dependency.us_east1_testing_project1_k8s.outputs.cluster_name
  ]
  testing_project1_cluster_location  = [
    dependency.us_east1_testing_project1_k8s.outputs.cluster_location
  ]
}
