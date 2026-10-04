#### Menu

<!-- TOC -->

- [About](#about)
- [Requirements](#requirements)
- [Structure of directories](#structure-of-directories)
- [Clearing the Terragrunt cache](#clearing-the-terragrunt-cache)
- [How to Install](#how-to-install)
  - [Stage 0: Change the configurations](#stage-0-change-the-configurations)
  - [Stage 1: Create VPC](#stage-1-create-vpc)
  - [Stage 2: Create key pair RSA](#stage-2-create-key-pair-rsa)
  - [Stage 3: Create KMS](#stage-3-create-kms)
  - [Stage 4: Create Kubernetes cluster](#stage-4-create-kubernetes-cluster)
  - [Stage 5: Install EKS Blueprints addons](#stage-5-install-eks-blueprints-addons)
  - [Optionals: Route53 domain and records, ACM certificate, SES to send email, Autoscaling Group and loadbalancer (with target to EC2 instance)](#optionals-route53-domain-and-records-acm-certificate-ses-to-send-email-autoscaling-group-and-loadbalancer-with-target-to-ec2-instance)
- [Upgrading existing infrastructure](#upgrading-existing-infrastructure)
- [How to Uninstall](#how-to-uninstall)
  - [Remove Kubernetes cluster](#remove-kubernetes-cluster)
  - [Remove KMS](#remove-kms)
  - [Remove key pair RSA](#remove-key-pair-rsa)
  - [Remove subnets, NAT Gateway and VPC](#remove-subnets-nat-gateway-and-vpc)
  - [Remove optionals if created](#remove-optionals-if-created)
  - [Remove AWS S3 Bucket](#remove-aws-s3-bucket)
  - [Remove DynamoDB Table](#remove-dynamodb-table)

<!-- TOC -->

# About

Create EKS Kubernetes cluster using Terragrunt and Terraform code.

# Requirements

- Configure the AWS Credentials and install all packages and binaries following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.
- The versions of Terraform and Terragrunt used by this code are defined in the files ``live/.terraform-version`` and ``live/.terragrunt-version``.

Access https://docs.terragrunt.com/getting-started/quick-start/ for more information about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt forwards the most common commands (``init``, ``validate``, ``plan``, ``apply``, ``output``, ``destroy`` and others) to Terraform, based on the settings in your ``terragrunt.hcl`` file. To run all units of a directory, use ``terragrunt run --all <command>`` (the old ``run-all`` command is deprecated). More info: https://docs.terragrunt.com/migrate/cli-redesign/

```diff
- ATTENTION!!!
- Bug possible: https://github.com/hashicorp/terraform-provider-aws/issues/14917
+ Fix: ``export AWS_DEFAULT_REGION=region_name``.
```

# Structure of directories

```bash
├── live # Directory with Terragrunt code
│   ├── .terraform-version # Terraform version used by this code
│   ├── .terragrunt-version # Terragrunt version used by this code
│   ├── default.hcl
│   ├── empty.yaml
│   └── testing # Directory with environment code
│       ├── environment.hcl # Environment configurations for Terragrunt code
│       ├── root.hcl # General Terragrunt code to manage the Terraform state in S3 (with lock file in S3)
│       └── regions # Directory with regions code
│           └── us-east-2 # Directory with specific region code
│               ├── region.hcl # Region configurations for Terragrunt code
│               └── mycustomer # Directory with specific resources code of customer
│                   ├── customer.hcl # Customer configurations for Terragrunt code
│                   ├── asg
│                   │   ├── cdk17o7adl-apps
│                   │   │   └── terragrunt.hcl # Terragrunt for create Autoscaling Group
│                   │   └── asg.hcl # Terragrunt template for Autoscaling Group
│                   ├── certificates
│                   │   ├── wildcard-mydomain-com
│                   │   │   └── terragrunt.hcl # Terragrunt for create certificate
│                   │   └── certificate.hcl # Terragrunt template for ACM certificate
│                   ├── dns
│                   │   ├── kube-pires-mydomain-com
│                   │   │   └── terragrunt.hcl # Terragrunt for create DNS record to loadbalancer
│                   │   ├── mydomain.com
│                   │   │   └── terragrunt.hcl # Terragrunt for create Route53 domain (hosted zone)
│                   │   ├── validation-wildcard-mydomain-com
│                   │   │   └── terragrunt.hcl # Terragrunt for create DNS record to validate certificate
│                   │   ├── dns-domain.hcl # Terragrunt template for Route53 domain (hosted zone)
│                   │   └── dns-record.hcl # Terragrunt template for Route53 DNS record
│                   ├── ec2
│                   │   ├── cdk17o7adl-apps
│                   │   │   └── terragrunt.hcl # Terragrunt for create EC2 instance
│                   │   └── ec2.hcl # Terragrunt template for EC2 instance
│                   ├── eks
│                   │   ├── cluster1-gyr4
│                   │   │   └── terragrunt.hcl # Terragrunt for create EKS cluster
│                   │   ├── cluster1-gyr4-blueprints-addons
│                   │   │   └── terragrunt.hcl # Terragrunt for install EKS blueprint addons
│                   │   ├── eks-1-36.hcl # Terragrunt template for EKS 1.36
│                   │   └── eks-1-36-blueprints-addons.hcl # Terragrunt template for EKS blueprints addons
│                   ├── keypair
│                   │   ├── key-gyr4
│                   │   │   └── terragrunt.hcl # Terragrunt for create Key pair
│                   │   └── keypair.hcl # Terragrunt template for Keypair
│                   ├── kms
│                   │   ├── kms-gyr4
│                   │   │   └── terragrunt.hcl # Terragrunt for create KMS
│                   │   └── kms.hcl # Terragrunt template for KMS
│                   ├── loadbalancer
│                   │   ├── cdk17o7adl-apps
│                   │   │   └── terragrunt.hcl # Terragrunt for create Application Load Balancer
│                   │   └── alb.hcl # Terragrunt template for Application Load Balancer
│                   ├── ses
│                   │   ├── noreply
│                   │   │   └── terragrunt.hcl # Terragrunt for create SES to send email
│                   │   └── ses-send-email.hcl # Terragrunt template for SES
│                   └── vpc
│                       ├── net-gyr4
│                       │   └── terragrunt.hcl # Terragrunt for create VPC
│                       └── vpc.hcl # Terragrunt template for VPC
└── README.md # This documentation
```

# Clearing the Terragrunt cache

Terragrunt creates a ``.terragrunt-cache`` folder in the current working directory as its scratch directory. It downloads your remote Terraform configurations into this folder, runs your Terraform commands in this folder, and any modules and providers those commands download also get stored in this folder. You can safely delete this folder any time and Terragrunt will recreate it as necessary.

If you need to clean up a lot of these folders (e.g., after ``terragrunt apply``), you can use the following commands on Mac and Linux:

Recursively find all the ``.terragrunt-cache`` folders that are children of the current folder:

```bash
find . -type d -name ".terragrunt-cache" | xargs rm -rf
```

Reference: https://docs.terragrunt.com/features/caching/

# How to Install

- Create common environment variables:

```bash
SUFFIX='gyr4'
AWS_REGION='us-east-2'
PREFIX_CLUSTER_NAME='cluster1'
CUSTOMER_ID='cdk17o7adl'
CLUSTER_NAME="${CUSTOMER_ID}-cluster1-${SUFFIX}"
```

## Stage 0: Change the configurations

- Change values in files ``environment.hcl``, ``region.hcl`` and ``customer.hcl`` files.

```bash
cd "$HOME/git/adsoft/aws_services/"

find . -type f | grep "environment.hcl\|region.hcl\|customer.hcl" | grep -v terragrunt-cache
```

## Stage 1: Create VPC

- For create VPC for specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/vpc/net-${SUFFIX}"
```

Run the ``terragrunt`` commands.

> In the first execution, run ``terragrunt init --backend-bootstrap`` to create the S3 bucket used to store the Terraform state. Since Terragrunt 1.0 the bucket is created only when the flag ``--backend-bootstrap`` is used (or with the command ``terragrunt backend bootstrap``). More info: https://docs.terragrunt.com/features/units/state-backend/

```bash
terragrunt init --backend-bootstrap # only in the first execution
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 2: Create key pair RSA

- For create key pair RSA for specific customer:

Example:

```bash
ssh-keygen -t rsa -b 4096 -v -f ~/key-$SUFFIX.pem
```

- Copy content public key without USER and HOST.

```bash
cat ~/key-$SUFFIX.pem.pub | cut -d " " -f1,2
```

- Example:

```config
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaj/Af6UpsosJoP7Z3AEW6qf+9qQsIpYhbWR9ZXfo0M5/HorpCe/OqqyMwjLwfZb6TCDKDjH/9MK5Y3VxoL/SF/ECjk3SJM5NQO/NWZojZUYM8nTkkc0sqsF7MNJgN4I0SFeigJwWpYE2h0NAJTadMIt9jY9OAEcH1FIcpcBgE9SuL4SvZm7CDbBlSloMoGqBS+BB/9sHc7UCANFR0FrAFdwMKGYUmlOmMJlklbryoSuht8A5fWGo+iPtkksVgJ07fIlnkDiFhJIiaM4ScEd5g8OwjrmZjfx4+pyQlEAXKiYwR5T/05gHomMCNdUZfLjIAzLRlcaRTxQ6CVhRUlB4KYcoYdpc8sbw8stVh6p0uRUZ9O+cKoEcyQv8gq0pUoq+er3+inHIlcUY+nLNPGFRlRcWzZ0Dd96QeJclEByln7vRVZDokKyn1y41P/jV2FtXdt/z/MbCYxhqtWxXQtDpIuauW6aPU9CDyjPgif3KjluxILYH7lyw8uKJuJM3pV0S15ZVdu6a3GeVrGRYMx4Gq6QyFcc9Rtl3E1QhFFxXWFvpMkIfeiax5HfQHE+XHWKN38LXR+8ZjQbMZSD/8/WJP2K9YVLIsRfLclwwkccYGEvMfiQuDIx7YjLZ+lF8WBGNUswbibDhiDK9aQLZ0n4bvGRrPtWgbE5oJm8AjeQi2w==
```

- Change the values according to the need of the customer in ``$HOME/git/adsoft/aws_services/live/testing/regions/us-east-2/mycustomer/customer.hcl``.

- Run the follow command:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/keypair/key-${SUFFIX}/"
```

Run the ``terragrunt`` commands.

## Stage 3: Create KMS

- For create KMS for specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/kms/kms-${SUFFIX}/"
```

Run the ``terragrunt`` commands.

## Stage 4: Create Kubernetes cluster

- For create EKS in specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/eks/${PREFIX_CLUSTER_NAME}-${SUFFIX}/"
```

Run the ``terragrunt`` commands.

Authenticate in cluster with follow command.

```bash
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION" --profile myaccount
```

## Stage 5: Install EKS Blueprints addons

- Change the VPC_ID in ``$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/eks/${PREFIX_CLUSTER_NAME}-${SUFFIX}-blueprints-addons/terragrunt.hcl`` file and run the follow commands:

```bash
export KUBE_CONFIG_PATH=~/.kube/config

cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/eks/${PREFIX_CLUSTER_NAME}-${SUFFIX}-blueprints-addons/"
```

Run the ``terragrunt`` commands.

## Optionals: Route53 domain and records, ACM certificate, SES to send email, Autoscaling Group and loadbalancer (with target to EC2 instance)

- For create Route53 domain:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/dns/mydomain.com/"
```

Run the ``terragrunt`` commands.

- For create ACM certificate:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/certificates/wildcard-mydomain-com/"
```

Run the ``terragrunt`` commands.

- For create DNS record to validate ACM certificate:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/dns/validation-wildcard-mydomain-com/"
```

Run the ``terragrunt`` commands.

- For create SES noreply email:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/ses/noreply/"
```

Run the ``terragrunt`` commands.

Run ``terragrunt show -json`` command to see sensitive informations.

- For create Autoscaling group (ASG):

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/asg/${CUSTOMER_ID}-apps/"
```

Run the ``terragrunt`` commands.

- For create loadbalancer with target to Autoscaling group (ASG):

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/loadbalancer/${CUSTOMER_ID}-apps/"
```

Run the ``terragrunt`` commands.

- For create DNS to loadbalancer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/dns/kube-pires-mydomain-com/"
```

Run the ``terragrunt`` commands.

# Upgrading existing infrastructure

The Terraform modules used by this code were updated to new major versions (for example: ``terraform-aws-modules/eks`` v21, ``terraform-aws-modules/vpc`` v6, ``terraform-aws-modules/route53`` v6, ``terraform-aws-modules/alb`` v10 and ``terraform-aws-modules/ec2-instance`` v6), which require AWS provider v6. If you already have infrastructure created by an older version of this code:

- Read the upgrade guide of each module before running ``terragrunt apply``. The guides are in the ``docs`` directory of each module repository, for example: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/UPGRADE-21.0.md
- Since v6.0.0 of the ``route53`` module, the zone and the records are managed by the root module (the ``zones`` and ``records`` submodules were removed). The resource addresses changed, so move the state (``terraform state mv``) or import the existing records before applying, to avoid recreating them.
- Run ``terragrunt plan`` and review all the changes before running ``terragrunt apply``.
- The S3 backend now uses a lock file in the bucket (``use_lockfile = true``) instead of the DynamoDB table.

# How to Uninstall

- Create common environment variables:

```bash
SUFFIX='gyr4'
AWS_REGION='us-east-2'
PREFIX_CLUSTER_NAME='cluster1'
CUSTOMER_ID='cdk17o7adl'
CLUSTER_NAME="${CUSTOMER_ID}-cluster1-${SUFFIX}"
```

## Remove Kubernetes cluster

- First, remove the EKS Blueprints addons for specific customer:

```bash
export KUBE_CONFIG_PATH=~/.kube/config

cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/eks/${PREFIX_CLUSTER_NAME}-${SUFFIX}-blueprints-addons/"
```

Run the command:

```bash
terragrunt destroy
```

- For remove EKS for specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/eks/${PREFIX_CLUSTER_NAME}-${SUFFIX}/"
```

Run the command:

```bash
terragrunt destroy
```

## Remove KMS

- For remove KMS for specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/kms/kms-$SUFFIX/"
```

Run the command:

```bash
terragrunt destroy
```

## Remove key pair RSA

- For remove key pair RSA for specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/keypair/key-$SUFFIX/"
```

- Run the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Remove subnets, NAT Gateway and VPC

- For remove network resources for specific customer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/vpc/net-$SUFFIX/"
```

- Run the command:

```bash
terragrunt destroy
```

## Remove optionals if created

- For remove DNS record to validate ACM certificate:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/dns/validation-wildcard-mydomain-com/"
```

- Run the command:

```bash
terragrunt destroy
```

- For remove ACM certificate:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/certificates/wildcard-mydomain-com/"
```

- Run the command:

```bash
terragrunt destroy
```

- For remove SES noreply email:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/ses/noreply/"
```

- Run the command:

```bash
terragrunt destroy
```

- For remove Route53 domain:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/dns/mydomain.com/"
```

- Run the command:

```bash
terragrunt destroy
```

- For remove DNS to loadbalancer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/dns/kube-pires-mydomain-com/"
```

- Run the command:

```bash
terragrunt destroy
```

- For remove loadbalancer:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/loadbalancer/${CUSTOMER_ID}-apps/"
```

- Run the command:

```bash
terragrunt destroy
```

- For remove Autoscaling group:

```bash
cd "$HOME/git/adsoft/aws_services/live/testing/regions/${AWS_REGION}/mycustomer/asg/${CUSTOMER_ID}-apps/"
```

- Run the command:

```bash
terragrunt destroy
```

## Remove AWS S3 Bucket

- Run the command:

```bash
AWS_ACCOUNT_ID='CHANGE_HERE'

aws s3 rb "s3://terragrunt-remote-state-${AWS_ACCOUNT_ID}" \
  --force \
  --region "$AWS_REGION" \
  --profile myaccount

# or

aws s3api delete-bucket \
  --bucket "terragrunt-remote-state-${AWS_ACCOUNT_ID}" \
  --region "$AWS_REGION" \
  --profile myaccount
```

References:

- https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html
- https://docs.aws.amazon.com/cli/latest/reference/s3api/delete-bucket.html

## Remove DynamoDB Table

The current code uses a lock file in the S3 bucket (``use_lockfile = true``) to lock the Terraform state. Only if the DynamoDB table was created by an older version of this code, remove it with the command:

```bash
aws dynamodb delete-table \
  --table-name "terragrunt-state-lock-dynamo-${AWS_ACCOUNT_ID}" \
  --region "$AWS_REGION" \
  --profile myaccount
```

References:

- https://docs.aws.amazon.com/cli/latest/reference/dynamodb/delete-table.html
