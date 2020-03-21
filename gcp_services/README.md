#### Menu

<!-- TOC -->

- [English](#english)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
  - [Configure AWS Credentials](#configure-aws-credentials)
  - [Configure GCP Credentials](#configure-gcp-credentials)
  - [Install Terragrunt, Terraform 0.12 and other tools](#install-terragrunt-terraform-012-and-other-tools)
- [How to](#how-to)
- [Developers](#developers)
- [License](#license)

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

## Configure AWS Credentials

NOTE: Developed using Terraform 0.12.x syntax.

* You will need to create an Amazon AWS account. Create a 'Free Tier' account at Amazon https://aws.amazon.com/ follow the instructions on the pages: https://docs.aws.amazon.com/chime/latest/ag/aws-account.html and https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html. When creating the account you will need to register a credit card, but since you will create instances using the features offered by the 'Free Tier' plan, nothing will be charged if you do not exceed the limit for the use of the features and time offered and described in the previous link .
* After creating the account in AWS, access the Amazon CLI interface at: https://aws.amazon.com/cli/
* Click on the username (upper right corner) and choose the "Security Credentials" option. Then click on the "Access Key and Secret Access Key" option and click the "New Access Key" button to create and view the ID and Secret of the key, as shown below (https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html). The Access Key and Secret Key shown below are for illustration only. They are invalid and you need to exchange for the actual data generated for your account.

```bash
Access Key ID: YOUR_ACCESS_KEY_HERE
Secret Access Key: YOUR_SECRET_ACCESS_KEY_HERE
```

* Create the directory below.

```bash
mkdir -p /home/USERNAME/.aws/
touch /home/USERNAME/.aws/credentials
```

* Access ``/home/USERNAME/.aws/credentials`` file and add the following content. The Access Key and Secret Key shown below are for illustration only. They are invalid and you need to exchange for the actual data generated for your account.

```bash
[default]
aws_access_key_id = YOUR_ACCESS_KEY_HERE
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE
```

## Configure GCP Credentials

* You will need to create an Google Cloud Platform account: https://console.cloud.google.com

* Install and configure the ``gcloud`` following the instructions on tutorials.

https://cloud.google.com/docs/authentication/getting-started

https://console.cloud.google.com/apis/credentials/serviceaccountkey

https://cloud.google.com/sdk/install

https://cloud.google.com/sdk/docs/downloads-apt-get

https://cloud.google.com/sdk/gcloud/reference/config/set

https://code-maven.com/gcloud

https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97

https://blog.realkinetic.com/using-google-cloud-service-accounts-on-gke-e0ca4b81b9a2

https://www.the-swamp.info/blog/configuring-gcloud-multiple-projects/

## Install Terragrunt, Terraform 0.12 and other tools

* Download ``Terraform`` for Linux: https://www.terraform.io/downloads.html<br>
    Home page: https://www.terraform.io<br>
    GitHub: https://github.com/hashicorp/terraform<br>
    Documentation: https://www.terraform.io/docs

* Unpack Terraform package.
* Access the unpacked directory.
* Copy the Terraform binary to the ``/usr/bin`` directory with the following commands:

```bash
sudo cp terraform /usr/bin
sudo chmod 755 /usr/bin/terraform
```

* Download ``Terragrunt`` for Linux AMD64: https://github.com/gruntwork-io/terragrunt/releases<br>
    Home page: https://terragrunt.gruntwork.io<br>
    GitHub: https://github.com/gruntwork-io/terragrunt<br>
    Documentation: https://terragrunt.gruntwork.io/docs

```
sudo mv terragrunt_linux_amd64 /usr/bin/terragrunt
sudo chmod +x /usr/bin/terragrunt
```


# How to

* Execute the commands.

```
git clone https://github.com/aeciopires/adsoft

cd adsoft/gcp_services/config_terragrunt
```

Read ``adsoft/gcp_services/config_terragrunt/README.md`` file.


# Developers

developer: Aécio dos Santos Pires<br>
mail: http://blog.aeciopires.com/contato

developer: André Luis Boni Déo<br>
mail: andredeo at gmail dot com


# License

GPL-3.0 2020 Aécio dos Santos Pires and André Luis Boni Déo