#General
variable "project_id" {
  type = string
}

variable "service_account" {
  type = string
}

##### main.tf
variable "region" {
  type = string
}

variable "zones" {
  type = set(string)
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "master_authorized_networks" {
  type = string
}

variable "master_authorized_networks_display_name" {
  type    = string
  default = "myipadress-public"
}

variable "services_np" {
  type = map(string)
  default = {
    name               = "services"
    initial_node_count = 1
    min_count          = 1
    max_count          = 100
    machine_type       = "n1-standard-1"
    disk_size_gb       = 50
    disk_type          = "pd-ssd"
    auto_repair        = "true"
    auto_upgrade       = "false"
    preemptible        = "true"
  }
}

variable "scost" {
  type = string
}

variable "environment" {
  type = string
}

variable "tier" {
  type = string
}
