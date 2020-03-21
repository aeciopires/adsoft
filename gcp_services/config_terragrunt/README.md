#### Menu

<!-- TOC -->

- [About](#about)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [How to](#how-to)
  - [To Create Infrastructure](#to-create-infrastructure)
  - [To Destroy Infrastructure](#to-destroy-infrastructure)
  - [Troubleshooting](#troubleshooting)

<!-- /TOC -->

# About

Code of Terraform and Terragrunt to create infrastructure as code in GCP.

# Directory Structure

The directory structure is:

```bash
config_terragrunt/
├── README.md # This documentation
├── terragrunt.hcl # variables of configuration in terragrunt
└── testing  # Definitions of testing environment
    └── project1 # Definitions of customer of project1
        ├── network # directory with definitions of network
        │   ├── firewall # directory with definitions of firewall rules
        │   │   └── terragrunt.hcl
        │   └── vpc # directory with definitions of Virtual Private Cloud
        │       └── terragrunt.hcl
        ├── project.yaml # definitions of project name previous created in GCP and file location of credentials of AWS and service account of GCP
        └── us-east1 # directory with the region where the infra will be create
            ├── kubernetes # directory with definitions of Kubernetes cluster
            │   └── terragrunt.hcl
            ├── region.yaml # region where the infra will be create
            └── subnet # directory with definitions of subnet
                └── terragrunt.hcl
```

# Prerequisites

* Read the parent file [README.md](../README.md) in ``Prerequisites`` section.

* Some API GCP must be enable manually in each GCP project. The Terragrunt and Terraform will be failures with names and URL of this APIs.

* Need to configure firewall rules.

# How to

## To Create Infrastructure

* Change the values according to the need of the environment in the ``terragrunt.hcl`` files.

* Access this directory in this sequency.

    * adsoft/gcp_services/config_terragrunt/testing/project1/network/vpc
    * adsoft/gcp_services/config_terragrunt/testing/project1/us-east1/subnet
    * adsoft/gcp_services/config_terragrunt/testing/project1/us-east1/kubernetes

* In each directory validate the settings and analysis the changes before apply in production.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt show
```

* Access this directory.

    * adsoft/gcp_services/config_terragrunt/testing/project1/network/firewall

* In each directory after validate the settings execute the follow commands to create the environment.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt show
```

Access https://terragrunt.gruntwork.io/docs/getting-started/cli-options/ for more informations about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt will forward almost all commands, arguments, and options directly to Terraform, but based on the settings in your ``terragrunt.hcl`` file

## To Destroy Infrastructure

* Access this directory in this sequency.

    * adsoft/gcp_services/config_terragrunt/testing/project1/network/firewall
    * adsoft/gcp_services/config_terragrunt/testing/project1/us-east1/kubernetes
    * adsoft/gcp_services/config_terragrunt/testing/project1/us-east1/subnet
    * adsoft/gcp_services/config_terragrunt/testing/project1/network/vpc

* In each directory validate the settings and analysis the changes before apply in production.

```bash
terragrunt destroy
```

## Troubleshooting

---
ERROR 1: API Cloud Resource Manager Disabled

``Atention!!!
During creation of Kubernetes cluster can show follow error.
``

```bash
Error: googleapi: Error 403: Google Compute Engine: Required 'compute.zones.get' permission for 'projects/...', forbidden

...

returned error: Error retrieving IAM policy for project ... googleapi: Error 403: Cloud Resource Manager API has not been used in project before or it is disabled...
```

``To solved error enable API Kubernetes visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=NUMBER_PROJECT then retry after some minutes.``

---

ERROR 2: Missing permission ``compute.zones.get``

``Atention!!!
During creation of Kubernetes cluster can show follow error.
``

```bash
Error: googleapi: Error 403: Google Compute Engine: Required 'compute.zones.get' permission for 'projects...'., forbidden
```

Read the posts: 
* https://stackoverflow.com/questions/48232189/google-compute-engine-required-compute-zones-get-permission-error
* https://stackoverflow.com/questions/47572766/service-account-does-not-exists-on-gcp

---

ERROR 3: 

```bash
Error: Request Create IAM Members roles/logging.logWriter serviceAccount:... for project... returned error: Error retrieving IAM policy for project googleapi: Error 403: Cloud Resource Manager API has not been used in project before or it is disabled.
```

``To solved error enable API Kubernetes visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=NUMBER_PROJECT then retry after some minutes.``

---