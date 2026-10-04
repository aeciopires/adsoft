<!-- TOC -->

- [MacOS](#macos)
  - [Homebrew](#homebrew)
  - [Essentials](#essentials)
- [Git](#git)
- [mise](#mise)
- [awscli](#awscli)
- [bat](#bat)
- [dbeaver (Database client)](#dbeaver-database-client)
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
- [Kustomize](#kustomize)
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
- [Vault](#vault)
- [yq](#yq)
- [tig](#tig)
- [\[OPTIONAL\] Useful aliases](#optional-useful-aliases)
  - [bashrc](#bashrc)
- [\[OPTIONAL\] Lightshot](#optional-lightshot)
- [\[OPTIONAL\] kind](#optional-kind)
- [\[OPTIONAL\] minikube](#optional-minikube)
- [\[OPTIONAL\] trivy](#optional-trivy)
  - [Installing trivy via Docker](#installing-trivy-via-docker)
- [\[OPTIONAL\] tflint](#optional-tflint)

<!-- TOC -->

# MacOS

## Homebrew

Install Homebrew with the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "/Users/$USER/.bash_profile"

eval "$(/opt/homebrew/bin/brew shellenv)"
```

Source: https://brew.sh/

## Essentials

Run the following commands:

```bash
# Rosetta 2 is required to run x86_64 applications on Apple silicon
softwareupdate --install-rosetta --agree-to-license

brew install vim tcptraceroute telnet netcat git tcpdump elinks curl wget openssl net-tools python3 meld openjdk jq make gnupg coreutils visual-studio-code

echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> "/Users/$USER/.bash_profile"

export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> "/Users/$USER/.bash_profile"

export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

echo 'export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"' >> "/Users/$USER/.bash_profile"

export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

alias python=python3
alias pip=pip3
```

Install python3-pip following the instructions of the page: https://docs.brew.sh/Homebrew-and-Python

Install the following software:

- Google Chrome: https://support.google.com/chrome/answer/95346?hl=en&co=GENIE.Platform%3DDesktop#zippy=%2Cmac
- WPS: https://www.wps.com/
- LightShot: https://app.prntscr.com/en/download.html
- Visual Code: https://code.visualstudio.com
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

Install mise with the official installer (recommended by the mise documentation) and add the activation to ``$HOME/.bash_profile``:

```bash
curl -fsSL https://mise.run | sh

echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bash_profile
source ~/.bash_profile

mise --version

# Installing the bash completion
mise completion bash --install
```

> Alternatively, install mise with Homebrew: ``brew install mise``. In this case, add the activation with the command: ``echo 'eval "$(mise activate bash)"' >> ~/.bash_profile``.

> The default shell of macOS Catalina or newer is ZSH. If you use ZSH, follow the instructions for ZSH in https://mise.jdx.dev/installing-mise.html

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

> If you are migrating from asdf: mise reads the ``.tool-versions`` files of asdf, but this repository uses ``mise.toml`` files. After installing the tools with mise, remove the asdf lines from ``$HOME/.bash_profile`` (``. /opt/homebrew/opt/asdf/libexec/asdf.sh`` or ``export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"``) to avoid conflicts between the shims of asdf and mise.

Source:
- https://mise.jdx.dev/installing-mise.html
- https://mise.jdx.dev/getting-started.html
- https://mise.jdx.dev/configuration.html

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

# dbeaver (Database client)

DBeaver is a free multi-platform database tool. It supports all popular SQL databases like MySQL, MariaDB, PostgreSQL, SQLite, Apache Family and more.

Install with the following command:

```bash
brew install --cask dbeaver-community
```

More information: https://dbeaver.io/download/

# docker

More information on the page: https://docs.docker.com/desktop/setup/install/mac-install/

Install Docker Desktop with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install --cask docker
```

# docker compose

Documentation: https://docs.docker.com/compose/

Docker Compose v2 is included in Docker Desktop. Use the command ``docker compose`` (with a space) instead of ``docker-compose``. The standalone ``docker-compose`` v1 is no longer supported.

```bash
docker compose version
```

Source: https://docs.docker.com/compose/install/

# gcloud

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install google-cloud-sdk
gcloud components install gke-gcloud-auth-plugin
```

Follow the instructions in this section to authenticate with gcloud, which is also used by terraform/terragrunt in GCP.

References:
- https://cloud.google.com/sdk/docs/install
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

Run the following command to install Go.

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install go
```

Documentation: https://go.dev/doc/

# Helm

Run the following commands to install helm:

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

With Helm 4 (the plugin provenance is verified by default). Use ``helm-diff-macos-amd64.tgz`` on Intel Macs:

```bash
VERSION="3.15.15"

curl -sL https://github.com/databus23.gpg | gpg --import
gpg --list-keys --with-fingerprint EA17A2A206AFF8CD
# Expected fingerprint: C5645EF4 7482257A 1F806D2B EA17A2A2 06AFF8CD
helm plugin install "https://github.com/databus23/helm-diff/releases/download/v${VERSION}/helm-diff-macos-arm64.tgz"
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

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install tidwall/jj/jj
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

# Kustomize

Install Kustomize with the following command:

```bash
brew install kustomize
```

Reference:

- https://kustomize.io

# Plugins for kubectl

Some useful plugins for kubectl are listed below.

## krew

Documentation:
- https://github.com/kubernetes-sigs/krew/
- https://krew.sigs.k8s.io/docs/user-guide/setup/install/

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install krew
```

## kubectx and kubens

Documentation: https://github.com/ahmetb/kubectx#installation

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install kubectx
```

> This package also installs kubens on MacOS

Useful commands:

```bash
kubectx -u # to unset the current context (disconnect from the cluster)
kubectx # to list the clusters registered on the local machine
kubectx CLUSTER_NAME # to switch to a cluster previously registered on the local machine
kubectx -d CLUSTER_NAME # to remove a cluster previously registered on the local machine
kubens # to list the namespaces of a cluster
kubens NAMESPACE # to switch to a namespace previously created in the cluster with the command kubectl create ns NAMESPACE
```

## Fuzzy

Documentation: https://github.com/junegunn/fzf

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install fzf
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

Install with the following commands:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install kubecolor

alias k=kubecolor
alias kubectl=kubecolor

# Changing the kubectl alias to kubecolor
echo "alias kubectl=\"kubecolor\"" >> ~/.bash_profile
echo "alias k=\"kubecolor\"" >> ~/.bash_profile
```

> If you previously installed kubecolor from a tap (for example ``hidetatz/tap/kubecolor`` or ``kubecolor/tap/kubecolor``), uninstall it first. More info: https://kubecolor.github.io/setup/install/

## node-shell

Plugin to start a root shell in a k8s node.

Install with the following commands:

```bash
kubectl krew install node-shell

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /Users/$USER/.bash_profile
```

Documentation: https://github.com/kvaps/kubectl-node-shell

## kubefwd

Documentation:
- https://github.com/txn2/kubefwd
- https://imti.co/kubernetes-port-forwarding
- https://kubefwd.com

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install kubefwd
```

## kubepug

Helps to identify which APIs were changed/deprecated in each k8s version.

Documentation: https://github.com/kubepug/kubepug

Install with the following command:

```bash
kubectl krew install deprecations
kubectl deprecations --help
```

## kubent

Documentation: https://github.com/doitintl/kube-no-trouble

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install kubent
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

# lens

Lens is an IDE to control your Kubernetes clusters.

Install Lens with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install --cask lens
```

More information at: https://k8slens.dev/

# Postman

Run the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install --cask postman
```

Documentation:
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
- https://github.com/jonmosco/kube-ps1

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

## bash_prompt

```bash
curl -o ~/.bash_prompt https://gist.githubusercontent.com/aeciopires/6738c602e2d6832555d32df78aa3b9bb/raw/b96be4dcaee6db07690472aecbf73fcf953a7e91/.bash_prompt
chmod +x ~/.bash_prompt
echo "source ~/.bash_prompt" >> ~/.bashrc
source ~/.bashrc
exec /bin/bash
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

Run the following command to install qq:

```bash
brew install jfryy/tap/qq
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

Run the following command to install terraform-docs

Documentation: https://github.com/terraform-docs/terraform-docs

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install terraform-docs
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

# Vault

Install the Vault binary with the following commands:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/vault
```

More information at: https://developer.hashicorp.com/vault/docs

# yq

Command line utility to edit YAML files: https://github.com/mikefarah/yq

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

Install with the following command:

> Before proceeding, make sure you have installed the [Homebrew](#homebrew) command.

```bash
brew install tig
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
alias randompass='pwgen 16 1'
alias randompass2='date +%s | sha3sum | base64 | head -c 12; echo'
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
alias kubepug="kubectl deprecations"
```

# [OPTIONAL] Lightshot

Install the lightshot tool to make print screen (screen capture) easier.

- https://app.prntscr.com/en/download.html

# [OPTIONAL] kind

kind (Kubernetes in Docker) is another alternative to run Kubernetes in a local environment for testing and learning, but it is not recommended for production use.

To install kind, run the following commands.

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

The documentation on GitHub shows how to install it on MacOS, GNU/Linux distributions and other operating systems, but it is also possible to run it via Docker using the following commands:

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
