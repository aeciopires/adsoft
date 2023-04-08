# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment_name = local.environment_vars.locals.environment_name
  aws_profile      = local.environment_vars.locals.aws_profile
  account_id       = local.environment_vars.locals.account_id
  region           = local.region_vars.locals.region

  customer_id   = local.customer_vars.locals.customer_id
  customer_name = local.customer_vars.locals.customer_name
  customer_tags = local.customer_vars.locals.customer_tags

  cluster_suffix    = local.customer_vars.locals.suffix1
  cluster_name      = local.customer_vars.locals.cluster1_name
  cluster_shortname = local.customer_vars.locals.cluster1_short_name

  cluster_endpoint_public_access_cidrs = local.customer_vars.locals.cluster_endpoint_public_access_cidrs

  list_roles = local.customer_vars.locals.list_roles
  list_users = local.customer_vars.locals.list_users
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "../../../../../../../modules//kubernetes-1-25/"
}

dependency "vpc" {
  config_path = "../../vpc/net-gyr4/"
}

#dependency "certificate" {
#  config_path = "../../certificates/wildcard-mydomain-com/"
#}

dependency "kms" {
  config_path = "../../kms/kms-gyr4"
}

dependency "keypair" {
  config_path = "../../keypair/key-gyr4"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  #-----------------------
  # ATTENTION!
  # Theese inputs are a complete example to create EKS cluster
  # using Karpenter, AWS Manage Node Group or Self Manage Node Group
  # using all components optionals, guest permitions and without using VPN
  #
  # You can to use this file for to learn how to create EKS cluster using kubernetes 1.25.x
  #-----------------------


  #--------------------------
  # General
  #--------------------------
  profile      = local.aws_profile
  region       = local.region
  environment  = local.environment_name
  cluster_name = local.cluster_name


  #--------------------------
  # Network
  #--------------------------
  vpc_id         = dependency.vpc.outputs.vpc_id
  vpc_cidr_block = [dependency.vpc.outputs.vpc_cidr_block]
  subnet_ids     = dependency.vpc.outputs.private_subnets


  #--------------------------
  # Log
  #--------------------------
  create_cloudwatch_log_group = true

  # After a cost analysis with cloudwatch it is recommended to keep the authenticator log only
  cluster_enabled_log_types                = ["authenticator"]
  cloudwatch_log_group_retention_in_days   = 1
  fluentbit_cw_log_group_retention_in_days = 1


  #--------------------------
  # Security
  #--------------------------
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = true

  create_kms_key            = false
  cluster_encryption_config = {
    provider_key_arn = dependency.kms.outputs.key_arn
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
  # The 'type_worker_node_group' parameter supports the following values. Choose just one.
  #
  # KARPENTER         => create worker node and install Karpenter.
  # AWS_MANAGED_NODE  => create worker node with some AWS managed settings. Requires 'eks_managed_node_groups' parameter to be set.
  #                      More options in page: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/eks-managed-node-group#inputs
  # SELF_MANAGED_NODE => creates a worker node with all settings defined by you. Requires 'self_managed_node_groups' parameter to be set.
  #                      More options in https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/self-managed-node-group#inputs

  type_worker_node_group = "AWS_MANAGED_NODE"  # Requires 'eks_managed_node_groups' parameter to be set.

  # Set this parameter only if you want to use 'type_worker_node_group' with value 'AWS_MANAGED_NODE'
  # More options in page: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/eks-managed-node-group#inputs
  eks_managed_node_groups = {
    "spot" = {
      name              = "${local.cluster_shortname}-spot"
      capacity_type     = "SPOT"
      key_name          = dependency.keypair.outputs.key_pair_name
      min_size          = 2
      max_size          = 20
      desired_size      = 2
      # See page https://aws.amazon.com/pt/ec2/instance-types/ to find type, resources and price of instance
      # ec2-instance-selector --memory CHANGE_HERE --vcpus CHANGE_HERE --cpu-architecture x86_64 --hypervisor nitro --service eks --usage-class spot --region AWS_REGION --profile AWS_PROFILE
      #
      # Example:
      # ec2-instance-selector --memory 4 --vcpus 2 --cpu-architecture x86_64 --hypervisor nitro --service eks --usage-class spot --region us-east-2 --profile my-account
      instance_types    = [
        "c5.large",
        "c5a.large",
        "c5ad.large",
        "c5d.large",
        "c6a.large",
        "c6i.large",
        "c6id.large",
        "c6in.large",
        "t3.medium",
        "t3a.medium"
      ]
      enable_monitoring = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
          }
        }
      }

      network_interfaces = [
        {
          associate_public_ip_address = false
        }
      ]
    },
    "on-demand" = {
      name              = "${local.cluster_shortname}-ondemand"
      capacity_type     = "ON_DEMAND"
      key_name          = dependency.keypair.outputs.key_pair_name
      min_size          = 2
      max_size          = 20
      desired_size      = 2
      instance_types    = ["m5.large", "m5a.large"]
      enable_monitoring = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
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

  # Set this parameter only if you want to use 'type_worker_node_group' with value 'SELF_MANAGED_NODE'
  # More options in https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/self-managed-node-group#inputs
  self_managed_node_groups = {
    "${local.cluster_shortname}-lt-spot" = {
      name                = "${local.cluster_shortname}-lt-spot"
      suspended_processes = ["AZRebalance"]
      key_name            = dependency.keypair.outputs.key_pair_name
      min_size            = 2
      max_size            = 20
      desired_size        = 2
      enable_monitoring   = false
      capacity_rebalance  = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
          }
        }
      }

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_percentage_above_base_capacity = 50
        }

        # See page https://aws.amazon.com/pt/ec2/instance-types/ to find type, resources and price of instance
        # ec2-instance-selector --memory CHANGE_HERE --vcpus CHANGE_HERE --cpu-architecture x86_64 --hypervisor nitro --service eks --usage-class spot --region AWS_REGION --profile AWS_PROFILE
        #
        # Example:
        # ec2-instance-selector --memory 4 --vcpus 2 --cpu-architecture x86_64 --hypervisor nitro --service eks --usage-class spot --region us-east-2 --profile my-account
        override = [
          { instance_type = "c5.large" },
          { instance_type = "c5a.large" },
          { instance_type = "c5ad.large" },
          { instance_type = "c5d.large" },
          { instance_type = "c6a.large" },
          { instance_type = "c6i.large" },
          { instance_type = "c6id.large" },
          { instance_type = "c6in.large" },
          { instance_type = "t3.medium" },
          { instance_type = "t3a.medium" },
        ]
      }

      network_interfaces = [
        {
          associate_public_ip_address = false
        }
      ]

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
      }

      iam_role_additional_policies = {
        CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        CloudWatchLogsFullAccess     = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
        AmazonEC2ReadOnlyAccess      = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      }

      autoscaling_group_tags = {
        "k8s.io/cluster-autoscaler/enabled"               = "true",
        "k8s.io/cluster-autoscaler/${local.cluster_name}" = "true",
      }

      tags = {
        "aws-node-termination-handler/managed" = "true",
      }
    }
  }


  #--------------------------
  # EKS components optionals
  #--------------------------
  install_aws_loadbalancer_controller = true
  install_aws_vpc_cni_without_vpn     = true
  install_aws_vpc_cni_with_vpn        = false
  install_metrics_server              = true
  install_traefik                     = false

  # For create traefik ingress, the parameters 'install_aws_loadbalancer_controller' and 'install_traefik' must have 'true' value.
  create_traefik_ingress              = false
  # The 'traefik_ingress_alb_certificate_arn' variable is used only if the 'create_traefik_ingress' variable is defined
  #traefik_ingress_alb_certificate_arn = dependency.certificate.outputs.acm_certificate_arn

  # Guest permissions
  enable_guest_permissions_core_resources = true


  #--------------------------
  # Velero
  #--------------------------
  install_velero          = false
  velero_irsa             = false
  velero_s3_bucket_name   = "CHANGE_HERE"
  velero_s3_bucket_prefix = "CHANGE_HERE"
  velero_s3_bucket_region = "CHANGE_HERE"
  velero_deploy_restic    = false
  velero_default_restic   = false
  velero_snapshot_enabled = false

  #--------------------------
  # Namespace customization
  #--------------------------
  # The label namespace_created_with_eks=true is applied by default in namespaces:
  # karpenter, traefik, amazon-cloudwatch, kube-system, default, kube-node-lease, kube-public
  # Other labels can be added in this namespace via the 'default_labels_namespaces' variable
  #
  # By default, no annotations are applied in these namespaces, but something can be set in the 
  # 'default_annotations_namespaces' variable
  #
  # It's a optional customization. If 'true' requires 'namespace_customization' parameter to be set.
  # If this feature is enabled and later disabled... it will not remove the namespace or added labels/annotations.
  enable_namespace_customization = false
  # This feature is idempotent... if the namespace exists on the cluster, you can use
  # the module to add labels and annotations. This applies to the kube-system namespace, for example.
  namespace_customization = {
    namespace1 = {
      namespace = "my-namespace"
      annotations = [
        "annotation1=value1", "annotation2=value2"
      ],
      labels = [
        "label1=value1", "label2=value2"
      ]
    }
  }


  #--------------------------
  # EKS roles, users, accounts and tags
  #--------------------------

  # List of role maps to add to the 'aws-auth' configmap in 'kube-system' namespace
  aws_auth_roles = local.list_roles

  # List of user maps to add to the 'aws-auth' configmap in 'kube-system' namespace
  aws_auth_users = local.list_users

  # [OPTIONAL] List of account maps to add to the 'aws-auth' configmap in 'kube-system' namespace
  aws_auth_accounts = []

  tags = merge(
    local.customer_tags,
  )
}
