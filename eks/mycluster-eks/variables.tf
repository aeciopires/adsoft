# Provider config
variable "credentials_file" {
  default = "~/.aws/credentials"
}
variable "profile" {}
variable "region" {}

# Networking
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {}

# EKS
variable "cluster_name" {}
variable "cluster_version" {}
variable "lt_name" {}
variable "override_instance_types" {}
variable "on_demand_percentage_above_base_capacity" {}
variable "autoscaling_enabled" {}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "asg_desired_capacity" {}
#variable "kubelet_extra_args" {}
variable "public_ip" {}
variable "cluster_endpoint_private_access" {}
variable "cluster_endpoint_private_access_cidrs" {
  type = list(string)
}
variable "cluster_endpoint_public_access" {}
variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}
variable "suspended_processes" {}
variable "root_volume_size" {}
variable "key_name" {}
variable "cluster_enabled_log_types" {
  type = list(string)
}
variable "cluster_log_retention_in_days" {
  default = "7"
}
variable "workers_additional_policies" {
  type = list(string)
}
variable "worker_additional_security_group_ids" {
  type    = list(string)
  default = []
}
variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

# Kubernetes manifests
variable "cw_retention_in_days" {
  default = 7
}

# General
variable "tags" {
  type    = map
  default = {}
}
variable "environment" {}

variable "address_allowed" {
  description = "IP or Net address allowed for remote access."
}

variable "aws_key_name" {}
variable "aws_key_private_path" {}
variable "aws_key_public_path" {}
