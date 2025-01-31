include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "alb" {
  path   = find_in_parent_folders("alb.hcl")
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
  customer_id      = local.customer_vars.locals.customer_id
  ec2_target_id1   = "i-06f794b66d3a8343f" # CHANGE_HERE
  ec2_target_id2   = "CHANGE_HERE"
}


# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/vpc/net-${local.suffix}/",
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/asg/${local.customer_id}-apps/",
    #"${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/certificates/wildcard-mydomain-com/"
  ]
}

dependency "vpc" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/vpc/net-${local.suffix}/"
}

dependency "asg" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/asg/${local.customer_id}-apps/"
}

#dependency "certificate" {
#  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/certificates/wildcard-mydomain-com/"
#}

inputs = {
  # Used only tests. In production environment, must be true
  enable_deletion_protection = false

  vpc_id  = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.public_subnets

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = dependency.vpc.outputs.vpc_cidr_block
    }
  }

  listeners = {
    example-http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "example-instance"
      }

      rules = {
        ex-fixed-response = {
          priority = 3
          actions = [{
            type         = "fixed-response"
            content_type = "text/plain"
            status_code  = 200
            message_body = "This is a fixed response"
          }]

          conditions = [{
            http_header = {
              http_header_name = "x-Gimme-Fixed-Response"
              values           = ["yes", "please", "right now"]
            }
          }]
        }
      }
    },
#    ex-http-https-redirect = {
#      port     = 80
#      protocol = "HTTP"
#      redirect = {
#        port        = "443"
#        protocol    = "HTTPS"
#        status_code = "HTTP_301"
#      }
#
#      rules = {
#        ex-fixed-response = {
#          priority = 3
#          actions = [{
#            type         = "fixed-response"
#            content_type = "text/plain"
#            status_code  = 200
#            message_body = "This is a fixed response"
#          }]
#
#          conditions = [{
#            http_header = {
#              http_header_name = "x-Gimme-Fixed-Response"
#              values           = ["yes", "please", "right now"]
#            }
#          }]
#        }
#      }
#    },
#    example-https = {
#      port                        = 443
#      protocol                    = "HTTPS"
#      # Reference: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/describe-ssl-policies.html
#      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#      certificate_arn             = dependency.certificate.outputs.acm_certificate_arn
#      additional_certificate_arns = [dependency.certificate.outputs.acm_certificate_arn]
#
#      forward = {
#        target_group_key = "example-instance"
#      }
#
#      rules = {
#        ex-fixed-response = {
#          priority = 3
#          actions = [{
#            type         = "fixed-response"
#            content_type = "text/plain"
#            status_code  = 200
#            message_body = "This is a fixed response"
#          }]
#
#          conditions = [{
#            http_header = {
#              http_header_name = "x-Gimme-Fixed-Response"
#              values           = ["yes", "please", "right now"]
#            }
#          }]
#        }
#      }
#    },
  }

  # More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
  target_groups = {
    example-instance = {
      name_prefix                       = "h1"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      # More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#load_balancing_algorithm_type-1
      load_balancing_algorithm_type     = "round_robin"
      # You cannot enable both anomaly mitigation and round robin algorithm on a target group
      load_balancing_anomaly_mitigation = "off"
      load_balancing_cross_zone_enabled = true

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      # More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        # expected health_check.0.healthy_threshold to be in the range (2 - 10)
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      target_id        = local.ec2_target_id1
      port             = 80
    }
  }

  #additional_target_group_attachments = {
  #  ex-instance-other = {
  #    target_group_key = "example-instance"
  #    target_type      = "instance"
  #    target_id        = local.ec2_target_id2
  #    port             = "80"
  #  }
  #}

  # Optional Route53 Record(s)
  route53_records = {}

  tags = merge(
    local.customer_tags,
  )
}
