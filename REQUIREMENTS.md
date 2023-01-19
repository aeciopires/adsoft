<!-- TOC -->

- [Requirements](#requirements)
  - [General Packages](#general-packages)
- [AWS-CLI](#aws-cli)
- [Configure AWS Credentials](#configure-aws-credentials)
- [Docker](#docker)
- [Docker Compose](#docker-compose)
- [GCloud](#gcloud)
- [Go](#go)
- [Helm 3](#helm-3)
- [Helm-docs](#helm-docs)
- [Helmfile](#helmfile)
- [Plugin for Helm](#plugin-for-helm)
  - [Helm-Diff](#helm-diff)
  - [Helm-Secrets](#helm-secrets)
- [Kubectl](#kubectl)
- [Plugins for Kubectl](#plugins-for-kubectl)
  - [Krew](#krew)
  - [kubectx e kubens](#kubectx-e-kubens)
  - [Kubetree](#kubetree)
  - [Kubefwd](#kubefwd)
  - [Kubepug](#kubepug)
  - [Kubent](#kubent)
  - [Node-shell](#node-shell)
  - [Other Kubetools](#other-kubetools)
- [Lens](#lens)
- [Script of customized prompt](#script-of-customized-prompt)
- [Shellcheck](#shellcheck)
- [Sops](#sops)
- [Terraform: Install tfenv for management of Terraform versions](#terraform-install-tfenv-for-management-of-terraform-versions)
- [Terraform-Docs](#terraform-docs)
- [Terragrunt: Install tgenv for management of Terragrunt versions](#terragrunt-install-tgenv-for-management-of-terragrunt-versions)
- [Aliases](#aliases)

<!-- TOC -->

# Requirements

## General Packages

Install the follow packages.

Debian/Ubuntu:

```bash
sudo apt-get install -y vim traceroute telnet git tcpdump elinks curl wget openssl netcat net-tools python3 python3-pip python3-venv
```

CentOS:

```bash
sudo yum install -y vim traceroute telnet git tcpdump elinks curl wget openssl netcat net-tools
```

Install Python 3 in CentOS: https://linuxize.com/post/how-to-install-python-3-on-centos-7

# AWS-CLI

Run the following commands to install ``awscli`` package.

```bash
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"

unzip awscli-bundle.zip

sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

aws --version

rm -rf awscli-bundle.zip awscli-bundle
```

Or in Ubuntu:

```bash
sudo snap install aws-cli --classic
```


More information about ``aws-cli``: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

Reference: https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html

# Configure AWS Credentials

[OPTIONAL] You will need to create an Amazon AWS account. Create a **Free Tier** account at Amazon https://aws.amazon.com/ follow the instructions on the pages: https://docs.aws.amazon.com/chime/latest/ag/aws-account.html and https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html. When creating the account you will need to register a credit card, but since you will create instances using the features offered by the **Free Tier** plan, nothing will be charged if you do not exceed the limit for the use of the features and time offered and described in the previous link.

After creating the account in AWS, access the Amazon CLI interface at: https://aws.amazon.com/cli/

Click on the username (upper right corner) and choose the **Security Credentials** option. Then click on the **Access Key and Secret Access Key** option and click the **New Access Key** button to create and view the ID and Secret of the key.

Create the directory below.

```bash
echo $HOME

mkdir -p $HOME/.aws/

touch $HOME/.aws/credentials
```

Open ``$HOME/.aws/credentials`` file and add the following content and change the access key and secret access key.
```
[default]
aws_access_key_id = YOUR_ACCESS_KEY_HERE
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE
```

In this case, the profile name AWS is **default**.

Reference: https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html
# Docker

Install Docker CE (Community Edition) following the instructions of the pages below, according to your GNU/Linux distribution.

* CentOS: https://docs.docker.com/engine/install/centos/
* Debian: https://docs.docker.com/engine/install/debian/
* Ubuntu: https://docs.docker.com/engine/install/ubuntu/

Start the ``docker`` service, configure Docker to boot up with the OS and add your user to the ``docker`` group.

```bash
# Start the Docker service
sudo systemctl start docker

# Configure Docker to boot up with the OS
sudo systemctl enable docker

# Add your user to the Docker group
sudo usermod -aG docker $USER
sudo setfacl -m user:$USER:rw /var/run/docker.sock
```

Reference: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot

For more information about Docker Compose visit:

* https://docs.docker.com
* http://blog.aeciopires.com/primeiros-passos-com-docker

# Docker Compose

Instructions for downloading and starting Docker Compose

```bash
sudo su

COMPOSE_VERSION=1.29.2

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

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk
gcloud init
```

For more informations:

* https://cloud.google.com/docs/authentication/getting-started
* https://console.cloud.google.com/apis/credentials/serviceaccountkey
* https://cloud.google.com/sdk/install
* https://cloud.google.com/sdk/docs/downloads-apt-get
* https://cloud.google.com/sdk/gcloud/reference/config/set
* https://code-maven.com/gcloud
* https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97
* https://blog.realkinetic.com/using-google-cloud-service-accounts-on-gke-e0ca4b81b9a2
* https://www.the-swamp.info/blog/configuring-gcloud-multiple-projects/

# Go

Run the following commands to install Go.

```bash
VERSION=1.19.5

mkdir -p $HOME/go/bin

cd /tmp
curl -L https://go.dev/dl/go$VERSION.linux-amd64.tar.gz -o go.tar.gz

sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go.tar.gz
rm /tmp/go.tar.gz

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

go version

echo "GOPATH=$HOME/go" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> ~/.bashrc
```

For more informations:

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

# Helm 3

Install Helm 3 with the follow commands.

```bash
sudo su

HELM_TAR_FILE=helm-v3.7.1-linux-amd64.tar.gz
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
which $HELM_BIN
$HELM_BIN version

exit
```

For more information about Helm visit:

* https://helm.sh/docs/


# Helm-docs

Install ``helm-docs`` with the follow commands.

Documentation: https://github.com/norwoodj/helm-docs 

```bash
HELM_DOCS_VERSION=1.11.0
HELM_DOCS_PACKAGE=helm-docs_``$HELM_DOCS_VERSION``_linux_x86_64.tar.gz
cd /tmp
wget https://github.com/norwoodj/helm-docs/releases/download/v$HELM_DOCS_VERSION/$HELM_DOCS_PACKAGE
tar xzvf $HELM_DOCS_PACKAGE
sudo mv helm-docs /usr/local/bin/
sudo chmod +rx /usr/local/bin/helm-docs
helm-docs --version
```

# Helmfile

Install ``helmfile`` with the follow commands.

Documentation: https://github.com/helmfile/helmfile

```bash
sudo su

HELMFILE_BIN=helmfile
HELMFILE_VERSION="0.150.0"
HELMFILE_DOWNLOADED_DIR="helmfile_${HELMFILE_VERSION}_linux_amd64"
HELMFILE_DOWNLOADED_PACKAGE="${HELMFILE_DOWNLOADED_DIR}.tar.gz"
HURL=https://github.com/helmfile/helmfile/releases/download
HELMFILE_URL=${HURL}/v${HELMFILE_VERSION}/${HELMFILE_DOWNLOADED_PACKAGE}

function install_helmfile {

if [ -z $(which $HELMFILE_BIN) ]; then
    cd /tmp
    wget ${HELMFILE_URL}
    tar xzvf ${HELMFILE_DOWNLOADED_PACKAGE}
    chmod +x ${HELMFILE_BIN}
    sudo mv ${HELMFILE_BIN} /usr/local/bin/${HELMFILE_BIN}
    echo -e "\nexecuting: which ${HELMFILE_BIN}"
    which ${HELMFILE_BIN}
    ${HELMFILE_BIN} --version
    rm ${HELMFILE_DOWNLOADED_PACKAGE}
else
    echo "Helmfile is most likely installed"
    ${HELMFILE_BIN} --version
fi
}

install_helmfile

exit
```

# Plugin for Helm

## Helm-Diff

Install the plugin with the follow commands.

Documentation: https://github.com/databus23/helm-diff

```bash
helm repo update
helm plugin install https://github.com/databus23/helm-diff --version v3.1.3
```

## Helm-Secrets

Install the plugin with the follow commands.

Documentation: https://github.com/jkroepke/helm-secrets

```bash
helm repo update
helm plugin install https://github.com/jkroepke/helm-secrets --version v3.5.0
```

# Kubectl

Run the following commands to install ``kubectl``.

```bash
sudo su

VERSION=v1.22.2
KUBECTL_BIN=kubectl

function install_kubectl {
if [ -z $(which $KUBECTL_BIN) ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/$KUBECTL_BIN
    chmod +x ${KUBECTL_BIN}
    sudo mv ${KUBECTL_BIN} /usr/local/bin/${KUBECTL_BIN}
    sudo ln -sf /usr/local/bin/${KUBECTL_BIN} /usr/bin/${KUBECTL_BIN}
else
    echo "Kubectl is most likely installed"
fi
}

install_kubectl

which kubectl

kubectl version --client

exit
```

More information about ``kubectl``: https://kubernetes.io/docs/reference/kubectl/overview/

Reference: https://kubernetes.io/docs/tasks/tools/install-kubectl/

# Plugins for Kubectl

## Krew

Documentation:

* https://github.com/kubernetes-sigs/krew/
* https://krew.sigs.k8s.io/docs/user-guide/setup/install/

```bash
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
  "$KREW" install krew
)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

cat << FOE >> ~/.bashrc

#krew
export PATH="\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH"
FOE
```

## kubectx e kubens

Documentation: https://github.com/ahmetb/kubectx#installation

```bash
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
COMPDIR=$(sudo pkg-config --variable=completionsdir bash-completion)
sudo ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
sudo ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
cat << FOE >> ~/.bashrc

#kubectx and kubens
export PATH=~/.kubectx:\$PATH
FOE
```

## Kubetree

Documentation: https://github.com/ahmetb/kubectl-tree

```bash
kubectl krew install tree
```

## Kubefwd

Documentation: https://github.com/txn2/kubefwd

```bash
cd /tmp
wget https://github.com/txn2/kubefwd/releases/download/1.14.0/kubefwd_amd64.deb
sudo dpkg -i kubefwd_amd64.deb 
kubefwd 
rm kubefwd_amd64.deb 
source <(kubectl completion bash)
```

## Kubepug

Documentation: https://github.com/rikatz/kubepug

```bash
VERSION=v1.1.3
cd /tmp
wget https://github.com/rikatz/kubepug/releases/download/$VERSION/kubepug_linux_amd64.tar.gz
tar xzvf kubepug_linux_amd64.tar.gz
sudo mv kubepug /usr/local/bin/
kubepug --version
```

## Kubent

```bash
sh -c "$(curl -sSL https://git.io/install-kubent)"
kubent --help
```

Documentation: https://github.com/swade1987/deprek8ion

## Node-shell

```bash
kubectl krew install node-shell
```

Documentation: https://github.com/kvaps/kubectl-node-shell

## Other Kubetools

* http://dockerlabs.collabnix.com/kubernetes/kubetools/
* https://caylent.com/50-useful-kubernetes-tools
* https://caylent.com/50+-useful-kubernetes-tools-list-part-2
* https://developer.sh/posts/kubernetes-client-tools-overview
* https://github.com/kubernetes-sigs/kind
* https://github.com/rancher/k3d
* https://microk8s.io/
* https://argoproj.github.io/argo-cd/

# Lens

Lens is an IDE for controlling your Kubernetes clusters. It is open source and free.

```bash
sudo snap install kontena-lens --classic
```

Documentation:

* https://k8slens.dev/
* https://snapcraft.io/kontena-lens

# Script of customized prompt

To show the branch name, current directory, authenticated k8s cluster and namespace in use, there are several open source projects that provide this and you can choose the one that suits you best.

For zsh:

* https://ohmyz.sh/
* https://www.2vcps.io/2020/07/02/oh-my-zsh-fix-my-command-prompt/

For bash:

* https://github.com/ohmybash/oh-my-bash
* https://github.com/jonmosco/kube-ps1

bash_prompt:

```bash
curl -o ~/.bash_prompt https://gist.githubusercontent.com/aeciopires/6738c602e2d6832555d32df78aa3b9bb/raw/b96be4dcaee6db07690472aecbf73fcf953a7e91/.bash_prompt
chmod +x ~/.bash_prompt
echo "source ~/.bash_prompt" >> ~/.bashrc 
source ~/.bashrc
exec bash
```

# Shellcheck

It is possible to install ``shellcheck`` from the standard Ubuntu 18.04 repository, but it installs version 0.4.6. There are newer versions in the maintainer repository on Github that integrate better with the VSCode plugin.

Run the following commands:

```bash
cd /tmp
VERSION=$(curl -s https://api.github.com/repos/koalaman/shellcheck/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -LO https://github.com/koalaman/shellcheck/releases/download/$VERSION/shellcheck-$VERSION.linux.x86_64.tar.xz
tar xJvf shellcheck-$VERSION.linux.x86_64.tar.xz
sudo mv shellcheck-$VERSION/shellcheck /usr/bin/shellcheck
rm -rf /tmp/shellcheck-$VERSION/
rm /tmp/shellcheck-$VERSION.linux.x86_64.tar.xz
shellcheck --version
cd -
```

Documentation: https://github.com/koalaman/shellcheck/

# Sops

Documentation: https://github.com/mozilla/sops

```bash
sudo su

function install_sops {
if [ -z $(which sops) ]; then
    VERSION_SOPS=$(curl -s https://api.github.com/repos/mozilla/sops/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -LO https://github.com/mozilla/sops/releases/download/$VERSION_SOPS/sops-$VERSION_SOPS.linux
    sudo mv sops-$VERSION_SOPS.linux /usr/local/bin/sops
    sudo chmod +x /usr/local/bin/sops
else
    echo "sops is most likely installed"
fi
}

install_sops
which sops
sops --version

exit
```

Example of config file ``~/.sops.yaml``:

```yaml
creation_rules:
    - kms: 'arn:aws:kms:AWS_REGION:AWS_ACCOUNT_ID:PATH_ARN_KEY_SYMMETRIC'
      aws_profile: default
```

Where:

* *AWS_REGION*: should be replaced with the AWS region.
* *AWS_ACCOUNT_ID*: should be replaced with the AWS account ID.
* *PATH_ARN_KEY_SYMMETRIC*: should be replaced with the ARN of the symmetric key created in AWS KMS.

# Terraform: Install tfenv for management of Terraform versions

Run the following commands to install ``tfenv``.

```bash
cd $HOME
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

Install Terraform version using ``tfenv`` command:

```bash
tfenv install 1.1.4
```

More information about ``tfenv``: https://github.com/tfutils/tfenv

List Terraform versions to install:

```bash
tfenv list-remote
```

Using specific Terraform version installed:

```bash
tfenv use <VERSION>
```

Uninstall Terraform version with ``tfenv`` command:

```bash
tfenv uninstall <VERSION>
```

List Terraform versions installed:

```bash
tfenv list
```

Only when developing code that makes use of Terraform, you can force the project to use a specific version:

Create the ``.terraform-version`` file at the root of the project with the desired version number.

Example:

```bash
echo "1.1.4" > .terraform-version
```

# Terraform-Docs

Install Terraform-Docs with the follow commands.

```bash
cd /tmp

VERSION=v0.16.0

curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$VERSION/terraform-docs-$VERSION-$(uname)-amd64.tar.gz

tar -xzf terraform-docs.tar.gz

chmod +x terraform-docs

sudo mv terraform-docs /usr/local/bin/terraform-docs

rm terraform-docs.tar.gz

terraform-docs --version
```

For more information about Terraform-Docs visit:

* https://github.com/segmentio/terraform-docs

# Terragrunt: Install tgenv for management of Terragrunt versions

Run the following commands to install ``tgenv``.

Documentação: https://github.com/cunymatthieu/tgenv

https://blog.gruntwork.io/how-to-manage-multiple-versions-of-terragrunt-and-terraform-as-a-team-in-your-iac-project-da5b59209f2d

```bash
cd $HOME
git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
sudo ln -s ~/.tgenv/bin/* /usr/local/bin
```

Install Terragrunt version using ``tgenv`` command:

```bash
tgenv install 0.36.0
```

List Terragrunt versions to install:

```bash
tgenv list-remote
```

Using specific Terragrunt version installed:

```bash
tgenv use <VERSION>
```

Uninstall Terragrunt version with ``tgenv`` command:

```bash
tgenv uninstall <VERSION>
```

List Terragrunt versions installed:

```bash
tgenv list
```

Only when developing code that makes use of Terragrunt, you can force the project to use a specific version:

Create the ``.terragrunt-version`` file at the root of the project with the desired version number.

Example:

```bash
echo "0.36.0" > .terragrunt-version
```

# Aliases

Useful aliases to be registered in the ``$HOME/.bashrc`` file.

```bash
alias gitlog='git log -p'
alias limitselb='aws elbv2 describe-account-limits --region us-east-1'
alias cerebro='helm install cerebro stable/cerebro -n default'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bat='bat --theme ansi'
alias connect_eks='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias k='kubectl'
alias kmongo='kubectl run --rm -it mongoshell --image=mongo:4 -n default -- bash'
alias kmysql='kubectl run --rm -it mysql --image=mysql:5.7 -n default -- bash'
alias kredis='kubectl run --rm -it redis-cli --image=redis:latest -n default -- bash'
alias kssh='kubectl run ssh-client -it --rm --image=kroniak/ssh-client -n default -- bash'
alias l='ls -CF'
alias la='ls -A'
alias live='curl parrot.live'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias nettools='kubectl run --rm -it nettools --image=travelping/nettools:latest -n default -- bash'
alias randompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}'
alias show-hidden-files='du -sch .[!.]* * |sort -h'
alias ssm='aws ssm start-session --target CHANGE_EC2_ID --region CHANGE_REGION --profile CHANGE_PROFILE'
alias terradocs='terraform-docs markdown table . > README.md'
```
