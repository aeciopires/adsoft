
# ---------------------------------------------------------------------------------------------------------------------
# CUSTOMER PARAMETERS
# Set common variables for the customer.
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

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

  # Used by EC2, VPC and other resources
  suffix1 = "gyr4"

  # For create key pair RSA (without passphrase):
  # ssh-keygen -t rsa -b 4096 -v -f ~/key-gyr4.pem
  # Copy content public key without USER and HOST.
  # cat ~/key-gyr4.pem.pub | cut -d " " -f1,2
  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaj/Af6UpsosJoP7Z3AEW6qf+9qQsIpYhbWR9ZXfo0M5/HorpCe/OqqyMwjLwfZb6TCDKDjH/9MK5Y3VxoL/SF/ECjk3SJM5NQO/NWZojZUYM8nTkkc0sqsF7MNJgN4I0SFeigJwWpYE2h0NAJTadMIt9jY9OAEcH1FIcpcBgE9SuL4SvZm7CDbBlSloMoGqBS+BB/9sHc7UCANFR0FrAFdwMKGYUmlOmMJlklbryoSuht8A5fWGo+iPtkksVgJ07fIlnkDiFhJIiaM4ScEd5g8OwjrmZjfx4+pyQlEAXKiYwR5T/05gHomMCNdUZfLjIAzLRlcaRTxQ6CVhRUlB4KYcoYdpc8sbw8stVh6p0uRUZ9O+cKoEcyQv8gq0pUoq+er3+inHIlcUY+nLNPGFRlRcWzZ0Dd96QeJclEByln7vRVZDokKyn1y41P/jV2FtXdt/z/MbCYxhqtWxXQtDpIuauW6aPU9CDyjPgif3KjluxILYH7lyw8uKJuJM3pV0S15ZVdu6a3GeVrGRYMx4Gq6QyFcc9Rtl3E1QhFFxXWFvpMkIfeiax5HfQHE+XHWKN38LXR+8ZjQbMZSD/8/WJP2K9YVLIsRfLclwwkccYGEvMfiQuDIx7YjLZ+lF8WBGNUswbibDhiDK9aQLZ0n4bvGRrPtWgbE5oJm8AjeQi2w=="


  #----------------------------
  # EKS Configurations
  #----------------------------
  cluster1_suffix     = "gyr4"
  cluster1_short_name = "cluster1"
  cluster1_name       = "${local.customer_id}-${local.cluster1_short_name}-${local.cluster1_suffix}"

  # IP Address that can access the Kubernetes cluster
  # This site will also work with the -4 (IPv4) or -6 (IPv4) curl options
  # curl -4 icanhazip.com
  # OR
  # curl -6 icanhazip.com
  # Reference: https://linuxconfig.org/how-to-use-curl-to-get-public-ip-address
  cluster1_endpoint_public_access_cidrs = [
    "187.106.46.247/32",
  ]

  cluster1_workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  ]

  # See bellow pages for review access policy permissions
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policy-permissions.html
  # https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest#cluster-access-entry
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-eks-accessentry.html
  #
  # Try identify USER SSO ARN in CloudTrail
  # Reference: https://aws.amazon.com/blogs/security/how-to-easily-identify-your-federated-users-by-using-aws-cloudtrail/
  # Example: principal_arn = "arn:aws:sts::${local.account_id}:assumed-role/${local.aws_sso_role_name}/someone"
  cluster1_access_entries = {
    admin1-example = {
      principal_arn = "arn:aws:iam::${local.account_id}:user/someone" # CHANGE_HERE
      policy_associations = {
        admin1-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    admin2-example = {
      principal_arn = "arn:aws:iam::${local.account_id}:root" # CHANGE_HERE
      policy_associations = {
        admin2-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    dev1-example = {
      principal_arn = "arn:aws:iam::${local.account_id}:user/someone2" # CHANGE_HERE
      policy_associations = {
        dev1-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    manager1-example = {
      principal_arn = "arn:aws:iam::${local.account_id}:role/something" # CHANGE_HERE
      policy_associations = {
        manager1-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
  }


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

  # Each resource can have a maximum of 50 user created tags.
  # Reference: https://docs.aws.amazon.com/tag-editor/latest/userguide/reference.html
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
