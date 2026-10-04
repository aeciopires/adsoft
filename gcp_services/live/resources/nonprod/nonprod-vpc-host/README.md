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
├── root.hcl # file with configuration of GCS bucket to storage terragrunt state
└── us-central1 # directory with the region where the infrastructure will be created
    ├── region.hcl # region where the infrastructure will be created
```

# Requirements

Access https://docs.terragrunt.com/getting-started/quick-start/ for more information about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

The versions of Terraform and Terragrunt used by this code are defined in the files ``gcp_services/live/.terraform-version`` and ``gcp_services/live/.terragrunt-version``.

To run the commands described in this document, you need the following:

- Install all packages and binaries following the instructions on the [REQUIREMENTS.md](../../../../../REQUIREMENTS.md) file.
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
  - Optionally, the user needs to be SuperAdmin in organization.
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

- Run ``terragrunt init --backend-bootstrap`` (only in the first time). Since Terragrunt 1.0 the GCS bucket used to store the Terraform state is created only when the flag ``--backend-bootstrap`` is used (or with the command ``terragrunt backend bootstrap``).
- Run ``terragrunt plan`` and review the output.
- Run ``terragrunt apply``.

Reference: https://docs.terragrunt.com/features/units/state-backend/

Order to apply directory resources to manage the organization:

```bash
└── us-central1
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
