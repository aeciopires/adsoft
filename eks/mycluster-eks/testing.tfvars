# Provider config
profile = "default"
region  = "us-east-2"

# Networking
subnets = ["subnet-0a4b7385c229316b5", "subnet-04c53d847792caa21"]
vpc_id  = "vpc-064282afe27af7cbc"

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
key_name                                 = "aws-teste"
public_ip                                = false
cluster_endpoint_public_access           = true
cluster_endpoint_public_access_cidrs     = ["0.0.0.0/0"]
cluster_endpoint_private_access          = true
cluster_endpoint_private_access_cidrs    = ["10.0.0.0/16","10.0.1.0/24","10.0.50.0/24"]
suspended_processes                      = ["AZRebalance"]
cluster_enabled_log_types                = ["api", "audit"]
workers_additional_policies              = [
  "arn:aws:iam::660412058498:policy/aws-alb-ingress-controller",
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
]
worker_additional_security_group_ids     = ["sg-09100409f6a9a4f51"]
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
  Scost = "testing"
}

environment = "testing"

aws_key_name         = "aws-teste"
aws_key_private_path = "/home/aws-teste.pem"
aws_key_public_path  = "/home/aws-teste.pub"
address_allowed      = "179.159.238.22/32"