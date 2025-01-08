include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "eks-1-31" {
  path   = find_in_parent_folders("eks-1-31.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment      = local.environment_vars.locals.environment_name
  account_id       = local.environment_vars.locals.account_id
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
  region           = local.region_vars.locals.region

  customer_id   = local.customer_vars.locals.customer_id
  customer_name = local.customer_vars.locals.customer_name
  customer_tags = local.customer_vars.locals.customer_tags

  suffix            = local.customer_vars.locals.suffix1
  cluster_name      = local.customer_vars.locals.cluster1_name
  cluster_shortname = local.customer_vars.locals.cluster1_short_name

  cluster_endpoint_public_access_cidrs = local.customer_vars.locals.cluster_endpoint_public_access_cidrs

  list_roles = local.customer_vars.locals.list_roles
  list_users = local.customer_vars.locals.list_users
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/vpc/net-${local.suffix}/",
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/keypair/key-${local.suffix}/",
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/kms/kms-${local.suffix}/",
  ]
}

dependency "vpc" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/vpc/net-${local.suffix}/"
}

dependency "keypair" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/keypair/key-${local.suffix}/"
}

dependency "kms" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/kms/kms-${local.suffix}/"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  #-----------------------
  # ATTENTION!
  # Theese inputs are a complete example to create EKS cluster
  # using AWS Manage Node Group
  #-----------------------


  #--------------------------
  # General
  #--------------------------
  cluster_name = local.cluster_name

  #--------------------------
  # Network
  #--------------------------
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets


  #--------------------------
  # Log
  #--------------------------
  create_cloudwatch_log_group = true

  # After a cost analysis with cloudwatch it is recommended to keep the authenticator log only
  cluster_enabled_log_types                = ["authenticator"]
  cloudwatch_log_group_retention_in_days   = 1

  #--------------------------
  # Security
  #--------------------------
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = true

  create_kms_key            = false
  cluster_encryption_config = {
    provider_key_arn = dependency.kms.outputs.key_arn,
    resources        = ["secrets"]
  }

  create_cluster_security_group           = true
  cluster_security_group_additional_rules = {}
  node_security_group_additional_rules    = {}
  node_security_group_tags                = {}
  cluster_additional_security_group_ids   = []


  #--------------------------
  # Worker node
  #--------------------------
  # Set this parameter only if you want to use 'type_worker_node_group' with value 'AWS_MANAGED_NODE'
  # More options in page: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/eks-managed-node-group#inputs
  eks_managed_node_groups = {
    #"spot" = {
    #  name              = "${local.cluster_shortname}-spot"
    #  capacity_type     = "SPOT"
    #  key_name          = dependency.keypair.outputs.key_pair_name
    #  min_size          = 2
    #  max_size          = 20
    #  desired_size      = 2
    #  # See page https://aws.amazon.com/pt/ec2/instance-types/ to find type, resources and price of instance
    #  # ec2-instance-selector --memory CHANGE_HERE --vcpus CHANGE_HERE --cpu-architecture x86_64 --hypervisor nitro --usage-class spot --region AWS_REGION --profile AWS_PROFILE
    #  #
    #  # Example:
    #  # ec2-instance-selector --memory 4 --vcpus 2 --cpu-architecture x86_64 --hypervisor nitro --usage-class spot --region us-east-2 --profile my-account
    #  instance_types    = [
    #    "c5.large",
    #    "c5a.large",
    #    "c5ad.large",
    #    "c5d.large",
    #    "c6a.large",
    #    "c6i.large",
    #    "c6id.large",
    #    "c6in.large",
    #    "t3.medium",
    #    "t3a.medium"
    #  ]
    #  enable_monitoring = false
    #
    #  block_device_mappings = {
    #    xvda = {
    #      device_name = "/dev/xvda"
    #      ebs = {
    #        volume_size = 50
    #        volume_type = "gp3"
    #        encrypted   = true
    #      }
    #    }
    #  }
    #
    #  network_interfaces = [
    #    {
    #      associate_public_ip_address = false
    #    }
    #  ]
    #},
    "on-demand" = {
      name              = "${local.cluster_shortname}-ondemand"
      capacity_type     = "ON_DEMAND"
      key_name          = dependency.keypair.outputs.key_pair_name
      min_size          = 2
      max_size          = 20
      desired_size      = 2
      # See page https://aws.amazon.com/pt/ec2/instance-types/ to find type, resources and price of instance
      # ec2-instance-selector --memory CHANGE_HERE --vcpus CHANGE_HERE --cpu-architecture x86_64 --hypervisor nitro --service eks --usage-class on-demand --region AWS_REGION --profile AWS_PROFILE
      #
      # Example:
      # ec2-instance-selector --memory 8 --vcpus 2 --cpu-architecture x86_64 --hypervisor nitro --usage-class on-demand --region us-east-2 --profile myaccount
      instance_types    = [
        "m5.large",
        "m5a.large",
        "m5ad.large",
        "m5d.large",
        "m5dn.large",
        "m5n.large",
        "m5zn.large",
        "m6a.large",
        "m6i.large",
        "m6id.large",
        "m6idn.large",
        "m6in.large",
        "m7a.large",
        "m7i-flex.large",
        "m7i.large",
        "t3.large",
        "t3a.large",
      ]
      enable_monitoring = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            encrypted   = true
          }
        }
      }

      network_interfaces = [
        {
          associate_public_ip_address = false
        }
      ]
    }
  }

  #--------------------------
  # EKS components optionals
  #--------------------------
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  #install_aws_loadbalancer_controller = true
  #install_aws_vpc_cni_without_vpn     = true
  #install_aws_vpc_cni_with_vpn        = false
  #install_metrics_server              = true
  ## Change (if true) setup default of default StorageClass from GP2 to GP3.
  #install_storage_class_gp3           = true

  #--------------------------
  # EKS roles, users, accounts and tags
  #--------------------------
  authentication_mode = "API"
  access_entries      = {}

  tags = merge(
    local.customer_tags,
  )
}
