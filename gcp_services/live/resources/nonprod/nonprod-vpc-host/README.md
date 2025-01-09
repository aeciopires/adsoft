# Menu

<!-- TOC -->
- [Menu](#menu)
- [About](#about)
- [Directory Structure](#directory-structure)
- [Requirements](#requirements)
- [Deploying](#deploying)
<!-- TOC -->

# About

Code of Terraform and Terragrunt to create infrastructure as code in GCP.

# Directory Structure

The general directory structure is:

```bash
├── account.hcl # definitions of project name previous created in GCP and file location of credentials of service account of GCP
├── README.md # this documentation
├── root.hcl # file with configuation of GCS bucket to storage terragrunt state
├── .terraform-version # file with terraform version used by tf-env application
├── .terragrunt-version # file with terragrunt version used by tg-env application
└── generic # directory with generic resources without region
└── us-central1 # directory with the region where the infra will be create
    ├── region.hcl # region where the infra will be create
```

# Requirements

Access https://terragrunt.gruntwork.io/docs/#getting-started for more informations about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt will forward almost all commands, arguments, and options directly to Terraform, but based on the settings in your ``terragrunt.hcl`` file.

To run the commands described in this document, you need the following:

- Install all packages and binaries following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.
- Set up a Google Cloud
   [organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization).
- Set up a Google Cloud
   [billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
- For the user who will run the Terragrunt install, grant the following roles:
  - The `roles/billing.admin` role on the billing account.
  - The `roles/resourcemanager.organizationAdmin` role on the Google Cloud organization.
  - The `roles/resourcemanager.folderCreator` role on the Google Cloud organization.
  - The `roles/resourcemanager.projectCreator` role on the Google Cloud organization.
  - The `roles/compute.xpnAdmin` role on the Google Cloud organization.
  - The Group Admin role should be granted in Google Admin.
  - Optionaly, the user needs to be SuperAdmin in organization.
    More info: https://support.google.com/a/answer/2405986
- Login in GCP using gcloud:

```bash
gcloud init

# The default browser will open to complete login and grant permissions.
gcloud auth login
gcloud auth application-default login
```

# Deploying

- Access each directory that contains terragrunt.hcl file.

> ATTENTION!!!
> Pay attention in order/dependency of resource before apply changes.

- Run ``terragrunt init``.
- Run ``terragrunt plan`` and review the output.
- Run ``terragrunt apply``.

Order to apply directory resources to manage the organization:

```bash
|── us-central1
    ├── network
    │   ├── vpc
    │   │    ├── vpc-nonprod-shared
    │   ├── subnets
    │   │   ├── shared-services1
    │   ├── static-ips
    │   │   └── public-ips
    │   │       ├── nonprod-external-ip-nat
    │   ├── routes
    │   │   ├── route-nonprod-shared
    │   ├── routers
    │   │   ├── router-nonprod-shared
    │   ├── nat
    │   │   ├── nat-nonprod-shared
    │   ├── firewall-rules
    │   │   ├── nonprod-general-rules
```
