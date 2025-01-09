
//# ---------------------------------------------------------------------------------------------------------------------
//# CUSTOMER PARAMETERS
//# Set common variables for the customer.
//# These variables apply to all configurations in this subfolder. These are automatically merged into the child
//# `terragrunt.hcl` config via the include block.
//# ---------------------------------------------------------------------------------------------------------------------

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  account_id       = local.environment_vars.locals.account_id
  default_tags     = local.environment_vars.locals.default_tags

  # To generate customer_id, execute:
  # cat /dev/urandom | tr -dc "a-z0-9" | fold -w  10 | head -n 1 | tr -d "\n"
  # Example: cdk17o7adl (mycustomer)
  customer_id   = "cdk17o7adl"
  customer_name = "mycustomer"

  customer_tags = merge(
    local.default_tags,
    {
      "customer_name" = local.customer_name,
      "customer_id"   = local.customer_id,
    }
  )

  #----------------------------
  # EKS Configurations
  #----------------------------
  suffix1             = "gyr4"
  cluster1_short_name = "cluster1"
  cluster1_name       = "${local.customer_id}-${local.cluster1_short_name}-${local.suffix1}"

  # IP Address that can access the Kubernetes cluster
  cluster_endpoint_public_access_cidrs = [
    "187.106.46.247/32",
  ]

  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaj/Af6UpsosJoP7Z3AEW6qf+9qQsIpYhbWR9ZXfo0M5/HorpCe/OqqyMwjLwfZb6TCDKDjH/9MK5Y3VxoL/SF/ECjk3SJM5NQO/NWZojZUYM8nTkkc0sqsF7MNJgN4I0SFeigJwWpYE2h0NAJTadMIt9jY9OAEcH1FIcpcBgE9SuL4SvZm7CDbBlSloMoGqBS+BB/9sHc7UCANFR0FrAFdwMKGYUmlOmMJlklbryoSuht8A5fWGo+iPtkksVgJ07fIlnkDiFhJIiaM4ScEd5g8OwjrmZjfx4+pyQlEAXKiYwR5T/05gHomMCNdUZfLjIAzLRlcaRTxQ6CVhRUlB4KYcoYdpc8sbw8stVh6p0uRUZ9O+cKoEcyQv8gq0pUoq+er3+inHIlcUY+nLNPGFRlRcWzZ0Dd96QeJclEByln7vRVZDokKyn1y41P/jV2FtXdt/z/MbCYxhqtWxXQtDpIuauW6aPU9CDyjPgif3KjluxILYH7lyw8uKJuJM3pV0S15ZVdu6a3GeVrGRYMx4Gq6QyFcc9Rtl3E1QhFFxXWFvpMkIfeiax5HfQHE+XHWKN38LXR+8ZjQbMZSD/8/WJP2K9YVLIsRfLclwwkccYGEvMfiQuDIx7YjLZ+lF8WBGNUswbibDhiDK9aQLZ0n4bvGRrPtWgbE5oJm8AjeQi2w=="


  #----------------------------
  # VPC Configurations
  #----------------------------
  # http://jodies.de/ipcalc?host=172.31.240.0&mask1=20&mask2=22
  cidr = "172.31.240.0/20"

  public_subnets  = [
    "172.31.240.0/22",
    "172.31.244.0/22"
  ]

  private_subnets = [
    "172.31.248.0/22",
    "172.31.252.0/22"
  ]

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  ]

  # See bellow pages for review access policy permissions
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policy-permissions.html
  # https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest#cluster-access-entry
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-eks-accessentry.html
  access_entries = {
    admin-example = {
      #principal_arn = "arn:aws:iam::${local.account_id}:user/someone"
      principal_arn = "arn:aws:iam::${local.account_id}:user/aeciopires"
      policy_associations = {
        admin-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    admin2-example = {
      principal_arn = "arn:aws:iam::${local.account_id}:root"
      policy_associations = {
        admin-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    #dev-example = {
    #  principal_arn = "arn:aws:iam::${local.account_id}:user/someone2"
    #  policy_associations = {
    #    dev-example = {
    #      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
    #      access_scope = {
    #        namespaces = []
    #        type       = "cluster"
    #      }
    #    }
    #  }
    #},
    manager-example = {
      #principal_arn = "arn:aws:iam::${local.account_id}:role/something"
      principal_arn = "arn:aws:iam::${local.account_id}:role/adsoft"
      policy_associations = {
        manager-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
  }

  # Each resource can have a maximum of 50 user created tags.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html

  public_subnet_tags = {
    "type"                                         = "public",
    "kubernetes.io/role/elb"                       = "1",      # For use with ALB of type internet
    "kubernetes.io/cluster/${local.cluster1_name}" = "shared", # For use with node autoscaling
  }

  private_subnet_tags = {
    "type"                                          = "private",
    "kubernetes.io/role/internal-elb"               = "1",                 # For use with ALB of type internal
    "kubernetes.io/cluster/${local.cluster1_name}"  = "shared",            # For use with node autoscaling
    "karpenter.sh/discovery/${local.cluster1_name}" = local.cluster1_name, # For use with Karpenter
  }

}
