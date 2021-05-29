#### Menu

<!-- TOC -->

- [About](#about)
- [Requirements](#requirements)
- [Clearing the Terragrunt cache](#clearing-the-terragrunt-cache)
- [How to Install](#how-to-install)
  - [Stage 1: Create AWS CloudTrail and S3 bucket](#stage-1-create-aws-cloudtrail-and-s3-bucket)
  - [Stage 2: Create key pair RSA for each environment](#stage-2-create-key-pair-rsa-for-each-environment)
  - [Stage 3: Define parameters of VPC configuration](#stage-3-define-parameters-of-vpc-configuration)
  - [Stage 4: Create Kubernetes cluster](#stage-4-create-kubernetes-cluster)
  - [Stage 5: Install manifests in EKS cluster](#stage-5-install-manifests-in-eks-cluster)
- [How to Uninstall](#how-to-uninstall)
  - [Stage 1: Remove Kubernetes cluster](#stage-1-remove-kubernetes-cluster)
  - [Stage 2: Remove subnets, NAT Gatewat and VPC](#stage-2-remove-subnets-nat-gatewat-and-vpc)
  - [Stage 3: Remove key pair RSA](#stage-3-remove-key-pair-rsa)
  - [Stage 4: Remove AWS CloudTrail and S3 bucket](#stage-4-remove-aws-cloudtrail-and-s3-bucket)

<!-- TOC -->

# About

Create EKS cluster using Terragrunt and Terraform code.

# Requirements

* Configure the AWS Credentials and install ``git``, ``tgenv``, ``tfenv``, ``aws-cli``, ``kubectl`` and ``helm``  following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

Access https://terragrunt.gruntwork.io/docs/#getting-started for more informations about Terragrunt commands.

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

Terragrunt will forward almost all commands, arguments, and options directly to Terraform, but based on the settings in your ``terragrunt.hcl`` file.

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
~/git/adsoft/eks/
find . -type f | grep .hcl | grep -v terragrunt-cache
find . -type f | grep .yaml | grep -v terragrunt-cache
```

* In each directory validate the settings and analysis the changes before apply in testing.

## Stage 1: Create AWS CloudTrail and S3 bucket

* For create S3 to store logs on AWS account (testing)

```bash
cd ~/git/adsoft/eks/global/bucket
```

* Change the values according to the need in ``terragrunt.hcl``.

Execute the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

* For create CloudTrail on AWS account (testing)

```bash
cd ~/git/adsoft/eks/global/cloudtrail
```

* Change the values according to the need in ``terragrunt.hcl``.

Execute the ``terragrunt`` commands.

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
ssh-keygen -t rsa -b 2048 -v -f ~/key-NAME-REGION.pem
```

* Copy content public key without USER and HOST.

```bash
cat ~/key-NAME-REGION.pem | cut -d " " -f1,2
```

* Example:

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGNdBRiGajewqwSvEVuv/rRKLQxUWmNqUGnq2Ik8c+BSvP070+Q8i0bC6oKKj4FJ87FcF9GiDI/i8Th6koH39PHVJbNR2qSgOTqk33WulzSdRU1ucUEEplvaBVT5YKjtomC4YY9YGRWPBZlQ1pwKfxGQuL7tbfuVRDu6KbAj1aIoCivivTWvREkQKZgwe4ReeFVR3hBHzWRQtkEA79lsSbPBtQ5k1NTb3+E+7Oknkl6gY5rMuJqWNz9MosD8ITmEzEsOQRX5tmsmGzNmFgaIB7bG0H7iXk16rav4tAOu5v9SQOZHhZTjFcMsFXGYhSVYBph23FCXdiLziNXiiyAZ0N
```

* Change the values according to the need of the region in ``region.hcl``.

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/keypair
```

Execute the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 3: Define parameters of VPC configuration

* Change values in files ``environment.hcl`` and ``*.yaml`` files. Locate all files ``*.hcl`` and ``*.yaml`` for change.

```bash
~/git/adsoft/eks/
find . -type f | grep .hcl | grep -v terragrunt-cache
find . -type f | grep .yaml | grep -v terragrunt-cache
```

* In each directory validate the settings and analysis the changes before apply.

* For create VPC for especific in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/vpc
```

Execute the ``terragrunt`` commands.

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

Execute the ``terragrunt`` commands.

```bash
terragrunt validate
terragrunt plan
terragrunt apply
terragrunt output
```

## Stage 5: Install manifests in EKS cluster

* Authenticate to the EKS cluster with the follow command.

```bash
aws eks --region REGION_NAME update-kubeconfig --name CLUSTER_EKS_NAME --profile AWS_PROFILE
```

* Create namespace ``manifests-eks`` in Kubernetes cluster.

```bash
kubectl create namespace manifests-eks
```

* In Kubernetes 1.19, install CRD (Custom Resource Definitions) of cert-manager with command.

```bash
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.crds.yaml
```

* Install manifests default in EKS cluster with follow commands:

```bash

```

# How to Uninstall

## Stage 1: Remove Kubernetes cluster

* For remove EKS for especific in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/cluster1
```

Authenticate in cluster of customer with follow command.

```bash
aws eks --region REGION_NAME update-kubeconfig --name CLUSTER_EKS_NAME --profile AWS_PROFILE
```

Execute the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Stage 2: Remove subnets, NAT Gatewat and VPC

* For remove network resources for especific in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/vpc
```

Execute the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Stage 3: Remove key pair RSA

* For remove key par RSA in especific region of testing environment:

```bash
cd ~/git/adsoft/eks/testing/region/us-east-2/keypair
```

Execute the ``terragrunt`` command.

```bash
terragrunt destroy
```

## Stage 4: Remove AWS CloudTrail and S3 bucket

* For remove CloudTrail:

```bash
cd ~/git/adsoft/eks/global/cloudtrail
```

Execute the ``terragrunt`` command.

```bash
terragrunt destroy
```

* For create S3 bucket

```bash
cd ~/git/adsoft/eks/global/bucket
```

Execute the ``terragrunt`` command.

```bash
terragrunt destroy
```