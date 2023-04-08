# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars       = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars            = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_profile            = local.environment_vars.locals.profile_remote_tfstate
  region_bucket          = local.environment_vars.locals.region_bucket
  profile_remote_tfstate = local.environment_vars.locals.profile_remote_tfstate
  cluster_name           = local.region_vars.locals.cluster1_name
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


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/particuleio/terraform-eks-aws-auth.git//?ref=v1.1.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # Reference: https://github.com/particuleio/teks/blob/main/terragrunt/live/production/eu-west-1/clusters/demo/aws-auth/terragrunt.hcl
  cluster-name             = dependency.cluster.outputs.cluster_id
  aws_auth_computed        = dependency.cluster.outputs.aws_auth_configmap_yaml
  aux_cluster_iam_rolename = dependency.cluster.outputs.cluster_iam_role_name

  aws_auth = <<-EOF
    data:
      mapRoles: |
        - groups:
          - system:bootstrappers
          - system:nodes
          rolearn: "${local.aux_cluster_iam_rolename}"
          username: "system:node:{{EC2PrivateDNSName}}"
        - "groups:
          - "system:masters"
          rolearn: arn:aws:iam::255686512659:role/adsoft
          username: Admins
      mapUsers: |
        - userarn: arn:aws:iam::255686512659:user/aeciopires
          username: aeciopires
          groups:
            - system:masters
    EOF

}
