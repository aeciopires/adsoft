#### Menu

<!-- TOC -->

- [English](#english)
- [How to](#how-to)
- [About Terraform commands](#about-terraform-commands)
- [About Terragrunt commands](#about-terragrunt-commands)
  - [Using a registry without SSL](#using-a-registry-without-ssl)
- [Documentation of Code Terraform](#documentation-of-code-terraform)
  - [Providers](#providers)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

<!-- /TOC -->

# English

NOTE: Developed using Terraform 0.12.x syntax.

* Configure the AWS Credentials and install the general packages, Terraform, Terragrunt, Go and Terraform-Docs following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

* Clone this repository.

```bash
git clone https://github.com/aeciopires/adsoft

cd adsoft/aws_services
```

1. This directory contains the files:<br>
  * ``terraform_prod.tfvars``  => where you can define the values of the variables for environment *production* used by ``main.tf``. See [Inputs](#inputs)
  * ``variables.tf``      => The default values of the variables
used by ``main.tf``, if you not define values in to ``terraform_prod.tfvars`` file. See [Inputs](#inputs)
2. The goal is to install Docker Registry, Prometheus, Zabbix, Grafana and Apps.

# How to

* Change the values according to the need of the environment in the ``terraform_prod.tfvars`` file.

* Validate the settings and create the environment with the following commands

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt show
```

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt will forward almost all commands, arguments, and options directly to Terraform, but based on the settings in your ``terragrunt.hcl`` file

# About Terraform commands

Useful commands:

* ``terraform --help``    => Show help of command terraform<br>
* ``terraform providers`` => Prints a tree of the providers used in the configuration<br>
* ``terraform init``      => Initialize a Terraform working directory<br>
* ``terraform validate``  => Validates the Terraform files<br>
* ``terraform plan``      => Generate and show an execution plan<br>
* ``terraform apply``     => Builds or changes infrastructure<br>
* ``terraform show``      => Inspect Terraform state or plan<br>
* ``terraform destroy``   => Destroy Terraform-managed infrastructure<br>
* ``terraform output``    => Show informations output.
* ``terraform graph | dot -Tsvg > graph.svg`` => Show graph with resources relationaments.

No destroy some resource:

* list all resources
  ```
  terraform state list
  ```
* remove that resource you don't want to destroy, you can add more to be excluded if required
  ```
  terraform state rm <resource_to_be_deleted>
  ```
* destroy the whole stack except above resource(s)
  ```
  terraform destroy
  ```

# About Terragrunt commands

Access: https://terragrunt.gruntwork.io/docs/getting-started/cli-options/

## Using a registry without SSL

In the your notebook or computer, edit or create the daemon.json file, whose default location is /etc/docker/daemon. Add the follow content:

```
{
  "insecure-registries" : ["myregistrydomain.com:5000"]
}

```

Change ``myregistrydomain.com`` for IP Address server of according your environment.

```
sudo systemctl restart docker
```

Reference:
https://docs.docker.com/registry/insecure/

# Documentation of Code Terraform

* Generate docs with terraform-docs for project ``adsoft/aws_services``.

```bash
cd adsoft/aws_services

terraform-docs markdown . > /tmp/doc.md

cat /tmp/doc.md
```

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address\_allowed | IP or Net address allowed for remote access. | `string` | `"179.159.236.209/32"` | no |
| aws\_instance\_user | Instance user for remote connection. | `string` | `"ubuntu"` | no |
| aws\_key\_name | Key name. | `string` | `"aws-teste"` | no |
| aws\_key\_private\_path | Private Key Private path. | `string` | `"/home/aws-teste.pem"` | no |
| aws\_key\_public\_path | Private Key Public path. | `string` | `"/home/aws-teste.pub"` | no |
| aws\_zone | The zone to operate under, if not specified by a given resource. Reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html | `string` | `"us-east-2"` | no |
| disk\_size | AWS EBS disk size in GB | `number` | `300` | no |
| disk\_type | AWS EBS disk type. Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html | `string` | `"gp2"` | no |
| port\_apps\_crud\_api | Port Apps Crud API. | `number` | `9000` | no |
| port\_apps\_nodejs | Port Apps NodeJS. | `number` | `8080` | no |
| port\_apps\_python\_external\_01 | Port Apps Python external. | `number` | `8001` | no |
| port\_apps\_python\_external\_02 | Port Apps Python external. | `number` | `8002` | no |
| port\_grafana\_external | Port Grafana external. | `number` | `3000` | no |
| port\_loki\_external | Port Loki external. | `number` | `3100` | no |
| port\_prometheus\_external | Port Prometheus external. | `number` | `9090` | no |
| port\_protocol | Protocol of container ports. | `string` | `"TCP"` | no |
| port\_registry\_external | Port Registry external. | `number` | `5000` | no |
| port\_ssh\_external | Port SSH external. | `number` | `22` | no |
| port\_zabbix\_server\_external | Port Zabbix Server external. | `number` | `10051` | no |
| port\_zabbix\_web\_external | Port Prometheus external. | `number` | `80` | no |
| s3\_bucket\_name | S3 bucket name | `string` | `"adsoft_bucket"` | no |
| vpc\_cidr\_block | Range of IPv4 address for the VPC. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| apps\_instance\_id | ID instance |
| apps\_instance\_name | Name instance |
| apps\_ip\_private | Private IP instance |
| apps\_ip\_public | Public IP instance |
| loki\_instance\_id | ID instance |
| loki\_instance\_name | Name instance |
| loki\_ip\_private | Private IP instance |
| loki\_ip\_public | Public IP instance |
| monitoring\_instance\_id | ID instance |
| monitoring\_instance\_name | Name instance |
| monitoring\_ip\_private | Private IP instance |
| monitoring\_ip\_public | Public IP instance |
| registry\_instance\_id | ID instance |
| registry\_instance\_name | Name instance |
| registry\_ip\_private | Private IP instance |
| registry\_ip\_public | Public IP instance |
| security\_group | Id of security Group |
