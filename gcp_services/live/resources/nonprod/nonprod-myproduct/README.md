# Menu

<!-- TOC -->
- [Menu](#menu)
- [About](#about)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [Deploying](#deploying)
<!-- TOC -->

# About

Code of Terraform and Terragrunt to create infrastructure as code in GCP.

# Directory Structure

The general directory structure is:

```bash
├── account.hcl # definitions of project name previous created in GCP and file location of credentials of service account of GCP
├── README.md # this documentation
├── .sops.yaml # file with configuation KMS used to encrypt/decrypt secrets
├── root.hcl # file with configuation of GCS bucket to storage terragrunt state
├── .terraform-version # file with terraform version used by tf-env application
├── .terragrunt-version # file with terragrunt version used by tg-env application
└── us-central1 # directory with the region where the infra will be create
    ├── region.hcl # region where the infra will be create
```

# Prerequisites

Access https://terragrunt.gruntwork.io/docs/#getting-started for more informations about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt will forward almost all commands, arguments, and options directly to Terraform, but based on the settings in your ``terragrunt.hcl`` file.

To run the commands described in this document, you need the following:

- Install all packages and binaries following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.

To run the commands described in this document, you need the following:

- Get permissions of Owner in project GCP.
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
└── us-central1
    ├── buckets
    │   ├── nonprod-gyr4
    ├── kms
    │   ├── nonprod-gyr4
    ├── cloudsql
    │   └── postgresql
    │       ├── nonprod-psql-gyr4
    ├── gke
    │   └── standard
    │       ├── nonprod-gyr4
    └── static-ips
        └── public-ips
            ├── nonprod-gyr4
    ├── cdn-bucket
    │   └── nonprod-gyr4
```
