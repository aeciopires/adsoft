<!-- TOC -->

- [Ubuntu](#ubuntu)
  - [Essentials](#essentials)
  - [Optional](#optional)
- [Git](#git)
- [mise](#mise)
- [ansible](#ansible)
- [awscli](#awscli)
- [bat](#bat)
- [docker](#docker)
- [docker compose](#docker-compose)
- [gcloud](#gcloud)
- [Go](#go)
- [Helm](#helm)
- [helm-docs](#helm-docs)
- [helmfile](#helmfile)
- [helm-diff - Plugin](#helm-diff---plugin)
- [helm-secrets - Plugin](#helm-secrets---plugin)
- [jj](#jj)
- [kubectl](#kubectl)
- [Plugins for kubectl](#plugins-for-kubectl)
  - [krew](#krew)
  - [kubectx and kubens](#kubectx-and-kubens)
  - [Fuzzy](#fuzzy)
  - [kubectl-tree](#kubectl-tree)
  - [kubecolor](#kubecolor)
  - [node-shell](#node-shell)
  - [kubefwd](#kubefwd)
  - [kubepug](#kubepug)
  - [kubent](#kubent)
  - [Other Kubetools](#other-kubetools)
- [kubeshark](#kubeshark)
- [k9s](#k9s)
- [kustomize](#kustomize)
- [lens](#lens)
- [Postman](#postman)
- [pre-commit](#pre-commit)
- [Custom Terminal Prompt](#custom-terminal-prompt)
  - [bash\_prompt](#bash_prompt)
- [qq](#qq)
- [ShellCheck](#shellcheck)
- [Sops](#sops)
- [terraform](#terraform)
- [terraform-docs](#terraform-docs)
- [terragrunt](#terragrunt)
- [vault-cli](#vault-cli)
- [yq](#yq)
- [tig](#tig)
- [ec2-instance-selector](#ec2-instance-selector)
- [\[OPTIONAL\] Useful aliases](#optional-useful-aliases)
  - [bashrc](#bashrc)
- [\[OPTIONAL\] Clipboard Indicator](#optional-clipboard-indicator)
- [\[OPTIONAL\] Flameshot](#optional-flameshot)
- [\[OPTIONAL\] kind](#optional-kind)
- [\[OPTIONAL\] minikube](#optional-minikube)
- [\[OPTIONAL\] trivy](#optional-trivy)
  - [Installing trivy via Docker](#installing-trivy-via-docker)
- [\[OPTIONAL\] tflint](#optional-tflint)

<!-- TOC -->

# Ubuntu

## Essentials

Run the following commands on Ubuntu 24.04/22.04:

```bash
sudo apt install -y vim traceroute telnet netcat-openbsd git tcpdump elinks curl wget openssl net-tools python3 python3-pip meld python3-venv default-jdk jq make gnupg
```

With Python "3.10.*" (Ubuntu 22.04) run the following command to create the symbolic link:

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
```

With Python "3.12.*" (Ubuntu 24.04) run the following command to create the symbolic link:

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1
```

## Optional

Run the following commands:

```bash
sudo apt install -y wireshark redis-tools mysql-client gimp
```

Install the following software:

- Firefox
- Google Chrome
- WPS: https://www.wps.com/
- Visual Code: https://code.visualstudio.com
  - Installation on Ubuntu: https://code.visualstudio.com/docs/setup/linux
  - Plugins for Visual Code
  - Instructions to export/import VSCode plugins: https://stackoverflow.com/questions/35773299/how-can-you-export-the-visual-studio-code-extension-list
  - docker: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker (Requires the docker command shown in the following sections).
  - gitlens: https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens (Requires the git command shown in the previous section).
  - go: https://marketplace.visualstudio.com/items?itemName=golang.Go (Requires the go command shown in the following sections).
  - gotemplate-syntax: https://marketplace.visualstudio.com/items?itemName=casualjim.gotemplate
  - Markdown-all-in-one: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
  - Markdown-lint: https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint
  - Markdown-toc: https://marketplace.visualstudio.com/items?itemName=CharlesWan.markdown-toc
  - python: https://marketplace.visualstudio.com/items?itemName=ms-python.python (Requires the python3 command shown in the previous section).
  - shellcheck: https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck (Requires the shellcheck command shown in the following sections).
  - terraform: https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform (Requires the terraform command shown in the following sections).
  - YAML: https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml
  - Helm Intellisense: https://marketplace.visualstudio.com/items?itemName=Tim-Koehler.helm-intellisense
  - Count the number of selected lines: https://marketplace.visualstudio.com/items?itemName=gurumukhi.selected-lines-count
  - jenkinsfile support: https://marketplace.visualstudio.com/items?itemName=ivory-lab.jenkinsfile-support
  - Theme for VSCode:
    - https://code.visualstudio.com/docs/getstarted/themes
    - https://dev.to/thegeoffstevens/50-vs-code-themes-for-2020-45cc
    - https://vscodethemes.com/

# Git

Create the directory ``~/git``.

```bash
mkdir ~/git
```

Download the ``updateGit`` binary as shown in the following link: https://github.com/aeciopires/updateGit

Now you can clone all git repositories and save them inside ``~/git``.

At the beginning of the working day, update all git repositories at once with the following command.

```bash
cd ~
./updateGit pull -G git/
```

# mise

[mise](https://mise.jdx.dev) is a polyglot tool version manager (it replaces asdf). It installs the tools of this guide and pins their versions in the ``mise.toml`` file (per project) or in the ``~/.config/mise/config.toml`` file (global defaults of the user).

Install mise with the official installer, which also adds the activation of mise to ``$HOME/.bashrc``:

```bash
curl -fsSL https://mise.run/bash | sh
source ~/.bashrc

mise --version

# Installing the bash completion
mise completion bash --install
```

> Alternatively, on Ubuntu 26.04+ you can install mise with the PPA: ``sudo add-apt-repository -y ppa:jdxcode/mise && sudo apt update && sudo apt install -y mise``. In this case, add the activation to ``$HOME/.bashrc`` with the command: ``echo 'eval "$(mise activate bash)"' >> ~/.bashrc``.

Useful commands:

```bash
mise use -g TOOL@VERSION   # install a tool and set the default version in ~/.config/mise/config.toml
mise use TOOL@VERSION      # install a tool and pin the version in the mise.toml file of the current directory
mise install               # install all tools defined in the mise.toml files of the current directory and its parents
mise ls                    # list the installed tools and where each version is defined
mise ls-remote TOOL        # list the versions that can be installed
mise latest TOOL           # show the latest version of a tool
mise uninstall TOOL@VERSION
mise trust                 # trust the mise.toml file of a project (required the first time it is used)
mise self-update           # update mise (installations made with mise.run)
```

> If you are migrating from asdf: mise reads the ``.tool-versions`` files of asdf, but this repository uses ``mise.toml`` files. After installing the tools with mise, remove the asdf lines from ``$HOME/.bashrc`` (``. "$HOME/.asdf/asdf.sh"`` or ``export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"``) to avoid conflicts between the shims of asdf and mise.

Source:
- https://mise.jdx.dev/installing-mise.html
- https://mise.jdx.dev/getting-started.html
- https://mise.jdx.dev/configuration.html

# ansible

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="14.4.0"

# The ansible package is installed by the pypi backend of mise, which uses uv
mise use -g uv@latest

mise ls-remote ansible | tail
mise latest ansible

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g ansible@$VERSION
mise ls ansible

ansible --version
```

> The ``ansible`` package version 14.x requires Python >= 3.12 (https://pypi.org/project/ansible/).

# awscli

Install ``awscli`` using ``mise`` (the tool is called ``aws-cli`` in mise):

> Before continuing, if you have awscli installed, remove it with the following commands:

```bash
sudo rm /usr/local/bin/aws
sudo rm -rf /usr/local/aws-cli
# or
sudo rm -rf /usr/local/aws
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
AWS_CLI_V2="2.37.9"

mise ls-remote aws-cli | tail
mise latest aws-cli

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g aws-cli@$AWS_CLI_V2
mise ls aws-cli
```

Source:
- https://mise.jdx.dev/getting-started.html
- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# bat

bat is a ``cat`` clone with syntax highlighting and Git integration. It is very useful when used together with other commands, including ``kubectl`` and ``helm``.

> Before continuing, if you have bat installed, remove it with the following command:

```bash
sudo rm /usr/bin/bat
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="0.26.1"

mise ls-remote bat | tail
mise latest bat

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g bat@$VERSION
mise ls bat
```

A usage tip for terminals with dark/light themes is to use the option ``--theme ansi``. You can create an alias, so that whenever the command is invoked, it uses this parameter:

```bash
echo "alias bat='bat --theme ansi'" >> ~/.bashrc && . ~/.bashrc
```

More information at: https://github.com/sharkdp/bat

# docker

Install Docker CE (Community Edition) following the instructions of the page: https://docs.docker.com/engine/install/ubuntu/.

```bash
sudo apt update
sudo apt install -y acl
curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
# Using docker without sudo
sudo usermod -aG docker $USER;
sudo setfacl -m user:$USER:rw /var/run/docker.sock
```

Source: https://docs.docker.com/engine/install/linux-postinstall/

# docker compose

Documentation: https://docs.docker.com/compose/

Docker Compose v2 is a plugin of Docker and it is installed by the ``get-docker.sh`` script (package ``docker-compose-plugin``) used in the [docker](#docker) section. Use the command ``docker compose`` (with a space) instead of ``docker-compose``. The standalone ``docker-compose`` v1 is no longer supported.

To install or update only the plugin, run the following commands:

```bash
sudo apt update
sudo apt install -y docker-compose-plugin

docker compose version
```

Source: https://docs.docker.com/compose/install/linux/

# gcloud

> Before continuing, if you have gcloud installed via apt, remove it with the following commands:

```bash
sudo apt remove google-cloud-sdk
sudo rm /etc/apt/sources.list.d/google-cloud-sdk.list
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="587.0.0"

mise ls-remote gcloud | tail
mise latest gcloud

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g gcloud@$VERSION
mise ls gcloud

gcloud init # (alternatively, gcloud init --console-only)
gcloud components install gke-gcloud-auth-plugin
```

Follow the instructions in this section to authenticate with gcloud, which is also used by terraform/terragrunt in GCP.

If the following error occurs when using gcloud commands:
``ERROR: gcloud crashed (SystemError): ffi_prep_closure(): bad user_data (it seems that the version of the libffi library seen at runtime is different from the 'ffi.h' file seen at compile-time)``

Do the following to solve it on Ubuntu 20.04:

```bash
pip3 uninstall cffi xcffib
sudo apt install -y libffi-dev
```

Source: https://stackoverflow.com/questions/62658237/it-seems-that-the-version-of-the-libffi-library-seen-at-runtime-is-different-fro

References:
- https://cloud.google.com/sdk/docs/install
- https://cloud.google.com/sdk/docs/downloads-apt-get
- https://cloud.google.com/docs/authentication/gcloud
- https://cloud.google.com/docs/authentication/getting-started
- https://console.cloud.google.com/apis/credentials/serviceaccountkey
- https://cloud.google.com/sdk/gcloud/reference/config/set
- https://code-maven.com/gcloud
- https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97
- https://blog.realkinetic.com/using-google-cloud-service-accounts-on-gke-e0ca4b81b9a2
- https://www.the-swamp.info/blog/configuring-gcloud-multiple-projects/
- Google - 2-Step Verification. Enable two-factor authentication in your Google account.

Login to GCP using gcloud:

```bash
gcloud init

# The default browser will open to complete the login and grant the permissions.
gcloud auth application-default login
```

# Go

Run the following commands to install Go.

Documentation: https://go.dev/doc/

```bash
VERSION=1.27.1

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

Source: https://go.dev/doc/install

# Helm

Run the following commands to install helm:

> Before continuing, if you have helm installed via apt, remove it with the following commands:

```bash
sudo apt remove helm
# or
sudo rm /usr/local/bin/helm
sudo rm /etc/apt/sources.list.d/helm-stable-debian.list
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://helm.sh/docs/

```bash
VERSION="4.3.0"

mise ls-remote helm | tail
mise latest helm

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g helm@$VERSION
mise ls helm
```

> Helm 4 changed the plugin system: the plugins are verified by default and the ``--version`` flag of ``helm plugin install`` is not supported by some plugins. See the instructions of each plugin in the next sections.

# helm-docs

Run the following commands to install helm-docs.

> Before continuing, if you have helm-docs installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/helm-docs
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://github.com/norwoodj/helm-docs

```bash
VERSION="1.14.2"

mise ls-remote helm-docs | tail
mise latest helm-docs

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g helm-docs@$VERSION
mise ls helm-docs
```

The documentation generated by helm-docs is based on the content of the ``values.yaml`` and ``Chart.yaml`` files. It tries to overwrite the content of the ``README.md`` file inside the chart directory.

To avoid this problem, run the command ``helm-docs --dry-run`` (inside the directory of each chart) and manually copy the content shown in the standard output into the ``README.md`` file, avoiding data loss.

# helmfile

Run the following commands to install ``helmfile``.

> Before continuing, if you have helmfile installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/helmfile
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://github.com/helmfile/helmfile

```bash
VERSION="1.8.1"

mise ls-remote helmfile | tail
mise latest helmfile

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g helmfile@$VERSION
mise ls helmfile
```

# helm-diff - Plugin

Run the following commands to install the ``helm-diff`` plugin.

Documentation: https://github.com/databus23/helm-diff

With Helm 4 (the plugin provenance is verified by default):

```bash
VERSION="3.15.15"

curl -sL https://github.com/databus23.gpg | gpg --import
gpg --list-keys --with-fingerprint EA17A2A206AFF8CD
# Expected fingerprint: C5645EF4 7482257A 1F806D2B EA17A2A2 06AFF8CD
helm plugin install "https://github.com/databus23/helm-diff/releases/download/v${VERSION}/helm-diff-linux-amd64.tgz"
```

With Helm 3:

```bash
helm plugin install https://github.com/databus23/helm-diff --version v3.15.15
```

# helm-secrets - Plugin

Run the following commands to install the ``helm-secrets`` plugin.

Documentation: https://github.com/jkroepke/helm-secrets/wiki/Installation

With Helm 4 the plugin is distributed as three plugins and the plugin signature is verified by default (public key: https://github.com/jkroepke.gpg):

```bash
VERSION="4.7.8"

helm plugin install "https://github.com/jkroepke/helm-secrets/releases/download/v${VERSION}/secrets-${VERSION}.tgz"
helm plugin install "https://github.com/jkroepke/helm-secrets/releases/download/v${VERSION}/secrets-getter-${VERSION}.tgz"
helm plugin install "https://github.com/jkroepke/helm-secrets/releases/download/v${VERSION}/secrets-post-renderer-${VERSION}.tgz"
```

With Helm 3:

```bash
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.7.8
```

# jj

Command line utility to edit JSON files.

Documentation: https://github.com/tidwall/jj

Install with the following commands:

```bash
sudo su
JJ_VERSION="1.9.2"
JJ_URL="https://github.com/tidwall/jj/releases/download/v${JJ_VERSION}/jj-${JJ_VERSION}-linux-amd64.tar.gz"
JJ_TAR_DIR="jj-${JJ_VERSION}-linux-amd64"

wget ${JJ_URL} -O /tmp/${JJ_TAR_DIR}.tar.gz
tar -C /tmp -xvzf /tmp/${JJ_TAR_DIR}.tar.gz
mv /tmp/${JJ_TAR_DIR}/jj /usr/local/bin/jj
rm -rf /tmp/${JJ_TAR_DIR}*

jj --version

exit
```

# kubectl

Run the following commands.

Documentation: https://kubernetes.io/docs/reference/kubectl/

```bash
VERSION_OPTION_1="1.37.1"

mise ls-remote kubectl | tail
mise latest kubectl

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g kubectl@$VERSION_OPTION_1
mise ls kubectl
```

> Use a kubectl version within one minor version (older or newer) of the Kubernetes cluster version. More info: https://kubernetes.io/releases/version-skew-policy/#kubectl

# Plugins for kubectl

Some useful plugins for kubectl are listed below.

## krew

Documentation:
- https://github.com/kubernetes-sigs/krew/
- https://krew.sigs.k8s.io/docs/user-guide/setup/install/

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

## kubectx and kubens

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

Useful commands:

```bash
kubectx -u # to unset the current context (disconnect from the cluster)
kubectx # to list the clusters registered on the local machine
kubectx CLUSTER_NAME # to switch to a cluster previously registered on the local machine
kubectx -d CLUSTER_NAME # to remove a cluster previously registered on the local machine
kubens # to list the namespaces of a cluster
kubens NAMESPACE # to switch to a namespace previously created in the cluster with the command ``kubectl create ns NAMESPACE``
```

## Fuzzy

Documentation: https://github.com/junegunn/fzf

Install with the following command:

```bash
sudo apt install fzf
```

> Just open another terminal to make it work together with kubectx and kubens

## kubectl-tree

Documentation: https://github.com/ahmetb/kubectl-tree

Install with the following command:

```bash
kubectl krew install tree
```

## kubecolor

Documentation: https://github.com/kubecolor/kubecolor

Install with the following commands.

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION_KUBECOLOR=0.8.0

mise ls-remote kubecolor | tail
mise latest kubecolor

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g kubecolor@$VERSION_KUBECOLOR
mise ls kubecolor

# Changing the kubectl alias to kubecolor
alias kubectl="kubecolor"
echo "alias kubectl=\"kubecolor\"" >> ~/.bashrc
source ~/.bashrc
```

## node-shell

Plugin to start a root shell in a k8s node.

Install with the following command:

```bash
kubectl krew install node-shell
```

Documentation: https://github.com/kvaps/kubectl-node-shell

## kubefwd

Documentation:
- https://github.com/txn2/kubefwd
- https://imti.co/kubernetes-port-forwarding
- https://kubefwd.com

Install with the following commands:

```bash
VERSION=1.25.16

wget https://github.com/txn2/kubefwd/releases/download/v$VERSION/kubefwd_amd64.deb
sudo dpkg -i kubefwd_amd64.deb
rm kubefwd_amd64.deb

kubefwd version
```

## kubepug

The following software helps to identify which APIs were changed/deprecated in each k8s version.

Documentation: https://github.com/kubepug/kubepug

Install with the following commands:

```bash
VERSION=v1.7.1

cd /tmp
wget https://github.com/kubepug/kubepug/releases/download/$VERSION/kubepug_linux_amd64.tar.gz
tar xzvf kubepug_linux_amd64.tar.gz
sudo mv kubepug /usr/local/bin/
rm kubepug_linux_amd64.tar.gz

kubepug version
```

## kubent

Documentation: https://github.com/doitintl/kube-no-trouble

```bash
sh -c "$(curl -sSL https://git.io/install-kubent)"
kubent --help
```

## Other Kubetools

- http://dockerlabs.collabnix.com/kubernetes/kubetools/
- https://caylent.com/50-useful-kubernetes-tools
- https://caylent.com/50+-useful-kubernetes-tools-list-part-2
- https://developer.sh/posts/kubernetes-client-tools-overview
- https://github.com/kubernetes-sigs/kind
- https://github.com/k3d-io/k3d
- https://microk8s.io/
- https://argo-cd.readthedocs.io/en/stable/

# kubeshark

Kubeshark (formerly Mizu) is an observability tool.

kubeshark is an intrusive tool, which adds agents to the nodes that run the pods selected for monitoring (tap). This kind of tool certainly has a computational cost. Use it sparingly, filtering as much as possible (see the documentation for the available filters).

Documentation: https://kubeshark.co/

> Before continuing, if you have kubeshark installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/kubeshark
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="72.3.83"

mise ls-remote kubeshark | tail
mise latest kubeshark

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g kubeshark@$VERSION
mise ls kubeshark
```

# k9s

k9s is a CLI tool to manage Kubernetes clusters.

> Before continuing, if you have k9s installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/k9s
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://k9scli.io/topics/commands/

```bash
VERSION="0.51.0"

mise ls-remote k9s | tail
mise latest k9s

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g k9s@$VERSION
mise ls k9s
```

# kustomize

Kustomize provides a way to apply changes to Kubernetes as an alternative to the work done by Helm. kustomize is integrated with kubectl through the subcommand ``apply -k``.

> Before continuing, if you have kustomize installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/kustomize
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://kubectl.docs.kubernetes.io/references/kustomize/

```bash
VERSION="5.8.2"

mise ls-remote kustomize | tail
mise latest kustomize

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g kustomize@$VERSION
mise ls kustomize
```

# lens

Lens is an IDE to control your Kubernetes clusters.

Install Lens Desktop using the APT repository with the following commands:

```bash
curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | sudo tee /etc/apt/sources.list.d/lens.list > /dev/null
sudo apt update
sudo apt install -y lens
```

More information at:
- https://k8slens.dev/
- https://docs.k8slens.dev/getting-started/install-lens/

# Postman

Run the following command:

```bash
sudo snap install postman
```

Documentation:
- https://linuxize.com/post/how-to-install-postman-on-ubuntu-20-04/
- https://www.postman.com

# pre-commit

A framework for managing and maintaining multi-language pre-commit hooks. https://pre-commit.com/

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="4.6.2"

mise ls-remote pre-commit | tail
mise latest pre-commit

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g pre-commit@$VERSION
mise ls pre-commit
```

Source: https://mise.jdx.dev/getting-started.html

# Custom Terminal Prompt

To show the branch name, the current directory, the authenticated k8s cluster and the namespace in use, there are several open source projects that provide this, and you can choose the one you like the most.

For zsh:
- https://ohmyz.sh/
- https://www.2vcps.io/2020/07/02/oh-my-zsh-fix-my-command-prompt/

For bash:
- https://github.com/ohmybash/oh-my-bash
- https://github.com/jonmosco/kube-ps1

## bash_prompt

```bash
curl -o ~/.bash_prompt https://gist.githubusercontent.com/aeciopires/6738c602e2d6832555d32df78aa3b9bb/raw/b96be4dcaee6db07690472aecbf73fcf953a7e91/.bash_prompt
chmod +x ~/.bash_prompt
echo "source ~/.bash_prompt" >> ~/.bashrc
source ~/.bashrc
exec bash
```

Result:

1. **lilac (or purple) color**: the user name and the host name;
2. **yellow color**: the path of the current directory;
3. **green color**: the branch name, shown only if the current directory is related to a git repository;
4. **red color**: the name of the Kubernetes (k8s) cluster you are authenticated to;
5. **blue color**: the name of the namespace selected in the k8s cluster. If the default namespace is selected, the name will not be shown.

# qq

qq is an interoperable configuration format transcoder with jq query syntax powered by gojq. qq is multi modal, and can be used as a replacement for jq or be interacted with via a repl with autocomplete and realtime rendering preview for building queries.

Documentation: https://github.com/JFryy/qq

Run the following commands to install qq:

```bash
VERSION="v0.4.0"
cd /tmp
wget -O qq.tar.gz "https://github.com/JFryy/qq/releases/download/${VERSION}/qq-${VERSION}-linux-amd64.tar.gz"
tar xzvf qq.tar.gz qq
sudo mv qq /usr/local/bin/qq
sudo chmod +x /usr/local/bin/qq
rm qq.tar.gz
qq --version
```

Examples:

```bash
qq a.json -o hcl
qq b.hcl -o json
qq b.hcl -o yaml
qq b.hcl -o xml
qq b.hcl -o toml
qq b.hcl -o tf
qq a.json -o tf
```

# ShellCheck

Run the following commands:

> Before continuing, if you have shellcheck installed, remove it with the following command:

```bash
sudo rm /usr/bin/shellcheck
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="0.11.0"

mise ls-remote shellcheck | tail
mise latest shellcheck

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g shellcheck@$VERSION
mise ls shellcheck
```

Documentation: https://github.com/koalaman/shellcheck/

Alternatively, you can use the website https://www.shellcheck.net to lint shell scripts.

# Sops

Install with the following commands.

Documentation: https://github.com/getsops/sops/

> Before continuing, if you have sops installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/sops
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="3.13.3"

mise ls-remote sops | tail
mise latest sops

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g sops@$VERSION
mise ls sops

sops --version
```

An example of the sops configuration file that should be in ``$HOME/.sops.yaml``.

```yaml
creation_rules:
# For testing/staging environments
-   path_regex: .*/testing|staging/.*
    kms: arn:aws:kms:us-east-1:4564546546454:key/adsfasdfd-8c6c-sdfsadfdas
    aws_profile: default
# For production environments
-   kms: arn:aws:kms:sa-east-1:4123745646545:key/asdfsdfdsa-8a5b-sdafasdf
    aws_profile: default
```

# terraform

Install Terraform with mise.

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://developer.hashicorp.com/terraform

```bash
VERSION="1.16.5"

mise ls-remote terraform | tail
mise latest terraform

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g terraform@$VERSION
mise ls terraform

terraform version
```

To uninstall a version of terraform, use the following command:

```bash
mise uninstall terraform@<VERSION>
```

Only when developing code that uses terraform, you can force the project to use a specific version with the ``mise.toml`` file in the root of the project. Example:

```bash
cd PROJECT_DIRECTORY
mise use terraform@1.16.5

cat mise.toml
[tools]
terraform = "1.16.5"
```

> The ``aws_services/live`` and ``gcp_services/live`` directories of this repository have a ``mise.toml`` file with the versions of terraform and terragrunt. Run ``mise trust`` and ``mise install`` inside these directories.

# terraform-docs

Run the following commands to install terraform-docs

Documentation: https://github.com/terraform-docs/terraform-docs

```bash
VERSION=v0.24.0

curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$VERSION/terraform-docs-$VERSION-$(uname | tr '[:upper:]' '[:lower:]')-amd64.tar.gz
tar -xzf terraform-docs.tar.gz terraform-docs
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin/terraform-docs

rm terraform-docs.tar.gz
terraform-docs --version
```

# terragrunt

Install Terragrunt with mise (installation method documented by Terragrunt).

> Before proceeding, make sure you have installed the [mise](#mise) command.

Documentation: https://docs.terragrunt.com/getting-started/install/

```bash
VERSION="1.1.6"

mise ls-remote terragrunt | tail
mise latest terragrunt

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g terragrunt@$VERSION
mise ls terragrunt

terragrunt --version
```

To uninstall a version of terragrunt, use the following command:

```bash
mise uninstall terragrunt@<VERSION>
```

Only when developing code that uses terragrunt, you can force the project to use a specific version with the ``mise.toml`` file in the root of the project. Example:

```bash
cd PROJECT_DIRECTORY
mise use terragrunt@1.1.6

cat mise.toml
[tools]
terragrunt = "1.1.6"
```

> Terragrunt 1.0 changed the CLI. For example, ``terragrunt run-all plan`` was replaced by ``terragrunt run --all plan``. More info: https://docs.terragrunt.com/migrate/cli-redesign/

# vault-cli

Command line utility of Hashicorp Vault: https://developer.hashicorp.com/vault

> Before continuing, if you have vault installed, remove it with the following commands:

```bash
sudo apt remove vault
# or
sudo rm /usr/bin/vault
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="2.1.1"

mise ls-remote vault | tail
mise latest vault

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g vault@$VERSION
mise ls vault
```

Source: https://mise.jdx.dev/getting-started.html

# yq

Command line utility to edit YAML files: https://github.com/mikefarah/yq

> Before continuing, if you have yq installed, remove it with the following commands:

```bash
sudo apt remove yq
# or
sudo rm /usr/bin/yq
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
YQ_1="3.4.1"   # approved
YQ_2="4.35.1"  # approved
YQ_3="4.54.1"

mise ls-remote yq | tail
mise latest yq
mise install yq@$YQ_1 yq@$YQ_2

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g yq@$YQ_3
mise ls yq
```

Source: https://mise.jdx.dev/getting-started.html

# tig

Text-mode interface for git: https://jonas.github.io/tig/

```bash
sudo apt-get install -y tig
```

# ec2-instance-selector

A CLI tool that recommends instance types based on resource criteria like vcpus and memory.

Documentation: https://github.com/aws/amazon-ec2-instance-selector

```bash
VERSION=v3.1.3
sudo curl -Lo /usr/local/bin/ec2-instance-selector https://github.com/aws/amazon-ec2-instance-selector/releases/download/${VERSION}/ec2-instance-selector-`uname | tr '[:upper:]' '[:lower:]'`-amd64
sudo chmod +x /usr/local/bin/ec2-instance-selector
ec2-instance-selector --help
```

# [OPTIONAL] Useful aliases

## bashrc

Useful aliases to be added to the file ``$HOME/.bashrc``.

> After adding them, run the command ``source ~/.bashrc`` to apply the changes.

```bash
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias aws_docker='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli:2.37.9'
alias bat='bat --theme ansi'
alias connect_eks='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias k='kubecolor'
source <(kubectl completion bash)
export PATH="${PATH}:${HOME}/.krew/bin"
alias kubectl='kubecolor'
alias kmongo='kubectl run --rm -it mongoshell-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mongo:4.0.28 -n default -- bash'
alias kmysql5='kubectl run --rm -it mysql5-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mysql:5.7 -n default -- bash'
alias kmysql8='kubectl run --rm -it mysql8-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mysql:8.0 -n default -- bash'
alias kredis='kubectl run --rm -it redis-cli-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=redis:latest -n default -- bash'
alias kpgsql14='kubectl run --rm -it pgsql14-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=postgres:14 -n default -- bash'
alias kssh='kubectl run --rm -it ssh-agent-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=kroniak/ssh-client -n default -- bash'
alias l='ls -CF'
alias la='ls -A'
alias live='curl parrot.live'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias nettools='kubectl run --rm -it nettools-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=aeciopires/nettools:3.1.0 -n NAMESPACE /bin/bash'
alias randompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}'
alias randompass2='date +%s | sha3sum | base64 | head -c 12; echo'
# Ubuntu 22.04/24.04
alias set-dns-cabeado='sudo resolvectl dns enp7s0 1.1.1.1'
alias set-dns-wifi='sudo resolvectl dns wlp6s0 1.1.1.1'
alias show-hidden-files='du -sch .[!.]* * |sort -h'
alias ssm='aws ssm start-session --target CHANGE_EC2_ID --region CHANGE_REGION --profile CHANGE_PROFILE'
alias terradocs='terraform-docs markdown table . > README.md'
alias alertmanager='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE && kubectl port-forward alertmanager-monitor-alertmanager-0 9093:9093 -n monitoring ; kubectx -'
alias prometheus='kubectl port-forward prometheus-monitor-prometheus-0 9090:9090 -n monitoring'
alias sc="source $HOME/.bashrc"
alias python=python3
alias pip=pip3
alias kind_create="kind create cluster --name kind-multinodes --config $HOME/kind-3nodes.yaml"
alias kind_delete="kind delete clusters \$(kind get clusters)"
```

# [OPTIONAL] Clipboard Indicator

- https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator

# [OPTIONAL] Flameshot

- https://flameshot.org/

Install with the following command:

```bash
sudo apt install -y flameshot
```

# [OPTIONAL] kind

kind (Kubernetes in Docker) is another alternative to run Kubernetes in a local environment for testing and learning, but it is not recommended for production use.

To install kind, run the following commands.

> Before continuing, if you have kind installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/kind
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="0.33.0"

mise ls-remote kind | tail
mise latest kind

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g kind@$VERSION
mise ls kind
```

To create a cluster with multiple local nodes with kind, create a YAML file to define the number and the type of nodes in the cluster that you want.

In the following example, the file ``$HOME/kind-3nodes.yaml`` will be created to specify a cluster with 1 control-plane node (which will run the Kubernetes control plane) and 2 workers (which will run the Kubernetes data plane).

```bash
cat << EOF > $HOME/kind-3nodes.yaml
# References:
# Kind release image: https://github.com/kubernetes-sigs/kind/releases
# Configuration: https://kind.sigs.k8s.io/docs/user/configuration/
# Metal LB in Kind: https://kind.sigs.k8s.io/docs/user/loadbalancer
# Ingress in Kind: https://kind.sigs.k8s.io/docs/user/ingress

# Config compatible with kind v0.33.0
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
nodes:
  - role: control-plane
    image: kindest/node:v1.37.0@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5
    kubeadmConfigPatches:
    - |
      kind: InitConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "nodeapp=loadbalancer"
    extraPortMappings:
    - containerPort: 80
      hostPort: 80
      listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
      protocol: TCP
  - role: worker
    image: kindest/node:v1.37.0@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5
  - role: worker
    image: kindest/node:v1.37.0@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5
EOF
```

> The image ``kindest/node:v1.37.0`` is the default node image of kind v0.33.0. The kubelet of this image does not start on hosts that use cgroup v1 (error: "kubelet is configured to not run on a host using cgroup v1"). Use a host with cgroup v2.

Create a cluster called ``kind-multinodes`` using the specifications defined in the file ``$HOME/kind-3nodes.yaml``.

```bash
kind create cluster --name kind-multinodes --config $HOME/kind-3nodes.yaml
```

To list your clusters created with kind, run the following command.

```bash
kind get clusters
```

To destroy the cluster, run the following command, which will select and remove all local clusters created with kind.

```bash
kind delete clusters $(kind get clusters)
```

References:
- https://github.com/badtuxx/DescomplicandoKubernetes/blob/master/day-1/DescomplicandoKubernetes-Day1.md#kind
- https://kind.sigs.k8s.io/docs/user/quick-start/
- https://github.com/kubernetes-sigs/kind/releases
- https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/#kind-kubernetes-made-easy-in-a-container

Alternative repository to use kind with nginx-controller, linkerd and other tools: https://github.com/rafaelperoco/kind

# [OPTIONAL] minikube

There are some scenarios (such as hybrid) where you need dedicated clusters agnostic to the cloud providers and with dedicated VMs. In this case, minikube is a good choice.

Documentation: https://minikube.sigs.k8s.io/docs/

Run the following commands to install it:

> Before continuing, if you have minikube installed, remove it with the following commands:

```bash
sudo apt remove minikube
# or
sudo rm /usr/bin/minikube
# or
sudo rm /usr/local/bin/minikube
```

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="1.39.0"

mise ls-remote minikube | tail
mise latest minikube

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g minikube@$VERSION
mise ls minikube
```

To start a cluster with 2 nodes using the version 1.37.0 of Kubernetes (the default version of minikube 1.39.0), you can use the following command:

> The default driver of minikube is docker.

```bash
minikube start --driver=docker --nodes 2 --profile multi-node --kubernetes-version=v1.37.0
```

To add a new node to the cluster, run:

```bash
minikube node add --worker --profile multi-node
```

To destroy the cluster, run the following command:

```bash
minikube delete --all
```

# [OPTIONAL] trivy

Installing trivy via mise

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="0.75.0"

mise ls-remote trivy | tail
mise latest trivy

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g trivy@$VERSION
mise ls trivy
```

## Installing trivy via Docker

To scan Docker images for vulnerabilities locally, before pushing them to Docker Hub, ECR, GCR or another remote registry, you can use trivy: https://github.com/aquasecurity/trivy

The documentation on GitHub shows how to install it on Ubuntu and other GNU/Linux distributions and/or other operating systems, but it is also possible to run it via Docker using the following commands:

```bash
mkdir /tmp/caches
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/caches:/root/.cache/ aquasec/trivy:0.75.0 image IMAGE_NAME:IMAGE_TAG
```

# [OPTIONAL] tflint

Installing tflint via mise

> Before proceeding, make sure you have installed the [mise](#mise) command.

```bash
VERSION="0.64.0"

mise ls-remote tflint | tail
mise latest tflint

# Installing and setting the default version (saved in ~/.config/mise/config.toml)
mise use -g tflint@$VERSION
mise ls tflint
```
