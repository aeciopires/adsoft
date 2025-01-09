include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "rule" {
  path   = find_in_parent_folders("rule.hcl")
  expose = true
}

locals {
  region_vars          = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region               = local.region_vars.locals.region
  dependency_base_path = "${dirname(find_in_parent_folders())}/${local.region}"
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared",
    "${local.dependency_base_path}/network/subnets/shared-services1"
  ]
}

# Extracting the output from another terragrunt.hcl
dependency "vpc" {
  config_path = "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared"
}

dependency "subnet-shared-services1" {
  config_path = "${local.dependency_base_path}/network/subnets/shared-services1"
}

inputs = {

  # Reference: https://cloud.google.com/firewall/docs/firewalls
  # Rule priority
  # The firewall rule priority is an integer from 0 to 65535, inclusive. Lower integers indicate higher priorities.
  # If you do not specify a priority when creating a rule, it is assigned a priority of 1000.

  network_name  = dependency.vpc.outputs.network_name

  ingress_rules = [
    {
      # Reference: https://letsencrypt.org/docs/integration-guide/#firewall-configuration
      # For the “http-01” ACME challenge, you need to allow inbound port 80 traffic.
      name                    = "allow-web-traffic-nonprod-nginx-ingress"
      description             = "Use temporaly to challenge HTTP/HTTPS with nginx and certmanager"
      disabled                = false
      priority                = 9999
      destination_ranges      = [
        "X.X.X.X/32", # CHANGE_HERE
      ]
      source_ranges           = [
        "0.0.0.0/0",
      ]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = [80,443]
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
    {
      name                    = "allow-intra-traffic"
      description             = "Allow intra traffic in internal subnets"
      disabled                = false
      priority                = 1
      destination_ranges      = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].ip_cidr_range,
      ]
      source_ranges           = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].ip_cidr_range,
      ]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "all"
          ports    = []
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
    {
      name                    = "allow-gcp-loadbalancer-health-check"
      description             = "This is an ingress rule that allows traffic from the Google Cloud and Loadbalancer health checking systems (130.211.0.0/22 and 35.191.0.0/16)"
      disabled                = false
      priority                = 1
      destination_ranges      = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].ip_cidr_range,
      ]
      source_ranges           = [
        "130.211.0.0/22",   # Google Cloud and Loadbalancer health checking systems
        "35.191.0.0/16",    # Google Cloud and Loadbalancer health checking systems
      ]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = []
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
    {
      name                    = "allow-vpc-nonprod-shared-icmp"
      description             = null
      disabled                = false
      priority                = 1
      destination_ranges      = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].ip_cidr_range,
      ]
      source_ranges           = [
        "X.X.X.X/Y",     # CHANGE_HERE
      ]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "icmp"
          ports    = []
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
    {
      name                    = "allow-vpc-nonprod-shared-ssh"
      description             = "Allow connect GCP services to private instance using SSH/IAP connections"
      disabled                = false
      priority                = 1
      destination_ranges      = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].ip_cidr_range,
      ]
      source_ranges           = [
        "35.235.240.0/20",
      ]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
  ]

  egress_rules = [
    {
      name                    = "allow-output-traffic"
      description             = "Allow output traffic"
      disabled                = false
      priority                = 65535
      destination_ranges      = ["0.0.0.0/0"]
      source_ranges           = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].ip_cidr_range
      ]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "all"
          ports    = []
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
    {
      name                    = "example-ssh-egress"
      description             = null
      disabled                = true
      priority                = null
      destination_ranges      = ["10.0.0.0/8"]
      source_ranges           = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        },
      ]
      deny = []
      # Uncomment the next lines to enable firewall-rule logs
      #log_config = {
      #  metadata = "INCLUDE_ALL_METADATA"
      #}
    },
  ]

}
