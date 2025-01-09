locals {
  # The organization id for the associated resources
  org_id             = "111111111111"      # CHANGE_HERE
  project_id         = "nonprod-myproduct" # CHANGE_HERE
  environment        = "nonprod"           # CHANGE_HERE
  env_short_name     = "nprd"              # CHANGE_HERE
  domain_name        = "mydomain.com"      # CHANGE_HERE
  network_project_id = "nonprod-vpc-host"  # CHANGE_HERE

  default_tags = {
    cost        = "myproduct"              # CHANGE_HERE
    environment = local.environment
    terraform   = "true"
    iac         = "true"
  }
}
