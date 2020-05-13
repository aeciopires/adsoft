<!-- TOC -->

- [About](#about)
- [Requirements](#requirements)
  - [How to](#how-to)
- [Documentation of Code Terraform](#documentation-of-code-terraform)
  - [Providers](#providers)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
- [Throubleshooting](#throubleshooting)

<!-- TOC -->
# About

1. This directory contains the files:<br>
  * ``variables.tf`` => where you can define the values of the variables used by ``main.tf``.<br>
  * ``testing.tf`` => where you can define the values of the variables used in testing environment.<br>
2. The goal is to create EKS cluster in AWS.

# Requirements

=====================

NOTE: Developed using Terraform 0.12.x syntax.

=====================

* Configure the AWS Credentials and install the general packages, Terraform, Go and Terraform-Docs following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

* Create the following resources required for the functioning of the EKS cluster. Do this executing the Terraform code as instructed in the file [../networking-eks/README.md](../networking-eks/README.md). See the output of the ``terraform apply`` and change the values ​​of the subnets, vpc, security group in the [testing.tfvars](testing.tfvars) and [backend.tf](backend.tf) files according to the needs of your environment.
  * bucket S3 and DynamoDB table for Terraform state remote;
  * subnets public and private;
  * vpc;
  * NAT gateway;
  * Internet Gateway;
  * security group;
  * route table;

* Execute the commands.

```
git clone https://github.com/aeciopires/adsoft

cd adsoft/eks/mycluster-eks
```

## How to

* Change the values according to the need of the environment in the ``testing.tfvars`` and ``backend.tf`` files.

* Validate the settings and create the environment with the following commands

```bash
terraform init
terraform validate
terraform workspace list
terraform workspace new testing
terraform workspace select testing
terraform plan -var-file testing.tfvars
terraform apply -var-file testing.tfvars
terraform output
terraform show
```

Useful commands:

* ``terraform --help``   => Show help of command terraform<br>
* ``terraform init``     => Initialize a Terraform working directory<br>
* ``terraform validate`` => Validates the Terraform files<br>
* ``terraform plan``     => Generate and show an execution plan<br>
* ``terraform apply``    => Builds or changes infrastructure<br>
* ``terraform output``   => Reads an output variable from a Terraform state file and prints the value.<br>
* ``terraform show``     => Inspect Terraform state or plan<br>

Access cluster with Kubectl.

```bash
aws eks --region REGION_NAME update-kubeconfig --name CLUSTER_EKS_NAME --profile PROFILE_AWS_NAME

kubectl get nodes -A

kubectl get pods -A
```

# Documentation of Code Terraform


* Generate docs with terraform-docs for project ``adsoft/eks/mycluster-eks``.

```bash
cd adsoft/eks/mycluster-eks

terraform-docs markdown . > /tmp/doc.md

cat /tmp/doc.md
```

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.61.0 |
| local | >= 1.4.0 |
| null | >= 2.1.2 |
| template | >= 2.1.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address\_allowed | IP or Net address allowed for remote access. | `any` | n/a | yes |
| asg\_desired\_capacity | Number desired of nodes workers in cluster EKS. | `integer` | n/a | yes |
| asg\_max\_size | Number maximal of nodes workers in cluster EKS. | `integer` | n/a | yes |
| asg\_min\_size | Number minimal of nodes workers in cluster EKS. | `integer` | n/a | yes |
| autoscaling\_enabled | Enable ou disable autoscaling. | `boolean` | `true` | no |
| aws\_key\_name | Key pair RSA name. | `any` | n/a | yes |
| cluster\_enabled\_log\_types | A list of the desired control plane logging to enable.<br> For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "api",<br>  "audit"<br>]<br></pre> | no |
| cluster\_endpoint\_private\_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled. | `boolean` | `true` | no |
| cluster\_endpoint\_private\_access\_cidrs | List of CIDR blocks which can access the Amazon EKS private API server endpoint, when public access is disabled | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]<br></pre> | no |
| cluster\_endpoint\_public\_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled. | `boolean` | `true` | no |
| cluster\_endpoint\_public\_access\_cidrs | List of CIDR blocks which can access the Amazon EKS public API server endpoint. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]<br></pre> | no |
| cluster\_log\_retention\_in\_days | Number of days to retain log events. | `integer` | `"7"` | no |
| cluster\_name | Cluster EKS name. | `any` | n/a | yes |
| cluster\_version | Kubernetes version supported by EKS. <br> Reference: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html | `any` | n/a | yes |
| credentials\_file | PATH to credentials file | `string` | `"~/.aws/credentials"` | no |
| cw\_retention\_in\_days | Fluentd retention in days. | `integer` | `7` | no |
| environment | Name Terraform workspace. | `any` | n/a | yes |
| lt\_name | Name of template worker group. | `any` | n/a | yes |
| map\_roles | Additional IAM roles to add to the aws-auth configmap.<br> See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf for example format. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))<br></pre> | `[]` | no |
| map\_users | Additional IAM users to add to the aws-auth configmap.<br> See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf for example format. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))<br></pre> | `[]` | no |
| on\_demand\_percentage\_above\_base\_capacity | On demand percentage above base capacity. | `integer` | n/a | yes |
| override\_instance\_types | Type instances for nodes workers. Reference: https://aws.amazon.com/ec2/pricing/on-demand/ | `list(string)` | n/a | yes |
| profile | Profile of AWS credential. | `any` | n/a | yes |
| public\_ip | Enable ou disable public IP in cluster EKS. | `boolean` | `false` | no |
| region | AWS region. Reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html | `any` | n/a | yes |
| root\_volume\_size | Size of disk in nodes of cluster EKS. | `integer` | n/a | yes |
| subnets | List of IDs subnets public and/or private. | `list(string)` | n/a | yes |
| suspended\_processes | Cluster EKS name. | `any` | n/a | yes |
| tags | Maps of tags. | `map` | `{}` | no |
| vpc\_id | ID of VPC. | `any` | n/a | yes |
| worker\_additional\_security\_group\_ids | A list of additional security group ids to attach to worker instances. | `list(string)` | `[]` | no |
| workers\_additional\_policies | Additional policies to be added to workers | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint | Endpoint for EKS control plane. |
| cluster\_security\_group\_id | Security group ids attached to the cluster control plane. |
| config\_map\_aws\_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kubectl\_config | kubectl config as generated by the module. |
| region | AWS region. |


