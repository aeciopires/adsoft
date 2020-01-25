# English

# Prerequisites

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

* Clone this repository.

```
git clone https://github.com/aeciopires/adsoft

cd adsoft/aws_services
```

1. This directory contains the files:<br>
  * ``terraform_prod.tfvars``  => where you can define the values of the variables for environment *production* used by ``main.tf``. See [Inputs](#inputs)
  * ``variables.tf``      => The default values of the variables
used by ``main.tf``, if you not define values in to ``terraform_prod.tfvars`` file. See [Inputs](#inputs)
2. The goal is to install Docker Registry, Prometheus, Zabbix, Grafana and Apps.

# How to

* Download Terraform for Linux: https://www.terraform.io/downloads.html
* Unpack the Terraform package.
* Access the unpacked directory.
* Copy the Terraform binary to the ``/usr/bin`` directory with the following commands:

```bash
sudo cp terraform /usr/bin
sudo chmod 755 /usr/bin/terraform
```
* Change the values according to the need of the environment in the ``terraform_prod.tfvars`` file.

* Validate the settings and create the environment with the following commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform show
```

## About Terraform commands

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


# Documentation of Code Terraform (Only Developers)

Generate by https://github.com/segmentio/terraform-docs

* Install Go.

```bash
VERSION=1.13.5
mkdir -p $HOME/go

curl https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz -o go.tar.gz

sudo tar -C /usr/local -xzf go.tar.gz

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go/bin

go version
```

* Install terraform-docs.

```bash
cd $HOME/go

GO111MODULE="off" go get github.com/segmentio/terraform-docs

cd bin
sudo mv terraform-docs /usr/bin/terraform-docs
```

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
| apps\_instance\_id | n/a |
| apps\_instance\_name | n/a |
| apps\_ip\_private | n/a |
| apps\_ip\_public | n/a |
| loki\_instance\_id | n/a |
| loki\_instance\_name | n/a |
| loki\_ip\_private | n/a |
| loki\_ip\_public | n/a |
| monitoring\_instance\_id | n/a |
| monitoring\_instance\_name | n/a |
| monitoring\_ip\_private | n/a |
| monitoring\_ip\_public | n/a |
| registry\_instance\_id | n/a |
| registry\_instance\_name | n/a |
| registry\_ip\_private | n/a |
| registry\_ip\_public | n/a |
| security\_group | n/a |
