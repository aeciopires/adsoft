<!-- TOC -->

- [Requirements](#requirements)
- [General Packages](#general-packages)
- [Updating many git repositories](#updating-many-git-repositories)
- [asdf](#asdf)
- [AWS-CLI](#aws-cli)
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
- [Kind](#kind)
- [Plugins for Kubectl](#plugins-for-kubectl)
  - [Krew](#krew)
  - [kubectx e kubens](#kubectx-e-kubens)
  - [Kubefwd](#kubefwd)
- [Kubeshark (old Mizu)](#kubeshark-old-mizu)
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

# General Packages

Install the follow packages.

Ubuntu 22.04:

```bash
sudo apt update
sudo apt install -y vim telnet git curl wget openssl netcat net-tools python3 python3-pip meld python3-venv default-jdk jq make traceroute wireshark elinks redis-tools mysql-client gnupg
```

# Updating many git repositories

Create the ``~/git`` directory.

```bash
mkdir ~/git
```

Download the ``updateGit.sh`` script

```bash
cd ~

wget https://gist.githubusercontent.com/aeciopires/2457cccebb9f30fe66ba1d67ae617ee9/raw/8d088c6fadb8a4397b5ff2c7d6a36980f46d40ae/updateGit.sh

chmod +x ~/updateGit.sh
```

Now you can clone all the git repositories and save it inside ``~/git`` directory.

To update all git repositories run the commands.

```bash
cd ~

./updateGit.sh git/
```

# asdf

> ATTENTION!!!
> To update asdf, ONLY use the following command. If you try to reinstall or update by changing the version in the following commands, you will need to reinstall all plugins/commands installed before, so it is very important to back up the ``$HOME/.asdf`` directory.

```bash
asdf update
```

To install ``asdf`` run the following commands:

```bash
ASDF_VERSION="v0.14.0"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION

# Adicionando no $HOME/.bashrc
echo ". \"\$HOME/.asdf/asdf.sh\"" >> ~/.bashrc
echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc
source ~/.bashrc
```

Reference: https://asdf-vm.com/guide/introduction.html

# AWS-CLI

Run the following commands to install ``awscli`` package.

```bash
AWS_CLI_V1="1.32.42"
AWS_CLI_V2="2.15.20"

asdf plugin list all | grep aws
asdf plugin add awscli https://github.com/MetricMike/asdf-awscli.git
asdf latest awscli

asdf install awscli $AWS_CLI_V1
asdf install awscli $AWS_CLI_V2
asdf list awscli

# Definindo a versão padrão
asdf global awscli $AWS_CLI_V2
asdf list awscli
```

More information about ``aws-cli``: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

Reference: https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html

Configure AWS Credentials manually or using SSO

# Docker

Install Docker CE (Community Edition):

```bash
curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
# Utilizando docker sem sudo
sudo usermod -aG docker $USER;
sudo setfacl -m user:$USER:rw /var/run/docker.sock
```

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
VERSION="464.0.0"

asdf plugin list all | grep gcloud
asdf plugin add gcloud https://github.com/jthegedus/asdf-gcloud.git
asdf latest gcloud

asdf install gcloud $VERSION
asdf list gcloud

# Definindo a versão padrão
asdf global gcloud $VERSION
asdf list gcloud

gcloud init (alternativamente, gcloud init --console-only)
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
VERSION=1.22.0

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
VERSION="3.14.0"

asdf plugin list all | grep helm
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf latest helm

asdf install helm $VERSION
asdf list helm

# Definindo a versão padrão
asdf global helm $VERSION
asdf list helm
```

For more information about Helm visit:

* https://helm.sh/docs/

# Helm-docs

Install ``helm-docs`` with the follow commands.

Documentation: https://github.com/norwoodj/helm-docs 

```bash
VERSION="1.12.0"

asdf plugin list all | grep helm-docs
asdf plugin add helm-docs https://github.com/sudermanjr/asdf-helm-docs.git
asdf latest helm-docs

asdf install helm-docs $VERSION
asdf list helm-docs

# Definindo a versão padrão
asdf global helm-docs $VERSION
asdf list helm-docs
```

# Helmfile

Install ``helmfile`` with the follow commands.

Documentation: https://github.com/helmfile/helmfile

```bash
VERSION="0.161.0"

asdf plugin list all | grep helmfile
asdf plugin add helmfile https://github.com/feniix/asdf-helmfile.git
asdf latest helmfile

asdf install helmfile $VERSION
asdf list helmfile

# Definindo a versão padrão
asdf global helmfile $VERSION
asdf list helmfile
```

# Plugin for Helm

## Helm-Diff

Install the plugin with the follow commands.

Documentation: https://github.com/databus23/helm-diff

```bash
helm plugin install https://github.com/databus23/helm-diff --version v3.4.1
```

## Helm-Secrets

Install the plugin with the follow commands.

Documentation: https://github.com/jkroepke/helm-secrets

```bash
helm plugin install https://github.com/jkroepke/helm-secrets --version v3.5.0
```

# Kubectl

Run the following commands to install ``kubectl``.

```bash
VERSION_OPTION_1="1.29.2"

asdf plugin list all | grep kubectl
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf latest kubectl

asdf install kubectl $VERSION_OPTION_1
asdf list kubectl

# Definindo a versão padrão
asdf global kubectl $VERSION_OPTION_1
asdf list kubectl
```

More information about ``kubectl``: https://kubernetes.io/docs/reference/kubectl/overview/

Reference: https://kubernetes.io/docs/tasks/tools/install-kubectl/

# Kind

Run the following commands to install kind.

```bash
VERSION="0.22.0"
asdf plugin list all | grep kind
asdf plugin add kind https://github.com/johnlayton/asdf-kind.git
asdf latest kind
asdf install kind $VERSION
asdf list kind
# Definindo a versão padrão
asdf global kind $VERSION
```

More information about kind:

* https://kind.sigs.k8s.io
* https://kind.sigs.k8s.io/docs/user/quick-start/
* https://github.com/kubernetes-sigs/kind/releases
* https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/#kind-kubernetes-made-easy-in-a-container

# Plugins for Kubectl

## Krew

Documentation:

* https://github.com/kubernetes-sigs/krew/
* https://krew.sigs.k8s.io/docs/user-guide/setup/install/

```bash
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
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

## Kubefwd

Documentation: https://github.com/txn2/kubefwd

```bash
VERSION=1.22.5
wget https://github.com/txn2/kubefwd/releases/download/$VERSION/kubefwd_amd64.deb
sudo dpkg -i kubefwd_amd64.deb 
kubefwd 
rm kubefwd_amd64.deb
```

# Kubeshark (old Mizu)

Kubeshark is a tool for real-time K8s protocol-level visibility, capturing and monitoring all traffic and payloads going in, out and across containers, pods, nodes and clusters.

Is recommend choosing the right binary to download directly from the [latest release](https://github.com/kubeshark/kubeshark/releases/latest).

Alternatively you can use a shell script to download the right binary for your operating system and CPU architecture:

```bash
sh <(curl -Ls https://kubeshark.co/install)
```

References:

* https://docs.kubeshark.co/en/install

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

It is possible to install ``shellcheck`` from the standard Ubuntu 18.04 repository, but it installs version 0.4.6. There are newer versions in the maintainer repository on GitHub that integrate better with the VSCode plugin.

Run the following commands:

```bash
VERSION="0.9.0"
asdf plugin list all | grep shellcheck
asdf plugin add shellcheck https://github.com/luizm/asdf-shellcheck.git
asdf latest shellcheck
asdf install shellcheck $VERSION
asdf list shellcheck
# Definindo a versão padrão
asdf global shellcheck $VERSION
```

Documentation: https://github.com/koalaman/shellcheck/

# Sops

Documentation: https://github.com/mozilla/sops

```bash
VERSION="3.8.1"

asdf plugin list all | grep sops
asdf plugin add sops https://github.com/feniix/asdf-sops.git
asdf latest sops

asdf install sops $VERSION
asdf list sops

# Definindo a versão padrão
asdf global sops $VERSION
asdf list sops
sops --version
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
tfenv install 1.4.6
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
echo "1.4.6" > .terraform-version
```

# Terraform-Docs

Install Terraform-Docs with the follow commands.

```bash
cd /tmp

VERSION=v0.17.0

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
tgenv install 0.45.18
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
echo "0.45.18" > .terragrunt-version
```

There is a problem in ``tgenv`` versions where very old terragrunt versions are not remotely installed/listed. This is due to a query used in the code [that uses the GitHub API](https://github.com/cunymatthieu/tgenv/blob/master/libexec/tgenv-list-remote#L12). For this, we have a possible workaround

Fix proposed and revised in open PR: https://github.com/cunymatthieu/tgenv/pull/15/files

Change the ``~/.tgenv/libexec/tgenv-list-remote`` file to look exactly like this:

```bash
#!/usr/bin/env bash
set -e

[ -n "${TGENV_DEBUG}" ] && set -x
source "${TGENV_ROOT}/libexec/helpers"

if [ ${#} -ne 0 ];then
  echo "usage: tgenv list-remote" 1>&2
  exit 1
fi

GITHUB_API_HEADER_ACCEPT="Accept: application/vnd.github.v3+json"

temp=`basename $0`
TMPFILE=`mktemp /tmp/${temp}.XXXXXX` || exit 1

function rest_call {
    curl --tlsv1.2 -sf $1 -H "${GITHUB_API_HEADER_ACCEPT}" | sed -e 's/^\[$//g' -e 's/^\]$/,/g' >> $TMPFILE
}

# single page result-s (no pagination), have no Link: section, the grep result is empty
last_page=`curl -I --tlsv1.2 -s "https://api.github.com/repos/gruntwork-io/terragrunt/tags?per_page=100" -H "${GITHUB_API_HEADER_ACCEPT}" | grep '^link:' | sed -e 's/^link:.*page=//g' -e 's/>.*$//g'`

# does this result use pagination?
if [ -z "$last_page" ]; then
    # no - this result has only one page
    rest_call "https://api.github.com/repos/gruntwork-io/terragrunt/tags?per_page=100"
else
    # yes - this result is on multiple pages
    for p in `seq 1 $last_page`; do
        rest_call "https://api.github.com/repos/gruntwork-io/terragrunt/tags?per_page=100&page=$p"
    done
fi

return_code=$?
if [ $return_code -eq 22 ];then
  warn_and_continue "Failed to get list verion on $link_release"
  print=`cat ${TGENV_ROOT}/list_all_versions_offline`
fi

cat $TMPFILE | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+(-(rc|beta)[0-9]+)?" | uniq
```

# Aliases

Useful aliases to be registered in the ``$HOME/.bashrc`` file.

```bash
alias awsv1='docker run --rm -ti -v ~/.aws:/root/.aws gcr.io/production-main-268117/tools:v3.4.0'
alias awsv2='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws public.ecr.aws/aws-cli/aws-cli:2.15.20'
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
alias kmongo='kubectl run --rm -it mongoshell-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mongo:4.0.28 -n default -- bash'
alias kmysql5='kubectl run --rm -it mysql5-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mysql:5.7 -n default -- bash'
alias kmysql8='kubectl run --rm -it mysql8-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mysql:8.0 -n default -- bash'
alias kredis='kubectl run --rm -it redis-cli-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=redis:latest -n default -- bash'
alias kssh='kubectl run --rm -it ssh-agent-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=kroniak/ssh-client -n default -- bash'
alias l='ls -CF'
alias la='ls -A'
alias live='curl parrot.live'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias nettools='kubectl run --rm -it nettools-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=aeciopires/nettools:1.0.0 -n default -- bash'
alias randompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}'
alias sc="source ~/.bashrc"
alias show-hidden-files='du -sch .[!.]* * |sort -h'
alias terradocs='terraform-docs markdown table . > README.md'
export EDITOR=/usr/bin/vim
```
