# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars                     = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars                          = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment                          = local.environment_vars.locals.environment
  scost                                = local.environment_vars.locals.scost
  monitoring                           = local.environment_vars.locals.monitoring
  map_roles                            = local.environment_vars.locals.map_roles
  map_users                            = local.environment_vars.locals.map_users
  workers_additional_policies          = local.environment_vars.locals.workers_additional_policies
  aws_profile                          = local.environment_vars.locals.profile_remote_tfstate
  region_bucket                        = local.environment_vars.locals.region_bucket
  profile_remote_tfstate               = local.environment_vars.locals.profile_remote_tfstate
  cluster_endpoint_public_access_cidrs = local.region_vars.locals.cluster_endpoint_public_access_cidrs
  customer_id                          = local.region_vars.locals.customer_id
  customer_name                        = local.region_vars.locals.customer_name
  customer_region                      = local.region_vars.locals.region
  key_name                             = local.region_vars.locals.key_name
  cluster_name                         = local.region_vars.locals.cluster1_name
}

dependency "key_pair" {
  config_path = "../keypair"
}

dependency "vpc" {
  config_path = "../vpc/"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//?ref=v17.20.0"

  # Issue: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911#issuecomment-761715025
  # Reference: https://github.com/terraform-aws-modules/terraform-aws-eks#important-note
  before_hook "connect_eks" {
    commands = ["apply","plan"]
    execute = ["aws", "eks", "update-kubeconfig",
      "--name", "${local.cluster_name}",
      "--region", "${local.customer_region}",
      "--profile", "${local.aws_profile}"
    ]
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  vpc_id                                         = dependency.vpc.outputs.vpc_id
  subnets                                        = dependency.vpc.outputs.private_subnets
  cluster_name                                   = "${local.cluster_name}"
  cluster_version                                = "1.21"
  cluster_enabled_log_types                      = ["api", "audit"]
  cluster_log_retention_in_days                  = "365"
  cluster_endpoint_public_access                 = true
  cluster_endpoint_public_access_cidrs           = "${local.cluster_endpoint_public_access_cidrs}"
  cluster_endpoint_private_access                = true
  cluster_endpoint_private_access_cidrs          = [ "0.0.0.0/0", ]
  manage_aws_auth                                = true
  kubeconfig_output_path                         = "./kube/${local.environment}/"
  kubeconfig_aws_authenticator_command           = "aws"
  kubeconfig_aws_authenticator_command_args      = ["eks", "get-token"]
  kubeconfig_aws_authenticator_additional_args   = ["--cluster-name", "${local.cluster_name}", "--region", "${local.customer_region}"]
  kubeconfig_aws_authenticator_env_variables     = {
    AWS_PROFILE        = "${local.aws_profile}"
    AWS_DEFAULT_REGION = "${local.customer_region}"
  }
  write_kubeconfig                               = false
  cluster_create_endpoint_private_access_sg_rule = false
  worker_additional_security_group_ids           = [ dependency.vpc.outputs.default_security_group_id, ]
  workers_additional_policies                    = "${local.workers_additional_policies}"
  map_roles                                      = "${local.map_roles}"
  map_users                                      = "${local.map_users}"
#  cluster_encryption_config                      = [
#    {
#      provider_key_arn = "arn:aws:kms:AWS_REGION:AWS_ACCOUNT_ID:PATH_ARN_KEY_SYMMETRIC"
#      resources        = ["secrets"]
#    }
#  ]
  worker_groups_launch_template                  = [
    {
      name                                     = "lt"
      override_instance_types                  = ["t3.micro", "t3a.micro"]
      on_demand_percentage_above_base_capacity = 50
      asg_min_size                             = 2
      asg_max_size                             = 20
      asg_desired_capacity                     = 2
      autoscaling_enabled                      = true
      kubelet_extra_args                       = "--node-labels=node.kubernetes.io/lifecycle=spot"
      public_ip                                = false
      suspended_processes                      = ["AZRebalance"]
      cluster_enabled_log_types                = ["api", "audit"]
      root_volume_size                         = 20
      key_name                                 = dependency.key_pair.outputs.key_pair_key_name
    }
  ]

  tags = {
    "Terraform"                                       = "true"
    "environment"                                     = "${local.environment}"
    "Scost"                                           = "${local.customer_id}"
    "monitoring"                                      = "${local.monitoring}"
    "Customer"                                        = "${local.customer_name}"
    "customer_id"                                     = "${local.customer_id}"
    "k8s.io/cluster-autoscaler/enabled"               = "true"
    "k8s.io/cluster-autoscaler/${local.cluster_name}" = "true"
  }
}
