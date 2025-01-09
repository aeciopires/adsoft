locals {
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region         = local.region_vars.locals.region
  env_short_name = local.account_vars.locals.env_short_name
  default_tags   = local.account_vars.locals.default_tags
  project_id     = local.account_vars.locals.project_id
}

terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster?version=35.0.1"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  #--------------------------
  # General
  #--------------------------
  project_id = local.project_id
  region     = local.region
  regional   = true

  # The Kubernetes version of the master and nodes in the cluster.
  # More info:
  # https://cloud.google.com/kubernetes-engine/docs/release-notes
  # https://cloud.google.com/kubernetes-engine/docs/release-schedule
  # https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
  # https://cloud.google.com/kubernetes-engine/versioning
  kubernetes_version = "latest"
  # The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`.
  release_channel = "REGULAR"


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
  enable_vertical_pod_autoscaling = true
  horizontal_pod_autoscaling      = true


  #--------------------------
  # Maintenance
  #--------------------------
  maintenance_start_time = "1970-01-01T02:00:00Z"
  maintenance_end_time   = "1970-01-01T06:00:00Z"          # Duration is 4 hours
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH" # Daily maintenance window


  #--------------------------
  # Storage, log and monitoring
  #--------------------------
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"


  cluster_resource_labels = merge(
    local.default_tags,
  )
}
