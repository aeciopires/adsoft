resource "random_id" "random_suffix" {
  byte_length = 2
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "7.3.0"

  project_id                 = var.project_id
  name                       = "${var.cluster_name}-${var.tier}-${random_id.random_suffix.hex}"
  region                     = var.region
  zones                      = var.zones
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = "${var.ip_range_pods}-${var.region}"
  ip_range_services          = "${var.ip_range_services}-${var.region}"
  service_account            = null
  horizontal_pod_autoscaling = false
  network_policy             = false
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  regional                   = false
  node_version               = var.k8s_version
  kubernetes_version         = var.k8s_version
  master_authorized_networks = [
    {
      cidr_block   = var.master_authorized_networks
      display_name = var.master_authorized_networks_display_name
    }
  ]
  remove_default_node_pool = true

  node_pools = [
    {
      name               = var.services_np.name
      initial_node_count = var.services_np.initial_node_count
      min_count          = var.services_np.min_count
      max_count          = var.services_np.max_count
      machine_type       = var.services_np.machine_type
      disk_size_gb       = var.services_np.disk_size_gb
      disk_type          = var.services_np.disk_type
      auto_repair        = var.services_np.auto_repair
      auto_upgrade       = var.services_np.auto_upgrade
      preemptible        = var.services_np.preemptible
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }

  node_pools_labels = {
    all = {
      scost = var.scost
    }

    "${var.services_np.name}" = {
      workload = "services"
    }

  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_tags = {
    all = ["terraform", var.scost]
  }
}
