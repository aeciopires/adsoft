
//# ---------------------------------------------------------------------------------------------------------------------
//# REGION PARAMETERS
//# Set common variables for the region.
//# These variables apply to all configurations in this subfolder. These are automatically merged into the child
//# `terragrunt.hcl` config via the include block.
//# ---------------------------------------------------------------------------------------------------------------------

locals {
  region             = "us-east-2"
  key_name           = "aws-testing"
  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6UOQ5zd6yRWsJESIpRPBUGK7yWcNdXSZl+NGbOy4xndkSOBYWWVr0IJk3nEddqsIxfTazh8p9gwVu0O1WUTsxOxTx6vk8EQbArA/o8m+Hiue2pPJlJDl+cY2t7twfwzoh6aZ0MstYvMRrjvTKHcur4bXqD/UqaTn1UeNJ2WytY8+JSvtx3YoS97UHFiGmHnEfZzsShVSkqJv0wgm1eqZnajFVcqXIKOSyxk0CN4kfCTOd29b5Y8CoO1o4IAqISoz2eecViTw5gy0IlhEtmoa03084WSyOzGG/D0QZ0lfA3mXgAAmG5uv/5sN0E7pzs4R1ZgMFYHorN8Cdp+3eJiPX"

  #----------------------------
  # VPC Configurations
  #----------------------------
  # http://jodies.de/ipcalc?host=172.31.240.0&mask1=20&mask2=22
  cidr = "172.31.240.0/20"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  azs             = ["${local.region}a", "${local.region}c", ]
  public_subnets  = ["172.31.240.0/22", "172.31.244.0/22", ]
  private_subnets = ["172.31.248.0/22", "172.31.252.0/22", ]

  vpc_tags = {
    "kubernetes.io/cluster/mycluster-eks-testing" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/mycluster-eks-testing" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

