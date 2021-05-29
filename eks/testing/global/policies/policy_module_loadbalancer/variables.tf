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
  default = "Policy to permit LB management by aws-lb-controller"
}

variable "environment" {
  type    = string
  default = "testing"
}