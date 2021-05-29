
//# ---------------------------------------------------------------------------------------------------------------------
//# REGION PARAMETERS
//# Set common variables for the region.
//# These variables apply to all configurations in this subfolder. These are automatically merged into the child
//# `terragrunt.hcl` config via the include block.
//# ---------------------------------------------------------------------------------------------------------------------

locals {
  region             = "us-east-2"
  key_name           = "aws-testing"
  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNWPO+Q48B1nbzDeKJyZvWbZxKAS5D4+eeyJm/CVZCKRTTTXtFMzSwBz6VlwkE4UCkq0t4BWbAy+AEAR9Kcb/E8e1LxxzBq0IvfxPYPEeGT1ygyhgHCKmak511B9LYtFrQNT6fv6mP9Am/h/ccMvdVzZ1B/TKI5/HR1iC4qsLQnM63t5oxF0DQu6tHWmfeR0YCcPzU5B0dzFf5zPRfwi30UOVFX8O4TDSe7a2sb2tKaF7pVAvVRbiAW14f1Zktfm5JJB1kQ2uNJvHRHu0rq9RHlQrfPMilxehGIcbic/P2OMMLm13VF36oky+XP7CCJXdiyVaUM36DA30gV6pbILxN"

  #----------------------------
  # VPC Configurations
  #----------------------------
  # Page with documentation of VPC and subnets for each customer
  # https://sensedia.atlassian.net/wiki/spaces/CLARK/pages/746324071/AWS+-+Network+Block+Control
  # http://jodies.de/ipcalc?host=172.31.240.0&mask1=20&mask2=22
  cidr = "172.31.240.0/20"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  azs             = ["${local.region}a", "${local.region}c", ]
  public_subnets  = ["172.31.240.0/22", "172.31.244.0/22", ]
  private_subnets = ["172.31.248.0/22", "172.31.252.0/22", ]

  vpc_tags = {
    "kubernetes.io/cluster/api-platform" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/api-platform" = "shared"
    "kubernetes.io/role/elb"             = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

