# Provider config
profile = "default"
region  = "us-east-2"

# Networking
subnets = ["subnet-02a529dd02055132f", "subnet-03a8c01b4ccc30513"]
vpc_id  = "vpc-030b86877458b55a8"

# EKS
cluster_name                             = "mycluster-eks-testing"
cluster_version                          = "1.16"
lt_name                                  = "lt"
autoscaling_enabled                      = true
override_instance_types                  = ["r5a.large"]
on_demand_percentage_above_base_capacity = 25
asg_min_size                             = 2
asg_max_size                             = 20
asg_desired_capacity                     = 2
root_volume_size                         = 50
aws_key_name                             = "aws-teste"
public_ip                                = false
cluster_endpoint_public_access           = true
cluster_endpoint_public_access_cidrs     = ["0.0.0.0/0"]
cluster_endpoint_private_access          = true
cluster_endpoint_private_access_cidrs    = ["10.0.0.0/16","10.0.1.0/24","10.0.3.0/24"]
suspended_processes                      = ["AZRebalance"]
cluster_enabled_log_types                = ["api", "audit"]
workers_additional_policies              = [
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
]
worker_additional_security_group_ids     = ["sg-052ac86bf8b50158d"]
map_roles = [
  {
    rolearn  = "arn:aws:iam::255686512659:role/adsoft"
    username = "Admins"
    groups   = ["system:masters"]
  },
]

map_users = [
  {
    userarn  = "arn:aws:iam::255686512659:user/aeciopires"
    username = "aeciopires"
    groups   = ["system:masters"]
  },
]

# General
tags = {
  Scost       = "testing",
  Terraform   = "true",
  Environment = "testing",
}

environment     = "testing"
# MyIPAddress
address_allowed = "179.159.238.22/32"