locals {
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region         = local.region_vars.locals.region
  env_short_name = local.account_vars.locals.env_short_name
  default_tags   = local.account_vars.locals.default_tags
  project_id     = local.account_vars.locals.project_id
  # Change according the project
  gke_service_account = "000000000000-compute@developer.gserviceaccount.com"
}

terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/private-cluster?version=35.0.1"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  #--------------------------
  # General
  #--------------------------
  project_id = local.project_id
  region     = local.region
  regional   = true


  #--------------------------
  # MISCELLANEOUS
  #--------------------------
  service_account        = local.gke_service_account
  create_service_account = false


  # The Kubernetes version of the master and nodes in the cluster.
  # More info:
  # https://cloud.google.com/kubernetes-engine/docs/release-notes
  # https://cloud.google.com/kubernetes-engine/docs/release-schedule
  # https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
  # https://cloud.google.com/kubernetes-engine/versioning
  kubernetes_version = ""
  # The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`.
  release_channel    = "REGULAR"


  #--------------------------
  # Registry
  #--------------------------
  grant_registry_access = true


  #--------------------------
  # Addons
  #--------------------------
  http_load_balancing             = true
  enable_l4_ilb_subsetting        = true
  gce_pd_csi_driver               = true
  filestore_csi_driver            = true
  enable_vertical_pod_autoscaling = false
  horizontal_pod_autoscaling      = true


  #--------------------------
  # Maintenance
  #--------------------------
  maintenance_start_time = "1970-01-01T02:00:00Z"
  maintenance_end_time   = "1970-01-01T06:00:00Z"          # Duration is 4 hours
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH" # Daily maintenance window


  #--------------------------
  # Worker node
  #--------------------------
  remove_default_node_pool = true
  initial_node_count       = 0
  # Reference: https://cloud.google.com/compute/docs/general-purpose-machines?hl=pt-br
  # Node pool names must start with a lowercase letter followed by up to 39 lowercase
  node_pools = []

  # If enabled this option create an additional dynamic nodepool
  cluster_autoscaling = {}

  node_pools_labels = {
    all = local.default_tags
  }

  cluster_resource_labels = merge(
    local.default_tags,
  )

}
