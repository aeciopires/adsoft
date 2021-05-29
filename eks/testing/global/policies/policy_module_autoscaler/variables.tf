# General
variable "name" {
  type = string
}

variable "path" {
  type    = string
  default = "/"
}

variable "description" {
  type    = string
  default = "Autoscaling policy for EKS node groups"
}

variable "environment" {
  type    = string
  default = "testing"
}