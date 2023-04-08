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
  path      = "provider-local.tf"
  if_exists = "overwrite"
  contents  = <<EOF
# Providers config
provider "aws" {
  region                  = "${local.region_bucket}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${local.profile_remote_tfstate}"
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster" "cluster" {
  name = "${local.cluster_name}"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "${local.cluster_name}"
}

EOF
}

dependency "cluster" {
  config_path = "../main"
}

dependency "vpc" {
  config_path = "../../../vpc/"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/particuleio/terraform-kubernetes-addons.git//?ref=v3.1.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # Reference: 
  # https://github.com/particuleio/teks/blob/main/terragrunt/live/production/eu-west-1/clusters/demo/eks-addons-critical/terragrunt.hcl
  # https://github.com/particuleio/teks/blob/main/terragrunt/live/production/eu-west-1/clusters/demo/eks-addons/terragrunt.hcl
  cluster-name             = dependency.cluster.outputs.cluster_id
  aws_auth_computed        = dependency.cluster.outputs.aws_auth_configmap_yaml
  aux_cluster_iam_rolename = dependency.cluster.outputs.cluster_iam_role_name

  priority-class = {
    name  = basename(get_terragrunt_dir())
    value = "90000"
  }

  priority-class-ds = {
    name   = "${basename(get_terragrunt_dir())}-ds"
    values = "100000"
  }

  cluster-name = dependency.cluster.outputs.cluster_id

  eks = {
    "cluster_oidc_issuer_url" = dependency.cluster.outputs.cluster_oidc_issuer_url
  }

  cert-manager = {
    enabled             = true
    acme_http01_enabled = true
    acme_dns01_enabled  = true
    extra_values        = <<-EXTRA_VALUES
      ingressShim:
        defaultIssuerName: letsencrypt
        defaultIssuerKind: ClusterIssuer
        defaultIssuerGroup: cert-manager.io
      EXTRA_VALUES
  }

  cluster-autoscaler = {
    enabled      = true
    version      = "v1.21.0"
    extra_values = <<-EXTRA_VALUES
      extraArgs:
        scale-down-utilization-threshold: 0.7
      EXTRA_VALUES
  }

  external-dns = {
    external-dns = {
      enabled = true
    }
  }

  aws-for-fluent-bit = {
    enabled                          = true
    containers_log_retention_in_days = 14
  }

  aws-load-balancer-controller = {
    enabled = true
  }

  metrics-server = {
    enabled       = true
    allowed_cidrs = dependency.vpc.outputs.private_subnets_cidr_blocks
  }

  tags = {
    "Terraform"   = "true"
    "environment" = "${local.environment}"
    "Scost"       = "${local.customer_id}"
    "monitoring"  = "${local.monitoring}"
    "Customer"    = "${local.customer_name}"
    "customer_id" = "${local.customer_id}"
  }
}
