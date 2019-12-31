# English

NOTE: Developed using Terraform 0.12.x syntax.

* You will need to create an Amazon AWS account. Create a 'Free Tier' account at Amazon https://aws.amazon.com/ follow the instructions on the pages: https://docs.aws.amazon.com/chime/latest/ag/aws-account.html and https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html. When creating the account you will need to register a credit card, but since you will create instances using the features offered by the 'Free Tier' plan, nothing will be charged if you do not exceed the limit for the use of the features and time offered and described in the previous link .
* After creating the account in AWS, access the Amazon CLI interface at: https://aws.amazon.com/cli/
* Click on the username (upper right corner) and choose the "Security Credentials" option. Then click on the "Access Key and Secret Access Key" option and click the "New Access Key" button to create and view the ID and Secret of the key, as shown below (https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html). The Access Key and Secret Key shown below are for illustration only. They are invalid and you need to exchange for the actual data generated for your account.

```bash
Access Key ID: AKIAI3IZDFASDFASDFAS2OSCH7MDV3SQ
Secret Access Key: y+7sVdfsdfsZMfOSsdfasdfasfdfasdfasSHT
```

* Create the directory below.

```bash
mkdir -p /home/USERNAME/.aws/
touch /home/USERNAME/.aws/credentials
```

* Access ``/home/USERNAME/.aws/credentials`` file and add the following content. The Access Key and Secret Key shown below are for illustration only. They are invalid and you need to exchange for the actual data generated for your account.

```bash
[default]
aws_access_key_id = AKIAI3IZDFASDFASDFAS2OSCH7MDV3SQ
aws_secret_access_key = y+7sVdfsdfsZMfOSsdfasdfasfdfasdfasSHT
```

1. This directory contains the files:<br>
  * ``template.tf``  => that defines the general settings.
  * ``variables.tf`` => where you can define the values of the variables
used by ``main.tf``.<br>
2. The ``modules/application`` subdirectory has the following files:<br>
3. The goal is to install Docker Registry, Prometheus, Zabbix, Grafana and App.

Useful commands:

* terraform --help    => Show help of command terraform<br>
* terraform providers => Prints a tree of the providers used in the configuration<br>
* terraform init      => Initialize a Terraform working directory<br>
* terraform validate  => Validates the Terraform files<br>
* terraform plan      => Generate and show an execution plan<br>
* terraform apply     => Builds or changes infrastructure<br>
* terraform show      => Inspect Terraform state or plan<br>
* terraform destroy   => Destroy Terraform-managed infrastructure<br>
* terraform output -module=instances => Show results of module define on ``modules/application/output.tf`` file .

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

## How to

* Download Terraform for Linux: https://www.terraform.io/downloads.html
* Unpack the Terraform package.
* Access the unpacked directory.
* Copy the Terraform binary to the ``/usr/bin`` directory with the following commands:

```bash
sudo cp terraform /usr/bin
sudo chmod 755 /usr/bin/terraform
```
* Change the values according to the need of the environment in the ``modules/application/variables.tf`` file.

* Validate the settings and create the environment with the following commands

```bash
terraform validate
terraform apply -auto-approve
terraform show
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