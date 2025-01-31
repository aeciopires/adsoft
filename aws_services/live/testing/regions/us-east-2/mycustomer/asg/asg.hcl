locals {
  asg_name = "${basename(get_terragrunt_dir())}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/autoscaling/aws//?version=8.0.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # References:
  # https://terraformguru.com/terraform-real-world-on-aws-ec2/14-Autoscaling-with-Launch-Configuration/
  # https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/
  # https://github.com/terraform-aws-modules/terraform-aws-autoscaling/blob/master/examples/complete/main.tf

  name   = local.asg_name
  create = true

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = []

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  # More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#instance_refresh
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
      max_healthy_percentage = 100
    }
    # Issue references:
    # https://github.com/hashicorp/terraform-provider-aws/issues/23274
    # https://github.com/hashicorp/terraform-provider-aws/issues/23274#issuecomment-1414225872
    triggers = ["tag"]
  }

  # Launch template
  create_launch_template      = true
  launch_template_name        = local.asg_name
  launch_template_description = "Launch template for ASG ${local.asg_name}"
  update_default_version      = true

  # Ubuntu 24.04 64 bits AMD64 HVM SSD.
  # References: 
  #   https://aws.amazon.com/marketplace/b/c3bc6a75-0c3a-46ce-8fdd-498b6fd88577
  #   https://cloud-images.ubuntu.com/locator/ec2/
  image_id          = "ami-0cb91c7de36eed2cb"
  # Reference: https://aws.amazon.com/ec2/instance-types/
  instance_type     = "t3.medium"
  ebs_optimized     = true
  enable_monitoring = false
  user_data         = ""
  key_name          = ""

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "asg-${local.asg_name}"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for ASG ${local.asg_name}"
  iam_role_tags               = {
    CustomIamRole = "Yes"
  }
  iam_role_policies           = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs         = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 50
        volume_type           = "gp3"
        tags                  = {
          Name = "${local.asg_name}-root-ebs"
        }
      }
    },
  ]

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

  tags = {}
}
