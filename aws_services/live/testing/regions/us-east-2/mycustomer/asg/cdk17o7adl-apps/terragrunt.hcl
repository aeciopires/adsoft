include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "asg" {
  path   = find_in_parent_folders("asg.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment      = local.environment_vars.locals.environment_name
  region           = local.region_vars.locals.region
  az_name_list     = local.region_vars.locals.az_name_list
  customer_tags    = local.customer_vars.locals.customer_tags
  suffix           = local.customer_vars.locals.suffix1
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/vpc/net-${local.suffix}/",
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/keypair/key-${local.suffix}/",
  ]
}

dependency "vpc" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/vpc/net-${local.suffix}/"
}

dependency "keypair" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/keypair/key-${local.suffix}/"
}

inputs = {
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = dependency.vpc.outputs.private_subnets

  # Ubuntu 24.04 64 bits AMD64 HVM SSD.
  # References: 
  #   https://aws.amazon.com/marketplace/b/c3bc6a75-0c3a-46ce-8fdd-498b6fd88577
  #   https://cloud-images.ubuntu.com/locator/ec2/
  image_id          = "ami-0cb91c7de36eed2cb"
  # Reference: https://aws.amazon.com/ec2/instance-types/
  instance_type     = "t3.medium"
  ebs_optimized     = true
  enable_monitoring = false
  user_data         = base64encode(file("${get_terragrunt_dir()}/configurations/userdata.tpl"))
  key_name          = dependency.keypair.outputs.key_pair_name

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_policies           = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  # More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#cpu-options
  cpu_options = {}

  # More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#credit-specification
  credit_specification = {
    cpu_credits = "standard"
  }

  #instance_market_options = {
  #  market_type = "spot" # or "capacity-block"
  #  spot_options = {
  #    block_duration_minutes = 60
  #  }
  #}

  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # More options: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#network-interfaces
  network_interfaces = [
    {
      associate_public_ip_address = false
    }
  ]

  tags = merge(
    local.customer_tags,
  )
}
