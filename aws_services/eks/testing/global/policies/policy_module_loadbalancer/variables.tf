# General
variable "name" {
  type        = string
  description = "Name of AWS-IAM policy."
}

variable "path" {
  type        = string
  default     = "/"
  description = "Path of IAM policy."
}

variable "description" {
  type        = string
  default     = "Policy to permit LB management by aws-lb-controller"
  description = "Description of IAM policy."
}

variable "environment" {
  type        = string
  default     = "testing"
  description = "Environment name."
}