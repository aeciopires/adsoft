#General
variable "project_id" {
  type = string
}

variable "service_account" {
  type = string
}

variable "region" {
  type = string
}

# NAT
variable "cloud_nat" {
  type    = string
  default = "nat-testing-project1"
}

variable "nat_name" {
  type    = string
  default = "nat-testing-project1"
}

variable "number_of_nat_address" {
  type = string
}

# Cloud router
variable "cloud_router" {
  type    = string
  default = "router-testing-project1"
}

variable "min_ports_per_vm" {
  type = string
}

#VPC and subnet
variable "vpc_name" {
  type = string
}

variable "subnet_cidr" {
  type    = string
  default = "172.19.255.0/25"
}

variable "subnet_name" {
  type    = string
  default = "testing-project1"
}

variable "range_services" {
  type = list(map(string))
  default = []
}

variable "environment" {
  type = string
}

variable "tier" {
  type = string
}