# Throubleshooting

Documentations:

* https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/
* https://github.com/kubernetes/kubernetes/issues/75457
* https://github.com/aws/containers-roadmap/issues/607
* https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html
* https://aws.amazon.com/pt/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/
* https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
* https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md
* https://github.com/terraform-aws-modules/terraform-aws-eks
* https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples


Result of command ``terraform init``

```bash
Initializing modules...
Downloading terraform-aws-modules/eks/aws 12.0.0 for eks-cluster...
- eks-cluster in .terraform/modules/eks-cluster/terraform-aws-eks-12.0.0
- eks-cluster.node_groups in .terraform/modules/eks-cluster/terraform-aws-eks-12.0.0/modules/node_groups

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "local" (hashicorp/local) 1.4.0...
- Downloading plugin for provider "template" (hashicorp/template) 2.1.2...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.61.0...
- Downloading plugin for provider "random" (hashicorp/random) 2.2.1...
- Downloading plugin for provider "kubernetes" (hashicorp/kubernetes) 1.11.2...
- Downloading plugin for provider "null" (hashicorp/null) 2.1.2...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.template: version = "~> 2.1"
```


Result of command ``terraform providers``

```bash
.
├── provider.aws
├── provider.kubernetes ~> 1.11.2
├── provider.local
├── provider.null
├── provider.template
└── module.eks-cluster
    ├── provider.aws >= 2.52.0
    ├── provider.kubernetes >= 1.11.1
    ├── provider.local >= 1.4
    ├── provider.null >= 2.1
    ├── provider.random >= 2.1
    └── module.node_groups
        ├── provider.aws (inherited)
        └── provider.random
```