#### Menu

<!-- TOC -->

- [About](#about)
- [Requirements](#requirements)
- [Clearing the Terragrunt cache](#clearing-the-terragrunt-cache)
- [How to Install](#how-to-install)
  - [Stage 0: Create bucket, table and policies](#stage-0-create-bucket-table-and-policies)
  - [Stage 1: Create AWS CloudTrail and S3 bucket](#stage-1-create-aws-cloudtrail-and-s3-bucket)
  - [Stage 2: Create key pair RSA for each environment](#stage-2-create-key-pair-rsa-for-each-environment)
  - [Stage 3: Define parameters of VPC configuration](#stage-3-define-parameters-of-vpc-configuration)
  - [Stage 4: Create Kubernetes cluster](#stage-4-create-kubernetes-cluster)
  - [Stage 5: Install manifests in EKS cluster](#stage-5-install-manifests-in-eks-cluster)
- [How to Uninstall](#how-to-uninstall)
  - [Remove Kubernetes cluster](#remove-kubernetes-cluster)
  - [Remove subnets, NAT Gatewat and VPC](#remove-subnets-nat-gatewat-and-vpc)
  - [Remove key pair RSA](#remove-key-pair-rsa)
  - [Remove AWS CloudTrail and S3 bucket](#remove-aws-cloudtrail-and-s3-bucket)
  - [Remove IAM policies](#remove-iam-policies)
  - [Remove AWS S3 Bucket](#remove-aws-s3-bucket)
  - [Remove DynamoDB Table](#remove-dynamodb-table)

<!-- TOC -->

# About

Create EKS Kubernetes cluster 1.21 using Terragrunt and Terraform code.

# Requirements

* Configure the AWS Credentials and install ``git``, ``tgenv``, ``tfenv``, ``aws-cli``, ``kubectl`` and ``helm``  following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.

Access https://terragrunt.gruntwork.io/docs/#getting-started for more informations about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt will forward almost all commands, arguments, and options directly to Terraform, but based on the settings in your ``terragrunt.hcl`` file.

```diff
- ATTENTION!!!
- Bug possible: https://github.com/hashicorp/terraform-provider-aws/issues/14917
+ Fix: ``export AWS_DEFAULT_REGION=region_name``.
```

# Clearing the Terragrunt cache

Terragrunt creates a ``.terragrunt-cache`` folder in the current working directory as its scratch directory. It downloads your remote Terraform configurations into this folder, runs your Terraform commands in this folder, and any modules and providers those commands download also get stored in this folder. You can safely delete this folder any time and Terragrunt will recreate it as necessary.

If you need to clean up a lot of these folders (e.g., after ``terragrunt apply``), you can use the following commands on Mac and Linux:

Recursively find all the ``.terragrunt-cache`` folders that are children of the current folder:

```bash
find . -type d -name ".terragrunt-cache"
```

If you are ABSOLUTELY SURE you want to delete all the folders that come up in the previous command, you can recursively delete all of them as follows:

```bash
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
```

Reference: https://terragrunt.gruntwork.io/docs/features/caching/

# How to Install

* Clone repository.

```bash
mkdir ~/git

cd ~/git

git clone https://github.com/aeciopires/adsoft.git
```

> **WARNING:** Before start to contribute, run the command: `git pull origin master` to fetch the newest content of the main branch and avoid conflicts that can make you waste time.

* Access the directory root of eks.

```bash
cd ~/git/adsoft/eks
```

* Create a branch. Example:

```bash
git checkout -b BRANCH_NAME
```

* Change values in files ``*.hcl`` and ``*.yaml`` files. Locate all files ``*.hcl`` and ``*.yaml`` for change.

```bash
cd ~/git/adsoft/eks/

find . -type f | grep .hcl | grep -v terragrunt-cache

find . -type f | grep .yaml | grep -v terragrunt-cache
```

* In each directory validate the settings and analysis the changes before apply in testing.

## Stage 0: Create bucket, table and policies

* For create s3 to store tfstate remote on AWS:

```diff
- ATTENTION!!!
- The bucket name is global and unique. This means that even if you don't have a bucket with a certain name, it may conflict with another bucket created under another AWS customer's account. 
+ If this is the case, you need to change the bucket name ``my-terraform-remote-state-02`` in the following commands and also in the ``*.hcl`` files.
```

```bash
aws s3api create-bucket \
  --bucket my-terraform-remote-state-02 \
  --create-bucket-configuration LocationConstraint=us-east-2 \
  --region us-east-2 \
  --profile default
```

Reference: https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html

* For create DynamoDB table for lock of resources managed by Terraform/Terragrunt:

```bash
aws dynamodb create-table \
  --table-name my-terraform-state-lock-dynamo \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-2 \
  --profile default
```

* Change the bucket name and DynamoDB table in ``~/git/adsoft/eks/testing/environment.hcl``.

* For create policy of autoscaler on AWS account (testing):

```bash
cd ~/git/adsoft/eks/testing/global/policies/autoscaler/
```

* Change the values according to the need in ``terragrunt.hcl``.

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

* For create policy of loadbalancer on AWS account (testing):

```bash
cd ~/git/adsoft/eks/testing/global/policies/loadbalancer/
```

* Change the values according to the need in ``terragrunt.hcl``.

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 1: Create AWS CloudTrail and S3 bucket

* For create S3 to store logs on AWS account (testing):

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/audit/s3
```

* Change the values according to the need in ``terragrunt.hcl``.

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

* For create CloudTrail on AWS account (testing)

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/audit/cloudtrail
```

* Change the values according to the need in ``terragrunt.hcl``.

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 2: Create key pair RSA for each environment

* For create key pair RSA for especific environment:

Example:

```bash
NAME_REGION=us-east-2

ssh-keygen -t rsa -b 4096 -v -f ~/key-$NAME_REGION.pem
```

* Copy content public key without USER and HOST.

```bash
cat ~/key-$NAME_REGION.pem.pub | cut -d " " -f1,2
```

* Example:

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6UOQ5zd6yRWsJESIpRPBUGK7yWcNdXSZl+NGbOy4xndkSOBYWWVr0IJk3nEddqsIxfTazh8p9gwVu0O1WUTsxOxTx6vk8EQbArA/o8m+Hiue2pPJlJDl+cY2t7twfwzoh6aZ0MstYvMRrjvTKHcur4bXqD/UqaTn1UeNJ2WytY8+JSvtx3YoS97UHFiGmHnEfZzsShVSkqJv0wgm1eqZnajFVcqXIKOSyxk0CN4kfCTOd29b5Y8CoO1o4IAqISoz2eecViTw5gy0IlhEtmoa03084WSyOzGG/D0QZ0lfA3mXgAAmG5uv/5sN0E7pzs4R1ZgMFYHorN8Cdp+3eJiPX
```

* Change the values according to the need of the region in ``~/git/adsoft/eks/testing/region/us-east-2/region.hcl``.

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/keypair
```

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 3: Define parameters of VPC configuration

* Change values in files ``environment.hcl`` and ``*.yaml`` files. Locate all files ``*.hcl`` and ``*.yaml`` for change.

```bash
cd ~/git/adsoft/eks/

find . -type f | grep .hcl | grep -v terragrunt-cache

find . -type f | grep .yaml | grep -v terragrunt-cache
```

* In each directory validate the settings and analysis the changes before apply.

* For create VPC for especific in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/vpc
```

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 4: Create Kubernetes cluster

* For create EKS in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/cluster1
```

Run the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

```diff
- ATTENTION!!!
- Problems with aws-auth configmap or kubeconfig?
+ Solutions:
```

```bash
terragrunt state list
terragrunt state rm kubernetes_config_map.aws_auth[0]
terragrunt state rm local_file.kubeconfig[0]
terragrunt import kubernetes_config_map.aws_auth[0] kube-system/aws-auth
terragrunt apply -auto-approve
```

References:

* https://github.com/terraform-aws-modules/terraform-aws-eks/issues/699
* https://github.com/terraform-aws-modules/terraform-aws-eks/issues/852
* https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911
* https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1280
* https://medium.com/@ssorcnafets/terraform-k8s-provider-auth-issue-eb98814e673c
* https://github.com/aws/containers-roadmap/issues/654
* https://github.com/terraform-aws-modules/terraform-aws-eks
* https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/launch_templates/main.tf
* https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/complete/main.tf
* https://github.com/particuleio/teks/blob/main/terragrunt/live/production/eu-west-1/clusters/demo/eks/terragrunt.hcl

## Stage 5: Install manifests in EKS cluster

* Authenticate to the EKS cluster with the follow command.

```bash
aws eks update-kubeconfig --name mycluster-eks-testing --region us-east-2 --profile default
```

* Create namespace ``manifests-eks`` in Kubernetes cluster.

```bash
kubectl create namespace manifests-eks
```

* In Kubernetes 1.21, install CRD (Custom Resource Definitions) of cert-manager with command.

```bash
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.crds.yaml
```

* Install manifests default in EKS cluster with follow commands:

```bash

```

# How to Uninstall

## Remove Kubernetes cluster

* For remove EKS for especific in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/cluster1
```

Authenticate in cluster of customer with follow command.

```bash
aws eks update-kubeconfig --name mycluster-eks-testing --region us-east-2 --profile default
```

Run the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Remove subnets, NAT Gatewat and VPC

* For remove network resources for especific in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/vpc
```

Run the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Remove key pair RSA

* For remove key par RSA in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/keypair
```

Run the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Remove AWS CloudTrail and S3 bucket

* For remove CloudTrail:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/audit/cloudtrail
```

Run the ``terragrunt`` command.

```bash
terragrunt destroy
```

* For remove S3 bucket

Remove all versions of objects in bucket with the script:

Reference: 
* https://docs.aws.amazon.com/AmazonS3/latest/userguide/DeletingObjectVersions.html
* https://gist.github.com/weavenet/f40b09847ac17dd99d16#gistcomment-3666051

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/audit/s3
chmod +x remove_all_version_objects.sh
./remove_all_version_objects.sh mys3-testing-audit
```

Run the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Remove IAM policies

Run the follow commands:

```bash
cd ~/git/adsoft/eks/testing/global/policies/autoscaler/

terragrunt destroy

cd ~/git/adsoft/eks/testing/global/policies/loadbalancer/

terragrunt destroy
```

## Remove AWS S3 Bucket

Run the command:

```bash
aws s3 rb s3://my-terraform-remote-state-02 \
  --force \
  --region us-east-2 \
  --profile default

# or

aws s3api delete-bucket \
  --bucket my-terraform-remote-state-02 \
  --region us-east-2 \
  --profile default
```

References:

* https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html
* https://docs.aws.amazon.com/cli/latest/reference/s3api/delete-bucket.html

## Remove DynamoDB Table

Run the command:

```bash
aws dynamodb delete-table \
  --table-name my-terraform-state-lock-dynamo \
  --region us-east-2 \
  --profile default
```

References:

* https://docs.aws.amazon.com/cli/latest/reference/dynamodb/delete-table.html
