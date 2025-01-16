locals {}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///aws-ia/eks-blueprints-addons/aws//?version=1.19.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  # References:
  # https://aws-ia.github.io/terraform-aws-eks-blueprints/
  # https://github.com/aws-ia/terraform-aws-eks-blueprints
  # Without IRSA: https://registry.terraform.io/modules/aws-ia/eks-blueprints-addons/aws/latest
  # With IRSA: https://registry.terraform.io/modules/aws-ia/eks-blueprints-addon/aws/latest
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/amazon-eks-addons.md
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/helm-release.md
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/architectures.md


  cluster_name      = ""
  cluster_endpoint  = ""
  cluster_version   = ""
  oidc_provider_arn = ""
  eks_addons        = {} # These addons will be installed on creation cluster

  enable_aws_load_balancer_controller    = true
  enable_cluster_autoscaler              = true
  enable_aws_node_termination_handler    = false
  enable_cluster_proportional_autoscaler = false
  enable_karpenter                       = false
  enable_kube_prometheus_stack           = false
  enable_metrics_server                  = false
  enable_external_dns                    = false
  enable_cert_manager                    = false
  enable_velero                          = false
  tags                                   = {}

  # References:
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/aws-load-balancer-controller.md
  # https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
  aws_load_balancer_controller = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/cluster-autoscaler.md
  cluster_autoscaler = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/aws-node-termination-handler.md
  aws_node_termination_handler = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/cluster-proportional-autoscaler.md
  cluster_proportional_autoscaler = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/karpenter.md
  karpenter = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/kube-prometheus-stack.md
  kube_prometheus_stack = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/metrics-server.md
  metrics_server = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/external-dns.md
  external_dns = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/cert-manager.md
  cert_manager = {}

  # Reference: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/velero.md
  velero = {}
}
