//# ---------------------------------------------------------------------------------------------------------------------
//# ENVIRONMENT PARAMETERS
//# These variables apply to all configurations in this subfolder. These are automatically merged into the child
//# `terragrunt.hcl` config via the include block.
//# ---------------------------------------------------------------------------------------------------------------------

locals {
  environment             = "testing"
  scost                   = "testing"
  monitoring              = "true"
  account_id              = "255686512659"
  region_bucket           = "us-east-2"
  bucket_remote_tfstate   = "my-terraform-remote-state-02"
  dynamodb_remote_tfstate = "my-terraform-state-lock-dynamo"
  profile_remote_tfstate  = "default"

  # To generate customer_id, execute:
  # cat /dev/urandom | tr -dc "a-z0-9" | fold -w  10 | head -n 1 | tr -d "\n"
  # Example: cdk17o7adl (mycustomer)
  customer_id   = "cdk17o7adl"
  customer_name = "mycustomer"

  #----------------------------
  # EKS Configurations
  #----------------------------
  cluster_endpoint_public_access_cidrs = [
    "201.82.34.213/32",
  ]

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::255686512659:policy/eks_cluster_autoscaler",
    "arn:aws:iam::255686512659:policy/aws_lb_controller",
  ]

  map_roles = [
    {
      rolearn  = "arn:aws:iam::255686512659:role/adsoft"
      username = "Admins"
      groups   = ["system:masters"]
    },
  ]
  
  map_users = [
    {
      userarn  = "arn:aws:iam::255686512659:user/aeciopires"
      username = "aeciopires"
      groups   = ["system:masters"]
    },
  ]

}
