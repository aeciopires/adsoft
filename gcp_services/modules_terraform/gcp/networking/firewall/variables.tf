# General
variable "project_id" {
  type = string
}

variable "service_account" {
  type = string
}

# Networks
variable "network_services" {
  type    = string
  default = "testing-project1"
}

variable "subnet_cidr" {
  type = list(string)
}

variable "testing_project1_cluster_name" {
  type = list(string)
}

variable "testing_project1_cluster_location" {
  type = list(string)
}

# Source list valid IP
variable "list_valid_ip" {
  type = list(string)
}
