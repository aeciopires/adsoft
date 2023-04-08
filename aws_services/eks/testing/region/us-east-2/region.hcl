
//# ---------------------------------------------------------------------------------------------------------------------
//# REGION PARAMETERS
//# Set common variables for the region.
//# These variables apply to all configurations in this subfolder. These are automatically merged into the child
//# `terragrunt.hcl` config via the include block.
//# ---------------------------------------------------------------------------------------------------------------------

locals {
  environment_vars   = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment        = local.environment_vars.locals.environment
  region             = "us-east-2"
  key_name           = "aws-testing"
  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDi+Wel2qL9OR541sPZLXczj/wEzDjRblXgya/y40E1xYSQDGXkMikndWywKGB0uoV1P1oGXQqFGHKn0lewiwuNAKsg5vGqIJ8miVqfMQ+qpiAU2Byt0cAz14eb2adJmRAlo5hQpj+xTGvi4xnde8ud1v0FHLABNtNdTn7VpPpGmvpXff68kj6ebV9IrRQ1kVkD8hlZTEixYAGnVHQScjfsrId68H0uNFYghgzdKlWWbP21b4WKNWZNQZc4U7gQ405vRRHqXfM/YIcUuDskT+T1+r0aBYkrtvPbxQLy5CHV46YAeYOs0TushrjwaGl3PLNopFC3duBUMaHnaRN/5ikD"

  # To generate customer_id, execute:
  # cat /dev/urandom | tr -dc "a-z0-9" | fold -w  10 | head -n 1 | tr -d "\n"
  # Example: cdk17o7adl (mycustomer)
  customer_id   = "cdk17o7adl"
  customer_name = "mycustomer"

  #----------------------------
  # EKS Configurations
  #----------------------------
  cluster1_name = "mycluster-${local.customer_id}"

  # IP Address that can access the Kubernetes cluster
  cluster_endpoint_public_access_cidrs = [
    "187.106.34.5/32",
  ]

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
    "kubernetes.io/cluster/${local.cluster1_name}" = "shared"
    "Terraform"                                    = "true"
    "environment"                                  = "${local.environment}"
    "Scost"                                        = "${local.customer_id}"
    "Customer"                                     = "${local.customer_name}"
    "customer_id"                                  = "${local.customer_id}"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster1_name}" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
