<!-- TOC -->

- [Requirements](#requirements)
  - [General Packages](#general-packages)
- [Docker](#docker)
- [Docker Compose](#docker-compose)
- [GCloud](#gcloud)
- [Configure AWS Credentials](#configure-aws-credentials)
- [AWS IAM Authenticator](#aws-iam-authenticator)
- [Terraform 0.12](#terraform-012)
- [Terragrunt](#terragrunt)
- [Go](#go)
  - [Terraform-Docs](#terraform-docs)
- [Kubectl](#kubectl)
- [Helm 3](#helm-3)

<!-- TOC -->

# Requirements

## General Packages

Install the follow packages.

Debian/Ubuntu:

```bash
sudo apt-get install -y vim traceroute telnet git tcpdump curl wget openssl netcat net-tools awscli
```

CentOS:

```bash
sudo yum install -y vim traceroute telnet git tcpdump curl wget openssl netcat net-tools awscli
```

# Docker

Install Docker CE (Community Edition) following the instructions of pages.

CentOS: https://docs.docker.com/install/linux/docker-ce/centos/

Debian: https://docs.docker.com/install/linux/docker-ce/debian/

Ubuntu Server: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Save the Docker service, configure the Docker to boot at the operating system and add the user to the Docker group.

```bash
sudo systemctl start docker

sudo systemctl enable docker

sudo usermod -aG docker $USER

sudo setfacl -m user:$USER:rw /var/run/docker.sock

docker version
```

For more information about Docker Compose visit:

* https://docs.docker.com
* http://blog.aeciopires.com/primeiros-passos-com-docker

# Docker Compose

Instructions for downloading and starting Docker Compose

```sh
sudo su

COMPOSE_VERSION=1.25.5

sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

/usr/local/bin/docker-compose version

exit
```

For more information about Docker Compose visit:

* https://docs.docker.com/compose/reference
* https://docs.docker.com/compose/compose-file
* https://docs.docker.com/engine/reference/builder

# GCloud

You will need to create an Google Cloud Platform account: https://console.cloud.google.com

Install and configure the ``gcloud`` following the instructions on tutorials.

* https://cloud.google.com/docs/authentication/getting-started
* https://console.cloud.google.com/apis/credentials/serviceaccountkey
* https://cloud.google.com/sdk/install
* https://cloud.google.com/sdk/docs/downloads-apt-get
* https://cloud.google.com/sdk/gcloud/reference/config/set
* https://code-maven.com/gcloud
* https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97
* https://blog.realkinetic.com/using-google-cloud-service-accounts-on-gke-e0ca4b81b9a2
* https://www.the-swamp.info/blog/configuring-gcloud-multiple-projects/

# Configure AWS Credentials

You will need to create an Amazon AWS account. Create a **Free Tier** account at Amazon https://aws.amazon.com/ follow the instructions on the pages: https://docs.aws.amazon.com/chime/latest/ag/aws-account.html and https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html. When creating the account you will need to register a credit card, but since you will create instances using the features offered by the **Free Tier** plan, nothing will be charged if you do not exceed the limit for the use of the features and time offered and described in the previous link .

After creating the account in AWS, access the Amazon CLI interface at: https://aws.amazon.com/cli/

Click on the username (upper right corner) and choose the **Security Credentials** option. Then click on the **Access Key and Secret Access Key** option and click the **New Access Key** button to create and view the ID and Secret of the key, as shown below (https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html). 

* Create the directory below.

```bash
mkdir -p /home/$USER/.aws/
touch /home/$USER/.aws/credentials
```

* Access ``/home/$USER/.aws/credentials`` file and add the following content. The Access Key and Secret Key shown below are for illustration only. They are invalid and you need to exchange for the actual data generated for your account.

```bash
[default]
aws_access_key_id = YOUR_ACCESS_KEY_HERE
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE
```

# AWS IAM Authenticator

Run the following commands to install IAM Authenticator.

```bash
sudo su

IAM_AUTHENTICATOR_VERSION="1.14.6"

curl -sk -L https://amazon-eks.s3-us-west-2.amazonaws.com/${IAM_AUTHENTICATOR_VERSION}/2019-08-22/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator

chmod +x /usr/local/bin/aws-iam-authenticator

exit
```

For more information about AWS IAM Authenticator visit:

* https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
* https://github.com/kubernetes-sigs/aws-iam-authenticator


# Terraform 0.12

Run the following shell function to install Terraform 0.12.

```bash
sudo su

TERRAFORM_ZIP_FILE=terraform_0.12.24_linux_amd64.zip
TERRAFORM=https://releases.hashicorp.com/terraform/0.12.24
TERRAFORM_BIN=terraform12

function install_terraform12 {
if [ -z $(which $TERRAFORM_BIN) ]; then
    wget ${TERRAFORM}/${TERRAFORM_ZIP_FILE}
    unzip ${TERRAFORM_ZIP_FILE}
    sudo mv terraform /usr/local/bin/${TERRAFORM_BIN}
    ln -sfn /usr/local/bin/${TERRAFORM_BIN} /usr/local/bin/terraform
    rm -rf ${TERRAFORM_ZIP_FILE}
    chmod +x /usr/local/bin/terraform12
else
    echo "Terraform 12 is most likely installed"
fi
}

install_terraform12

which terraform

terraform version

exit
```

For more information about Terraform visit:

* https://www.terraform.io/docs/index.html

# Terragrunt

Run the following shell function to install Terragrunt.

```bash
sudo su
 
TERRAGRUNT_VERSION="v0.21.11"
TERRAGRUNT=https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_VERSION/terragrunt_linux_amd64
TERRAGRUNT_BIN=terragrunt
 
function install_terragrunt {
if [ -z $(which $TERRAGRUNT_BIN) ]; then
    wget ${TERRAGRUNT}
    sudo mv terragrunt_linux_amd64 /usr/local/bin/${TERRAGRUNT_BIN}
    chmod +x /usr/local/bin/${TERRAGRUNT_BIN}
else
    echo "Terragrunt is most likely installed"
fi
}

install_terragrunt

which terragrunt

terragrunt --version

exit
```

For more information about Terraform visit:

* https://terragrunt.gruntwork.io/docs/


# Go

Install Go with the follow commands.

```bash
VERSION=1.13.5
mkdir -p $HOME/go

curl https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz -o go.tar.gz

sudo tar -C /usr/local -xzf go.tar.gz

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go/bin

go version
```

For more information about Go visit:

* https://golang.org/doc/
* https://medium.com/@denis_santos/primeiros-passos-com-golang-c3368f6d707a
* https://tour.golang.org
* https://www.youtube.com/watch?v=YS4e4q9oBaU
* https://www.youtube.com/watch?v=Q0sKAMal4WQ
* https://www.youtube.com/watch?v=G3PvTWRIhZA
* https://stackify.com/learn-go-tutorials/
* https://golangbot.com/
* https://www.tutorialspoint.com/go/index.htm
* https://www.guru99.com/google-go-tutorial.html
* http://www.golangbr.org/doc/codigo
* https://golang.org/doc/articles/wiki/
* https://gobyexample.com/
* https://hackr.io/tutorials/learn-golang
* https://hackernoon.com/basics-of-golang-for-beginners-6bd9b40d79ae
* https://medium.com/hackr-io/learn-golang-best-go-tutorials-for-beginners-deb6cab45867

## Terraform-Docs

Install Terraform-Docs with the follow commands.

```bash
cd $HOME/go

GO111MODULE="off" go get github.com/segmentio/terraform-docs

cd bin
sudo mv terraform-docs /usr/bin/terraform-docs
```

For more information about Terraform-Docs visit:

* https://github.com/segmentio/terraform-docs

# Kubectl

Install Kubectl with the follow commands.

```bash
sudo su
 
KUBECTL_BIN=kubectl
 
function install_kubectl {
if [ -z $(which $KUBECTL_BIN) ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/$KUBECTL_BIN
    chmod +x ${KUBECTL_BIN}
    sudo mv ${KUBECTL_BIN} /usr/local/bin/${KUBECTL_BIN}
else
    echo "Kubectl is most likely installed"
fi
}

install_kubectl

which kubectl

kubectl version

exit
```

For more information about Kubectl visit:

* https://kubernetes.io/docs/reference/kubectl/overview/
* http://blog.aeciopires.com/primeiros-passos-com-docker/

# Helm 3

Install Helm 3 with the follow commands.

```bash
sudo su

HELM_TAR_FILE=helm-v3.1.1-linux-amd64.tar.gz
HELM_URL=https://get.helm.sh
HELM_BIN=helm3

function install_helm3 {

if [ -z $(which $HELM_BIN) ]; then
    wget ${HELM_URL}/${HELM_TAR_FILE}
    tar -xvzf ${HELM_TAR_FILE}
    chmod +x linux-amd64/helm
    sudo cp linux-amd64/helm /usr/local/bin/$HELM_BIN
    sudo ln -sfn /usr/local/bin/$HELM_BIN /usr/local/bin/helm
    rm -rf ${HELM_TAR_FILE} linux-amd64
    echo -e "\nwhich ${HELM_BIN}"
    which ${HELM_BIN}
else
    echo "Helm 3 is most likely installed"
fi
}

install_helm3

which helm3

helm version

exit
```

For more information about Helm visit:

* https://helm.sh/docs/