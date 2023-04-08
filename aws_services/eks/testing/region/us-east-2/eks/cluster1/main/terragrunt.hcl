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

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
# Providers config
provider "aws" {
  region                  = "${local.region_bucket}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${local.profile_remote_tfstate}"
}

provider "kubernetes" {
  config_path = "${get_terragrunt_dir()}/kubeconfig_${local.environment}"
}

EOF
}

dependency "key_pair" {
  config_path = "../../../keypair"
}

dependency "vpc" {
  config_path = "../../../vpc/"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//?ref=v18.2.2"

  # Issue: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911#issuecomment-761715025
  # Reference: https://github.com/terraform-aws-modules/terraform-aws-eks#important-note
#  after_hook "connect_eks" {
#    commands = ["apply"]
#    execute  = ["aws", "eks", "update-kubeconfig",
#      "--name", "${local.cluster_name}",
#      "--region", "${local.customer_region}",
#      "--profile", "${local.aws_profile}"
#    ]
#  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  subnet_ids      = dependency.vpc.outputs.private_subnets
  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.21"
  create          = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_enabled_log_types              = ["api", "audit"]
  cloudwatch_log_group_retention_in_days = "365"
  cluster_endpoint_private_access        = true
  cluster_endpoint_public_access         = true
  cluster_endpoint_public_access_cidrs   = "${local.cluster_endpoint_public_access_cidrs}"

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

#  cluster_encryption_config                      = [
#    {
#      provider_key_arn = "arn:aws:kms:AWS_REGION:AWS_ACCOUNT_ID:PATH_ARN_KEY_SYMMETRIC"
#      resources        = ["secrets"]
#    }
#  ]

  node_security_group_id       = [ dependency.vpc.outputs.default_security_group_id, ]
  iam_role_additional_policies = "${local.workers_additional_policies}"

  # Self Managed Node Group(s)
  # Reference: 
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/aba94002e419e0805891ba4e4b5cbd12db7a1e9e/modules/self-managed-node-group/variables.tf
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/aba94002e419e0805891ba4e4b5cbd12db7a1e9e/variables.tf
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/9f85dc8cf5028ed2bab49f495f58e68aa870e7d4/node_groups.tf
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/complete/main.tf
  # https://github.com/particuleio/teks/blob/main/terragrunt/live/production/eu-west-1/clusters/demo/eks/terragrunt.hcl
  # https://github.com/particuleio/teks/releases/tag/v6.0.0
  self_managed_node_group_defaults = {
    vpc_security_group_ids       = [dependency.vpc.outputs.default_security_group_id]
    iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    key_name                     = dependency.key_pair.outputs.key_pair_key_name
  }

  self_managed_node_groups = {
    one = {
      name                            = "${local.cluster_name}-spot-1"
      launch_template_name            = "lt"
      launch_template_use_name_prefix = true
      launch_template_description     = "Self managed node group example launch template"
      public_ip                       = false
      desired_size                    = 2
      min_size                        = 2
      max_size                        = 20
      suspended_processes             = ["AZRebalance"]

      block_device_mappings = {
        root = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            delete_on_termination = true
            #encrypted             = true
            #kms_key_id            = "arn:aws:kms:AWS_REGION:AWS_ACCOUNT_ID:PATH_ARN_KEY_SYMMETRIC"
          }
        }
      }

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 50
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type = "t3.micro"
          },
          {
            instance_type = "t3.large"
          },
        ]
      }

      pre_bootstrap_user_data = <<-EOT
      echo "foo"
      export FOO=bar
      EOT

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      post_bootstrap_user_data = <<-EOT
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOT
    }
  }

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
