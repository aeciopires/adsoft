include "root" {
  path   = find_in_parent_folders("root.hcl")
}

include "static-public-ip" {
  path   = find_in_parent_folders("static-public-ip.hcl")
  expose = true
}

locals {}

inputs = {
  # The purpose of the resource(GCE_ENDPOINT, SHARED_LOADBALANCER_VIP, VPC_PEERING)
  # Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address.html#purpose
  purpose = "GCE_ENDPOINT"
  region  = ""
  global  = true
}
