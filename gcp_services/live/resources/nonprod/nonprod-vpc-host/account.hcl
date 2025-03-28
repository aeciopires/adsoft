locals {
  project_id     = "nonprod-vpc-host" # CHANGE_HERE
  environment    = "nonprod"          # CHANGE_HERE
  env_short_name = "nprd"             # CHANGE_HERE
  domain_name    = "mydomain.com"     # CHANGE_HERE
  
  default_tags = {
    cost        = "shared"
    environment = local.environment
    terraform   = "true"
    iac         = "true"
  }
}
