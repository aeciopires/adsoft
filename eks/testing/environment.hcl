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

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::255686512659:policy/eks-cluster-autoscaler",
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
    {
      userarn  = "arn:aws:iam::255686512659:root"
      username = "root"
      groups   = ["system:masters"]
    },
  ]

}
