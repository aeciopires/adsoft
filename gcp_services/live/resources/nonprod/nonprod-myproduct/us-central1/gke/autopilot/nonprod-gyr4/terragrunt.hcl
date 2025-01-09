include "root" {
  path   = find_in_parent_folders("root.hcl")
}

include "gke-autopilot" {
  path   = find_in_parent_folders("gke-autopilot.hcl")
  expose = true
}


locals {
  account_vars       = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars        = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region             = local.region_vars.locals.region
  environment        = local.account_vars.locals.environment
  env_short_name     = local.account_vars.locals.env_short_name
  default_tags       = local.account_vars.locals.default_tags
  project_id         = local.account_vars.locals.project_id
  network_project_id = local.account_vars.locals.network_project_id
  suffix             = "gyr4"
  name               = "gke1"
  short_name         = "gke1"
  cluster_name       = "${local.environment}-${local.name}-autopilot-${local.suffix}"
  cluster_shortname  = "${local.env_short_name}-${local.short_name}-atp-${local.suffix}"
}


# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/gcp_services/live/resources/nonprod/${local.network_project_id}/${local.region}/network/vpc/vpc-nonprod-shared",
    "${get_repo_root()}/gcp_services/live/resources/nonprod/${local.network_project_id}/${local.region}/network/subnets/shared-services1"
  ]
}

dependency "vpc" {
  config_path = "${get_repo_root()}/gcp_services/live/resources/nonprod/${local.network_project_id}/${local.region}/network/vpc/vpc-nonprod-shared"
}

dependency "subnet-shared-services1" {
  config_path = "${get_repo_root()}/gcp_services/live/resources/nonprod/${local.network_project_id}/${local.region}/network/subnets/shared-services1"
}

inputs = {

  #--------------------------
  # General
  #--------------------------
  name       = local.cluster_name
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
  # Network
  #--------------------------
  network                       = dependency.vpc.outputs.network_name
  network_project_id            = local.network_project_id
  subnetwork                    = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].name
  ip_range_pods                 = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].range_name
  ip_range_services             = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].range_name
  zones                         = ["${local.region}-a", "${local.region}-b", "${local.region}-c"]
  stack_type                    = "IPV4"
  master_global_access_enabled  = true
  deploy_using_private_endpoint = false
  enable_private_endpoint       = false
  enable_private_nodes          = true
  network_tags                  = ["terraform", local.cluster_shortname]
  deletion_protection           = false
  master_authorized_networks    = [
    {
      name  = "Home" # CHANGE_HERE
      value = "X.X.X.X/32" # CHANGE_HERE
    },
  ]


  #--------------------------
  # Storage, log and monitoring
  #--------------------------
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"


  cluster_resource_labels = merge(
    local.default_tags,
    {
      cluster = local.cluster_shortname
    }
  )
}
