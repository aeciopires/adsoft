include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "bucket" {
  path   = find_in_parent_folders("bucket.hcl")
  expose = true
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  location           = "us-central1"
  storage_class      = "STANDARD"
  bucket_policy_only = true

  public_access_prevention = "inherited"
  #force_destroy            = false

  website = {
    main_page_suffix = "index.html"
    not_found_page    = "404.html"
  }

  iam_members = [
    {
      role   = "roles/storage.objectViewer"
      member = "allUsers"
    },
  ]

  soft_delete_policy = {}

  #lifecycle_rules = [{
  #  action = {
  #    type = "Delete"
  #  }
  #  condition = {
  #    age = 7
  #  }
  #}]

  versioning = false

}
