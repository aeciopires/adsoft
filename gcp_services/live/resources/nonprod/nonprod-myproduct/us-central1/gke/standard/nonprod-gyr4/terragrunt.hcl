include "root" {
  path   = find_in_parent_folders("root.hcl")
}

include "gke-standard" {
  path   = find_in_parent_folders("gke-standard.hcl")
  expose = true
}


locals {
  account_vars        = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region              = local.region_vars.locals.region
  environment         = local.account_vars.locals.environment
  env_short_name      = local.account_vars.locals.env_short_name
  default_tags        = local.account_vars.locals.default_tags
  project_id          = local.account_vars.locals.project_id
  network_project_id  = local.account_vars.locals.network_project_id
  # Change according the project
  gke_service_account = "000000000000-compute@developer.gserviceaccount.com"
  suffix              = "gyr4"
  name                = "gke1"
  short_name          = "gke1"
  # Cluster names must start with a lowercase letter followed by up to 39 lowercase letters
  cluster_name        = "${local.environment}-${local.name}-standard-${local.suffix}"
  cluster_shortname   = "${local.env_short_name}-${local.short_name}-std-${local.suffix}"
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
  kubernetes_version = "1.30.8-gke.1051000" # last version of REGULAR channel
  # The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`.
  release_channel    = "UNSPECIFIED" # choice this option to disable auto_upgrade and auto_repair in node groups


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
  # Network
  #--------------------------
  # Change this range network to eliminate conflicts with other GKEs in other projects
  master_ipv4_cidr_block        = "192.168.4.128/28"
  network                       = dependency.vpc.outputs.network_name
  network_project_id            = local.network_project_id
  subnetwork                    = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].name
  ip_range_pods                 = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].range_name
  ip_range_services             = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].range_name
  zones                         = ["${local.region}-a", "${local.region}-b"]
  master_global_access_enabled  = true
  enable_private_endpoint       = false
  enable_private_nodes          = true
  deletion_protection           = false
  master_authorized_networks    = [
    {
      name  = "Home" # CHANGE_HERE
      value = "X.X.X.X/32" # CHANGE_HERE
    },
  ]



  #--------------------------
  # Worker node
  #--------------------------
  remove_default_node_pool = true
  initial_node_count       = 0
  # Reference: https://cloud.google.com/compute/docs/general-purpose-machines?hl=pt-br
  # Node pool names must start with a lowercase letter followed by up to 39 lowercase
  node_pools = [
    #{
    #  # spot nodepool
    #  name               = "${local.cluster_shortname}-spt1"
    #  spot               = true
    #  service_account    = local.gke_service_account
    #  initial_node_count = 1 # Considering the same number of nodes per zone: a and b
    #  min_count          = 1
    #  max_count          = 20
    ## More details about pricing and performance: https://cloud.google.com/compute/docs/machine-resource
    ## GCP Calculator: https://cloud.google.com/products/calculator
    #  machine_type       = "e2-standard-4"
    #  node_locations     = "${local.region}-a,${local.region}-b"
    #  image_type         = "COS_CONTAINERD"
    #  disk_size_gb       = 50
    #  disk_type          = "pd-ssd"
    #  auto_repair        = false
    #  auto_upgrade       = false
    #  preemptible        = false
    #  max_pods_per_node  = 110
    #},
    {
      # on-demand nodepool
      name               = "${local.cluster_shortname}-odm1"
      spot               = false
      service_account    = local.gke_service_account
      initial_node_count = 1  # Considering the same number of nodes per zone: a and b
      min_count          = 1
      max_count          = 20
    ## More details about pricing and performance: https://cloud.google.com/compute/docs/machine-resource
    ## GCP Calculator: https://cloud.google.com/products/calculator
      machine_type       = "e2-standard-4"
      node_locations     = "${local.region}-a,${local.region}-b"
      image_type         = "COS_CONTAINERD"
      disk_size_gb       = 50
      disk_type          = "pd-ssd"
      auto_repair        = false
      auto_upgrade       = false
      preemptible        = false
      max_pods_per_node  = 110
    },
  ]

  # If enabled this option create an additional dynamic nodepool
  cluster_autoscaling = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    disk_size           = 50
    disk_type           = "pd-ssd"
    min_cpu_cores       = 1
    max_cpu_cores       = 80   # CPU cores of machine type multiplied by max_count
    min_memory_gb       = 1
    max_memory_gb       = 300  # Memory of machine type multiplied by max_count
    gpu_resources       = []
    image_type          = "COS_CONTAINERD"
    auto_repair         = false
    auto_upgrade        = false
    strategy            = "SURGE"
    max_surge           = 1
    max_unavailable     = 0
  }

  node_pools_labels = {
    all = merge(
      local.default_tags,
      {
        cluster = local.cluster_shortname
      }
    )
  }


  cluster_resource_labels = merge(
    local.default_tags,
    {
      cluster = local.cluster_shortname
    }
  )
}
