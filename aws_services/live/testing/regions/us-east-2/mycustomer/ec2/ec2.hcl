locals {
  instance_name = "${basename(get_terragrunt_dir())}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//?version=5.7.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name          = local.instance_name
  create        = true
  # Ubuntu 24.04 64 bits AMD64 HVM SSD.
  # References: 
  #   https://aws.amazon.com/marketplace/b/c3bc6a75-0c3a-46ce-8fdd-498b6fd88577
  #   https://cloud-images.ubuntu.com/locator/ec2/
  ami           = "ami-0e44962f5c9a2baab"
  # Reference: https://aws.amazon.com/ec2/instance-types/
  instance_type = "t3.medium"

  availability_zone      = ""
  subnet_id              = ""
  vpc_security_group_ids = []

  associate_public_ip_address = true
  monitoring                  = false
  disable_api_stop            = false
  key_name                    = ""
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies           = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  # only one of these can be enabled at a time
  hibernation = true
  # enclave_options_enabled = true

  user_data_base64            = ""
  user_data_replace_on_change = true

  enable_volume_tags = false
  root_block_device  = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 20
      tags        = {
        Name = "${local.instance_name}-root-ebs"
      }
    },
  ]

  tags = {}
}
