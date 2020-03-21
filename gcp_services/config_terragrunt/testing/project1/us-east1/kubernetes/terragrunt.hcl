# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules_terraform/gcp/kubernetes"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../../network/vpc", "../../subnet"]
}

dependency "vpc" {
  config_path = "../../network/vpc"

  mock_outputs = {
    vpc_name = "temporary-vpc-name"
  }
}

dependency "subnet" {
  config_path = "../subnet"

  mock_outputs = {
    subnet_name = "temporary-subnetwork-name"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  cluster_name            = "testing-project1"
  ip_range_pods           = "testing-project1-pods"
  ip_range_services       = "testing-project1"
  master_ipv4_cidr_block  = "192.168.4.80/28"

  network     = dependency.vpc.outputs.vpc_name
  subnetwork  = dependency.subnet.outputs.subnet_name
  zones       = ["us-east1-b", "us-east1-c", "us-east1-d"]

  master_authorized_networks_display_name = "myipadress-public"
  master_authorized_networks              = "179.159.238.150/32" //my ip address
  k8s_version                             = "1.14.10-gke.17"

  services_np = {
    name = "adsoft"
    initial_node_count = 1
    min_count = 1
    max_count = 2
    machine_type = "n1-standard-1"
    disk_size_gb = 20
    disk_type = "pd-ssd"
    auto_repair = "true"
    auto_upgrade = "false"
    preemptible = "true"
  }

  scost = "testing-project1-t0"
}
