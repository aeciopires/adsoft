include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "ec2" {
  path   = find_in_parent_folders("ec2.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment      = local.environment_vars.locals.environment_name
  region           = local.region_vars.locals.region
  az_name_list     = local.region_vars.locals.az_name_list
  customer_id      = local.customer_vars.locals.customer_id
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

  # Ubuntu 24.04 64 bits AMD64 HVM SSD.
  # References: 
  #   https://aws.amazon.com/marketplace/b/c3bc6a75-0c3a-46ce-8fdd-498b6fd88577
  #   https://cloud-images.ubuntu.com/locator/ec2/
  ami           = "ami-0e44962f5c9a2baab"
  # Reference: https://aws.amazon.com/ec2/instance-types/
  instance_type = "t3.medium"

  availability_zone      = local.az_name_list[0]
  subnet_id              = dependency.vpc.outputs.public_subnets[0]
  vpc_security_group_ids = [
    dependency.vpc.outputs.default_security_group_id
  ]

  associate_public_ip_address = true
  monitoring                  = false
  disable_api_stop            = false
  key_name                    = dependency.keypair.outputs.key_pair_name
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies           = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  # only one of these can be enabled at a time
  hibernation = true
  # enclave_options_enabled = true

  user_data_base64            = base64encode(file("${get_terragrunt_dir()}/configurations/userdata.tpl"))
  user_data_replace_on_change = true

  enable_volume_tags = false
  root_block_device  = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "${include.ec2.inputs.name}-root-ebs"
      }
    },
  ]

  tags = merge(
    local.customer_tags,
  )
}
