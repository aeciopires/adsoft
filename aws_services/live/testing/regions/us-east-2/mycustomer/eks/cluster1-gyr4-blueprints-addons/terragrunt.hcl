# ATTENTION!
# Before apply this configuration, run the command:
# export KUBE_CONFIG_PATH=~/.kube/config
# Workaround reported here: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1234

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "eks-blueprints-addons" {
  path   = find_in_parent_folders("eks-1-32-blueprints-addons.hcl")
  expose = true
}

locals {
  environment_vars  = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars     = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment       = local.environment_vars.locals.environment_name
  region            = local.region_vars.locals.region
  customer_tags     = local.customer_vars.locals.customer_tags
  suffix            = local.customer_vars.locals.cluster1_suffix
  cluster_name      = local.customer_vars.locals.cluster1_name
  cluster_shortname = local.customer_vars.locals.cluster1_short_name
  vpc_id            = "CHANGE_HERE"


  aws_load_balancer_controller_yaml = <<-EOF
    clusterName: "${local.cluster_name}"
    region: "${local.region}"
    vpcId: "${local.vpc_id}"

    ingressClass: alb
    ingressClassParams:
      create: true
      name: alb

    resources:
      limits:
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 128Mi

    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: aws-load-balancer-controller
          namespaces:
          - kube-system
          topologyKey: kubernetes.io/hostname
    enableServiceMutatorWebhook: false
  EOF



  cluster_autoscaler_yaml = <<-EOF
    replicaCount: 2

    image:
      tag: "v1.32.0"

    priorityClassName: "system-cluster-critical"

    autoDiscovery:
      clusterName: "${local.cluster_name}"
      tags:
        - "k8s.io/cluster-autoscaler/enabled"
        - "k8s.io/cluster-autoscaler/${local.cluster_name}"

    cloudProvider: aws

    awsRegion: "${local.region}"

    extraArgs:
      expander: least-waste

    updateStrategy:
      type: RollingUpdate
      rollingUpdate:
        maxUnavailable: 1

    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: aws-cluster-autoscaler
          namespaces:
          - kube-system
          topologyKey: kubernetes.io/hostname
  EOF
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/eks/${local.cluster_shortname}-${local.suffix}/",
  ]
}

dependency "eks" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/eks/${local.cluster_shortname}-${local.suffix}/"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  cluster_name      = dependency.eks.outputs.cluster_name
  cluster_endpoint  = dependency.eks.outputs.cluster_endpoint
  cluster_version   = dependency.eks.outputs.cluster_version
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  # References:
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/aws-load-balancer-controller.md
  # https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
  aws_load_balancer_controller = {
    name          = "aws-load-balancer-controller"
    # Install version v2.11.0 of aws-load-balancer-controller.
    # See new changes on release notes of application: https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases
    chart_version = "1.11.0"
    repository    = "https://aws.github.io/eks-charts"
    namespace     = "kube-system"
        values        = [
      local.aws_load_balancer_controller_yaml
    ]
  }


  # References:
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/cluster-autoscaler.md
  # https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
  #
  cluster_autoscaler = {
    name          = "cluster-autoscaler"
    # Install version 1.32.0 of cluster-autoscaler chart. 
    # See new changes on release notes of application: https://github.com/kubernetes/autoscaler/releases
    chart_version = "9.46.0"
    repository    = "https://kubernetes.github.io/autoscaler"
    namespace     = "kube-system"
    values        = [
      local.cluster_autoscaler_yaml
    ]
  }

  tags           = merge(
    local.customer_tags,
  )
}
