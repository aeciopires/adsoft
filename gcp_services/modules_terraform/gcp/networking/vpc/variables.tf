# General
variable "project_id" {
  type = string
}

variable "service_account" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east1"
}

# VPC and subnet
variable "vpc_name" {
  type    = string
  default = "testing-project1"
}

