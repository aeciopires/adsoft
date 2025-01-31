locals {
  loadbalancer_name = "${basename(get_terragrunt_dir())}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/alb/aws//?version=9.13.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = { 
  # References
  # https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest
  # https://github.com/terraform-aws-modules/terraform-aws-alb/blob/v9.13.0/examples/complete-alb/main.tf
  # https://terraformguru.com/terraform-real-world-on-aws-ec2/14-Autoscaling-with-Launch-Configuration/

  name               = local.loadbalancer_name
  create             = true
  load_balancer_type = "application"

  vpc_id  = ""
  subnets = [] # public-subnets

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
      cidr_ipv4   = "CHANGE_HERE_VPC_CIDR_IPV4"
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
#      certificate_arn             = CHANGE_HERE_ACM_CERTIFICATE_ARN
#      additional_certificate_arns = [CHANGE_HERE_ACM_CERTIFICATE_ARN]
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
        path                = "/healthz"
        port                = "traffic-port"
        # expected health_check.0.healthy_threshold to be in the range (2 - 10)
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      target_id        = "aws_instance_id" # CHANGE_HERE
      port             = 80
      tags = {
        InstanceTargetGroupTag = "baz"
      }
    }
  }

  #additional_target_group_attachments = {
  #  ex-instance-other = {
  #    target_group_key = "example-instance"
  #    target_type      = "instance"
  #    target_id        = "aws_instance_id" # CHANGE_HERE
  #    port             = "80"
  #  }
  #}

  # Optional Route53 Record(s)
  route53_records = {}

  tags = {}
}
