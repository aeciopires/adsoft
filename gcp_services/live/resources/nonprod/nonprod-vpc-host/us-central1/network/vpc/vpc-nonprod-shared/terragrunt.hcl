include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "vpc" {
  path   = find_in_parent_folders("vpc.hcl")
  expose = true
}

locals {}

inputs = {
  auto_create_subnetworks                = false
  routing_mode                           = "GLOBAL"
  shared_vpc_host                        = true
  enable_ipv6_ula                        = false
  delete_default_internet_gateway_routes = false

  # The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). 
  # Recommended values: 1460 (default for historic reasons),
  #                     1500 (Internet default), or
  #                     8896 (for Jumbo packets).
  # Allowed are all values in the range 1300 to 8896, inclusively.
  mtu = 1460
}
