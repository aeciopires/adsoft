#### Menu

<!-- TOC -->

- [English](#english)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [How to](#how-to)

<!-- /TOC -->

# English

# Directory Structure

The directory structure is:

```bash
gcp_services/
├── config_terragrunt
│   ├── README.md # other documentation
│   ├── terragrunt.hcl # variables of configuration in terragrunt
│   └── testing  # Definitions of testing environment
│       └── project1 # Definitions of customer of project1
│           ├── network # directory with definitions of network
│           │   ├── firewall # directory with definitions of firewall rules
│           │   │   └── terragrunt.hcl
│           │   └── vpc # directory with definitions of Virtual Private Cloud
│           │       └── terragrunt.hcl
│           ├── project.yaml # definitions of project name previous created in GCP and file location of credentials of AWS and service account of GCP
│           └── us-east1 # directory with the region where the infra will be create
│               ├── kubernetes # directory with definitions of Kubernetes cluster
│               │   └── terragrunt.hcl
│               ├── region.yaml # region where the infra will be create
│               └── subnet # directory with definitions of subnet
│                   └── terragrunt.hcl
├── empty.yaml # this file guides the Terragrunt not to leave this scope
├── modules_terraform
│   └── gcp # directory with modules for GCP
│       └── kubernetes # module kubernetes
│       │   ├── config.tf
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── networking # directory with network modules
│           ├── firewall  # module for create firewall
│           │   ├── config.tf
│           │   ├── firewall.tf
│           │   └── variables.tf
│           ├── subnet  # module for create subnet, cloud NAT and cloud Router
│           │   ├── cloud-nat.tf
│           │   ├── cloud-router.tf
│           │   ├── config.tf
│           │   ├── output.tf
│           │   ├── subnet.tf
│           │   └── variables.tf
│           └── vpc # module for create vpc, network
│               ├── config.tf
│               ├── network.tf
│               ├── output.tf
│               └── variables.tf
└── README.md # this documentation
```

# Prerequisites

NOTE: Developed using Terraform 0.12.x syntax.

* Configure the AWS Credentials and install the general packages, Terraform, Terragrunt, Go, Gcloud and Terraform-Docs following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

# How to

* Execute the commands.

```
git clone https://github.com/aeciopires/adsoft

cd adsoft/gcp_services/config_terragrunt
```

Read ``adsoft/gcp_services/config_terragrunt/README.md`` file.


