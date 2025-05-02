<!-- TOC -->

- [Ubuntu](#ubuntu)
  - [Essenciais](#essenciais)
  - [Opcionais](#opcionais)
- [Git](#git)
- [asdf](#asdf)
- [ansible](#ansible)
- [awscli](#awscli)
- [bat](#bat)
- [docker](#docker)
- [docker-compose](#docker-compose)
- [gcloud](#gcloud)
- [Go](#go)
- [Helm](#helm)
- [helm-docs](#helm-docs)
- [helmfile](#helmfile)
- [helm-diff - Plugin](#helm-diff---plugin)
- [helm-secrets - Plugin](#helm-secrets---plugin)
- [jj](#jj)
- [kubectl](#kubectl)
- [Plugins para kubectl](#plugins-para-kubectl)
  - [krew](#krew)
  - [kubectx e kubens](#kubectx-e-kubens)
  - [Fuzzy](#fuzzy)
  - [kubectl-tree](#kubectl-tree)
  - [kubecolor](#kubecolor)
  - [node-shell](#node-shell)
  - [kubefwd](#kubefwd)
  - [kubepug](#kubepug)
  - [kubent](#kubent)
  - [Outras Kubetools](#outras-kubetools)
- [kubeshark](#kubeshark)
- [k9s](#k9s)
- [kustomize](#kustomize)
- [lens](#lens)
- [Postman](#postman)
- [pre-commit](#pre-commit)
- [Prompt do Terminal Customizado](#prompt-do-terminal-customizado)
  - [bash\_prompt](#bash_prompt)
- [qq](#qq)
- [ShellCheck](#shellcheck)
- [Sops](#sops)
- [terraform e tfenv](#terraform-e-tfenv)
- [terraform-docs](#terraform-docs)
- [terragrunt e tgenv](#terragrunt-e-tgenv)
  - [Problema conhecido](#problema-conhecido)
- [vault-cli](#vault-cli)
- [yq](#yq)
- [tig](#tig)
- [ec2-instance-selector](#ec2-instance-selector)
- [\[OPCIONAL\] Aliases úteis](#opcional-aliases-úteis)
  - [bashrc](#bashrc)
- [\[OPCIONAL\] Clipboard Indicator](#opcional-clipboard-indicator)
- [\[OPCIONAL\] Flameshot](#opcional-flameshot)
- [\[OPCIONAL\] kind](#opcional-kind)
- [\[OPCIONAL\] minikube](#opcional-minikube)
- [\[OPCIONAL\] trivy](#opcional-trivy)
  - [Instalando trivy via Docker](#instalando-trivy-via-docker)
- [\[OPCIONAL\] tflint](#opcional-tflint)

<!-- TOC -->

# Ubuntu

## Essenciais

Execute os seguintes comandos no Ubuntu 24.04/22.02:

```bash
sudo apt install -y vim traceroute telnet netcat-openbsd git tcpdump elinks curl wget openssl net-tools python3 python3-pip meld python3-venv default-jdk jq make gnupg
```

Com o Python "3.10.*" execute o seguinte comando para criar o link simbólico:

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
```

Com o Python "3.12.*" execute o seguinte comando para criar o link simbólico:

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1
```

## Opcionais

Execute os seguintes comandos:

```bash
sudo apt install -y wireshark redis-tools mysql-client gimp
```

Instale os seguintes softwares:

- Firefox
- Google Chrome
- WPS: https://br.wps.com/download/
- Visual Code: https://code.visualstudio.com
  - Instalação no Ubuntu: https://code.visualstudio.com/docs/setup/linux
  - Plugins para Visual Code
  - Instruções para exportar/importar plugins do VSCode: https://stackoverflow.com/questions/35773299/how-can-you-export-the-visual-studio-code-extension-list
  - docker: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker (Requer instalação do comando docker mostrado nas seções a seguir).
  - gitlens: https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens (Requer instalação do comando git mostrado na seção a anterior).
  - go: https://marketplace.visualstudio.com/items?itemName=golang.Go (Requer instalação do comando go mostrado nas seções a seguir).
  - gotemplate-syntax: https://marketplace.visualstudio.com/items?itemName=casualjim.gotemplate
  - Markdown-all-in-one: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
  - Markdown-lint: https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint
  - Markdown-toc: https://marketplace.visualstudio.com/items?itemName=CharlesWan.markdown-toc
  - python: https://marketplace.visualstudio.com/items?itemName=ms-python.python (Requer instalação do comando python3 mostrado na seção anterior).
  - shellcheck: https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck (Requer instalação do comando shellcheck mostrado nas seções a seguir).
  - terraform: https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform (Requer instalação do comando terraform mostrado nas seções a seguir).
  - YAML: https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml
  - Helm Intellisense: https://marketplace.visualstudio.com/items?itemName=Tim-Koehler.helm-intellisense
  - Contar número de linhas selecionadas: https://marketplace.visualstudio.com/items?itemName=gurumukhi.selected-lines-count
  - jenkinsfile support: https://marketplace.visualstudio.com/items?itemName=ivory-lab.jenkinsfile-support
  - Theme for VSCode:
    - https://code.visualstudio.com/docs/getstarted/themes
    - https://dev.to/thegeoffstevens/50-vs-code-themes-for-2020-45cc
    - https://vscodethemes.com/

# Git

Crie o diretório ``~/git``.

```bash
mkdir ~/git
```

Baixe o script ``updateGit.sh``:

```bash
cd ~
wget https://gist.githubusercontent.com/aeciopires/2457cccebb9f30fe66ba1d67ae617ee9/raw/8d088c6fadb8a4397b5ff2c7d6a36980f46d40ae/updateGit.sh
chmod +x ~/updateGit.sh
```

Agora você pode clonar todos os repositórios git e salvar dentro de ``~/git``.

No início da jornada de trabalho diária atualize todos os repositórios git de uma só vez com o comando a seguir.

```bash
cd ~
./updateGit.sh git/
```

# asdf

Execute os seguintes comandos:

> Atenção!!! Para atualizar o asdf utilize APENAS o seguinte comando:

```bash
asdf update
```

> Se tentar reinstalar ou atualizar mudando a versão nos comandos seguintes, será necessário reinstalar todos os plugins/comandos instalados antes, por isso é muito importante fazer backup do diretório $HOME/.asdf.

```bash
ASDF_VERSION="v0.15.0"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION

# Adicionando no $HOME/.bashrc
echo ". \"\$HOME/.asdf/asdf.sh\"" >> ~/.bashrc
echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc
source ~/.bashrc
```

Fonte: https://asdf-vm.com/guide/introduction.html

# ansible

```bash
VERSION="9.13.0"

ASDF_PYAPP_INCLUDE_DEPS=1 asdf plugin add ansible https://github.com/amrox/asdf-pyapp.git
asdf latest ansible
asdf install ansible $VERSION
asdf global ansible $VERSION

ansible --version
```

# awscli

Instale o ``awscli`` usando o ``asdf``:

> Antes de continuar, se tiver o awscli instalado, remova-o com os seguintes comandos:

```bash
sudo rm /usr/local/bin/aws
sudo rm -rf /usr/local/aws-cli
# ou
sudo rm -rf /usr/local/aws
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
AWS_CLI_V2="2.27.6"

asdf plugin list all | grep aws
asdf plugin add awscli https://github.com/MetricMike/asdf-awscli.git
asdf latest awscli

asdf install awscli $AWS_CLI_V2
asdf list awscli

# Definindo a versão padrão
asdf global awscli $AWS_CLI_V2
asdf list awscli

# Criando um link simbólico
sudo ln -s $HOME/.asdf/shims/aws /usr/local/bin/aws
```

Fonte:
* https://asdf-vm.com/guide/introduction.html
- https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
* https://computingforgeeks.com/how-to-install-and-use-aws-cli-on-linux-ubuntu-debian-centos/

# bat

O bat é um binário que ajuda a destacar as diferenças entres arquivos e muito útil quando usado em conjunto com outros comandos, incluído o ``kubectl`` e o ``helm``.

> Antes de continuar, se tiver o bat instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/bin/bat
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="0.25.0"

asdf plugin list all | grep bat
asdf plugin add bat https://gitlab.com/wt0f/asdf-bat.git
asdf latest bat

asdf install bat $VERSION
asdf list bat

# Definindo a versão padrão
asdf global bat $VERSION
asdf list bat
```

Dica de utilização para terminais com temas escuro/claros é usar a opção ``--theme ansi``. Pode-se criar um alias, fazendo com que sempre que o comando for invocado, passe a utilizar esse parâmetro:

```bash
echo "alias bat='bat --theme ansi'" >> ~/.bashrc && . ~/.bashrc
```

Mais informações em: https://github.com/sharkdp/bat

# docker

Instale o Docker CE (Community Edition) seguindo as instruções da página: https://docs.docker.com/engine/install/ubuntu/.

```bash
sudo apt update
sudo apt install -y acl
curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
# Utilizando docker sem sudo
sudo usermod -aG docker $USER;
sudo setfacl -m user:$USER:rw /var/run/docker.sock
```

Fonte: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot

# docker-compose

Documentação: https://docs.docker.com/compose/

```bash
sudo su
COMPOSE_VERSION=1.29.2

sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

/usr/local/bin/docker-compose version

exit
```

# gcloud

> Antes de continuar, se tiver o gcloud instalado via apt, remova-o com os seguintes comandos:

```bash
sudo apt remove google-cloud-sdk
sudo rm /etc/apt/sources.list.d/google-cloud-sdk.list
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="520.0.0"

asdf plugin list all | grep gcloud
asdf plugin add gcloud https://github.com/jthegedus/asdf-gcloud.git
asdf latest gcloud

asdf install gcloud $VERSION
asdf list gcloud

# Definindo a versão padrão
asdf global gcloud $VERSION
asdf list gcloud

gcloud init # (alternativamente, gcloud init --console-only)
```

Execute as instruções deste tutorial se autenticar com o gcloud Autenticação do terraform/terragrunt no GCP

Se ao utilizar comandos do gcloud ocorrer o seguinte erro:
``ERROR: gcloud crashed (SystemError): ffi_prep_closure(): bad user_data (it seems that the version of the libffi library seen at runtime is different from the 'ffi.h' file seen at compile-time)``

Faça o seguinte para resolver no Ubuntu 20.04:

```bash
pip3 uninstall cffi xcffib
sudo apt install -y libffi-dev
```

Fonte: https://stackoverflow.com/questions/62658237/it-seems-that-the-version-of-the-libffi-library-seen-at-runtime-is-different-fro

Referências:
- https://cloud.google.com/sdk/install
- https://cloud.google.com/sdk/docs/downloads-apt-get
- https://cloud.google.com/docs/authentication/gcloud
- https://cloud.google.com/docs/authentication/getting-started
- https://console.cloud.google.com/apis/credentials/serviceaccountkey
- https://cloud.google.com/sdk/gcloud/reference/config/set
- https://code-maven.com/gcloud
- https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97
- https://blog.realkinetic.com/using-google-cloud-service-accounts-on-gke-e0ca4b81b9a2
- https://www.the-swamp.info/blog/configuring-gcloud-multiple-projects/
- Google - Autenticação em duas etapas. Habilite o duplo fator de autenticação na sua conta Google.

Login na GCP usando o gcloud:

```bash
gcloud init

# O navegador padrão será aberto para concluir o login e conceder as permissões.
gcloud auth application-default login
```

# Go

Execute os seguintes comandos para instalar o Go.

Documentação: https://golang.org/doc/

```bash
VERSION=1.24.2

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

# Helm

Execute os seguintes comandos para instalar o helm:

> Antes de continuar, se tiver o helm instalado via apt, remova-o com os seguintes comandos:

```bash
sudo apt remove helm
# ou
sudo rm /usr/local/bin/helm
sudo rm /etc/apt/sources.list.d/helm-stable-debian.list
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

Documentação: https://helm.sh/docs/

```bash
VERSION="3.17.3"

asdf plugin list all | grep helm
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf latest helm

asdf install helm $VERSION
asdf list helm

# Definindo a versão padrão
asdf global helm $VERSION
asdf list helm
```

# helm-docs

Execute os seguintes comandos para instalar o helm-docs.

> Antes de continuar, se tiver o helm-docs instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/helm-docs
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

Documentação: https://github.com/norwoodj/helm-docs 

```bash
VERSION="1.14.2"

asdf plugin list all | grep helm-docs
asdf plugin add helm-docs https://github.com/sudermanjr/asdf-helm-docs.git
asdf latest helm-docs

asdf install helm-docs $VERSION
asdf list helm-docs

# Definindo a versão padrão
asdf global helm-docs $VERSION
asdf list helm-docs
```

A documentação gerado pelo helm-docs é com base no conteúdo do arquivo ``values.yaml`` e ``Chart.yaml``. Ele tenta sobrescrever o conteúdo do arquivo ``README.md`` dentro do diretório do chart.

Para evitar este problema execute o comando ``helm-docs --dry-run`` (dentro do diretório de cada chart) e copie manualmente o conteúdo exibido na saída padrão para dentro do arquivo ``README.md``, evitando perda de dados.

# helmfile

Execute os seguintes comandos para instalar o ``helmfile``.

> Antes de continuar, se tiver o helmfile instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/helmfile
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

Documentação: https://github.com/helmfile/helmfile

```bash
VERSION="1.0.0"

asdf plugin list all | grep helmfile
asdf plugin add helmfile https://github.com/feniix/asdf-helmfile.git
asdf latest helmfile

asdf install helmfile $VERSION
asdf list helmfile

# Definindo a versão padrão
asdf global helmfile $VERSION
asdf list helmfile
```

# helm-diff - Plugin

Execute os seguintes comandos para instalar o plugin ``helm-diff``.

Documentação: https://github.com/databus23/helm-diff

```bash
helm plugin install https://github.com/databus23/helm-diff --version v3.11.0
```

# helm-secrets - Plugin

Execute os seguintes comandos para instalar o plugin ``helm-secrets``.

Documentação: https://github.com/jkroepke/helm-secrets

```bash
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.3
```

# jj

Utilitário de linha de comando para edição de arquivo JSON:

Documentação: https://github.com/tidwall/jj

Instale com os seguintes comandos:

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

Execute os seguintes comandos.

Documentação: https://kubernetes.io/docs/reference/kubectl/overview/

```bash
VERSION_OPTION_1="1.33.0"

asdf plugin list all | grep kubectl
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf latest kubectl

asdf install kubectl $VERSION_OPTION_1
asdf list kubectl

# Definindo a versão padrão
asdf global kubectl $VERSION_OPTION_1
asdf list kubectl

# Criando um link simbólico
sudo ln -s $HOME/.asdf/shims/kubectl /usr/local/bin/kubectl
```

# Plugins para kubectl

A seguir são listados alguns plugins úteis para o Kubectl.

## krew

Documentação:
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

## kubectx e kubens

Documentação: https://github.com/ahmetb/kubectx#installation

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

Comandos úteis:

```bash
kubectx -u # para deslogar do cluster
kubectx # para listar os clusters cadastrados na máquina local
kubectx NOME_DO_CLUSTER # para logar num cluster previamente cadastrado na máquina local
kubectx -d NOME_DO_CLUSTER # para remover um cluster previamente cadastrado na máquina local
kubens # para listar os namespaces de um cluster
kubens NAMESPACE # para mudar para um namespace previamente criado no cluster com o comando ``kubectl create ns NAMESPACE``
```

## Fuzzy

Documentação: https://github.com/junegunn/fzf

Instale com o seguinte comando:

```bash
sudo apt install fzf
```

> Basta abrir outro terminal para deixar funcionando em conjunto com kubectx e kubens

## kubectl-tree

Documentação: https://github.com/ahmetb/kubectl-tree

Instale com o seguinte comando:

```bash
kubectl krew install tree
```

## kubecolor

Documentação: https://github.com/kubecolor/kubecolor

Instale com os seguintes comandos.

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION_KUBECOLOR=0.5.1
asdf plugin list all | grep kubecolor
asdf plugin add kubecolor https://github.com/dex4er/asdf-kubecolor.git
asdf latest kubecolor

asdf install kubecolor $VERSION_KUBECOLOR

# Definindo a versão padrão
asdf global kubecolor $VERSION_KUBECOLOR
asdf list kubecolor

# Mudando o alias do kubectl para o kubecolor
alias kubectl="kubecolor"
echo "alias kubectl=\"kubecolor\"" >> ~/.bashrc 
source ~/.bashrc
```

## node-shell

Plugin para conectar ssh em um node k8s.

Instale com o seguinte comando:

```bash
kubectl krew install node-shell
```

Documentação: https://github.com/kvaps/kubectl-node-shell

## kubefwd

Documentação:
- https://github.com/txn2/kubefwd
- https://imti.co/kubernetes-port-forwarding
- https://kubefwd.com

Instale com os seguintes comandos:

```bash
VERSION=1.22.5

wget https://github.com/txn2/kubefwd/releases/download/$VERSION/kubefwd_amd64.deb
sudo dpkg -i kubefwd_amd64.deb
rm kubefwd_amd64.deb

kubefwd version
```

## kubepug

Os seguintes softwares ajudam a identificar quais APIs foram alteradas/depreciadas em cada versão do k8s.

Documentação: https://github.com/kubepug/kubepug

Instale com os seguintes comandos:

```bash
VERSION=v1.7.1

cd /tmp
wget https://github.com/rikatz/kubepug/releases/download/$VERSION/kubepug_linux_amd64.tar.gz
wget https://github.com/kubepug/kubepug/releases/download/$VERSION/kubepug_linux_amd64.tar.gz
tar xzvf kubepug_linux_amd64.tar.gz
sudo mv kubepug /usr/local/bin/
rm kubepug_linux_amd64.tar.gz

kubepug version
```

## kubent

Documentação: https://github.com/swade1987/deprek8ion

```bash
sh -c "$(curl -sSL https://git.io/install-kubent)"
kubent --help
```

## Outras Kubetools

- http://dockerlabs.collabnix.com/kubernetes/kubetools/
- https://caylent.com/50-useful-kubernetes-tools
- https://caylent.com/50+-useful-kubernetes-tools-list-part-2
- https://developer.sh/posts/kubernetes-client-tools-overview
- https://github.com/kubernetes-sigs/kind
- https://github.com/rancher/k3d
- https://microk8s.io/
- https://argoproj.github.io/argo-cd/

# kubeshark

Kubeshark (antigo Mizu) é uma ferramenta para observabilidade.

O kubeshark é uma ferramenta intrusiva, que adiciona agents nos nodes que suportam os pods selecionados para monitoramento (tap). Esse tipo de ferramenta, certamente tem um custo computacional. Devemos usar com parcimônia, filtrando o máximo possível (consulte a doc para ver os filtros disponíveis).

Documentação: https://kubeshark.co/

> Antes de continuar, se tiver o kubeshark instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/kubeshark
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="52.7.0"

asdf plugin list all | grep kubeshark
asdf plugin add kubeshark https://github.com/carnei-ro/asdf-kubeshark.git
asdf latest kubeshark

asdf install kubeshark $VERSION
asdf list kubeshark

# Definindo a versão padrão
asdf global kubeshark $VERSION
asdf list kubeshark
```

# k9s

O k9s é uma ferramenta em CLI para gerenciamento de cluster kubernetes.

> Antes de continuar, se tiver o k9s instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/k9s
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

Documentação: https://k9scli.io/topics/commands/

```bash
VERSION="0.50.4"

asdf plugin list all | grep k9s
asdf plugin add k9s https://github.com/looztra/asdf-k9s.git
asdf latest k9s

asdf install k9s $VERSION
asdf list k9s

# Definindo a versão padrão
asdf global k9s $VERSION
asdf list k9s
```

# kustomize

O Kustomize apresenta uma maneira de aplicar mudanças no Kubernetes alternativa ao trabalho realizado pelo Helm. O kustomize funciona integrado ao kubectl com o subcomando ``apply -k``.

> Antes de continuar, se tiver o kustomize instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/kustomize
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

Documentação: https://k9scli.io/topics/commands/

```bash
VERSION="5.6.0"

asdf plugin list all | grep kustomize
asdf plugin add kustomize https://github.com/Banno/asdf-kustomize.git
asdf latest kustomize

asdf install kustomize $VERSION
asdf list kustomize

# Definindo a versão padrão
asdf global kustomize $VERSION
asdf list kustomize
```

# lens

Lens é uma IDE para controlar seus clusters Kubernetes. É de código aberto e gratuito.

```bash
sudo snap install kontena-lens --classic
```

Mais informações em: https://k8slens.dev/

# Postman

Execute o seguinte comando:

```bash
sudo snap install postman
```

Documentação:
- https://linuxize.com/post/how-to-install-postman-on-ubuntu-20-04/
- https://www.postman.com

# pre-commit

Uma estrutura para gerenciar e manter ganchos de pré-confirmação multi linguagens. https://pre-commit.com/

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="4.2.0"

asdf plugin list all | grep pre-commit
asdf plugin add pre-commit https://github.com/jonathanmorley/asdf-pre-commit.git
asdf latest pre-commit
asdf install pre-commit $VERSION
asdf list pre-commit

# Definindo a versão padrão
asdf global pre-commit $VERSION
```

Fonte: https://asdf-vm.com/guide/introduction.html

# Prompt do Terminal Customizado

Para mostrar o nome da branch, diretório atual, cluster k8s autenticado e namespace em uso, existem vários projetos open source que providenciam isso e você pode escolher o que mais lhe agradar.

Para zsh:
- https://ohmyz.sh/
- https://www.2vcps.io/2020/07/02/oh-my-zsh-fix-my-command-prompt/

Para bash:
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

Resultado:

1. **cor lilás (ou roxo)**: o nome do usuário e o nome do host;
2. **Na cor amarela**: o path do diretório atual;
3. **cor verde**: o nome da branch, será exibida apenas se o diretório atual for relacionado a um repositório git;
4. **cor vermelho**: o nome do cluster Kubernetes (k8s), ao qual você está autenticado;
5. **cor azul**: o nome do namespace selecionado no cluster k8s. Caso esteja selecionado o namespace default, o nome não será exibido.

# qq

qq é um transcodificador de formato de configuração interoperável com sintaxe de consulta jq desenvolvido por gojq. qq é multimodal e pode ser usado como um substituto para jq ou interagir por meio de uma reposição com preenchimento automático e visualização de renderização em tempo real para construção de consultas.

Documentação: https://github.com/JFryy/qq

Execute os seguintes comandos para instalar o qq:

```bash
VERSION="v0.2.5"
cd /tmp
wget -O qq.tar.gz "https://github.com/JFryy/qq/releases/download/${VERSION}/qq-${VERSION}-linux-amd64.tar.gz"
tar xzvf qq.tar.gz
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

Execute os seguintes comandos:

> Antes de continuar, se tiver o shellcheck instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/bin/shellcheck
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="0.10.0"
asdf plugin list all | grep shellcheck
asdf plugin add shellcheck https://github.com/luizm/asdf-shellcheck.git
asdf latest shellcheck
asdf install shellcheck $VERSION
asdf list shellcheck

# Definindo a versão padrão
asdf global shellcheck $VERSION
```

Documentação: https://github.com/koalaman/shellcheck/

Alternativamente é possível usar o site https://www.shellcheck.net para fazer o lint dos shell scripts.

# Sops

Instale com os seguintes comandos.

Documentação: https://github.com/getsops/sops/

> Antes de continuar, se tiver o sops instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/sops
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="3.10.2"

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

Um exemplo do arquivo de configuração do sops que deve ficar em ``$HOME/.sops.yaml``.

```yaml
creation_rules:
# Para ambientes testing/staging
-   path_regex: .*/testing|staging/.*
    kms: arn:aws:kms:us-east-1:4564546546454:key/adsfasdfd-8c6c-sdfsadfdas
    aws_profile: default
# Para ambientes production
-   kms: arn:aws:kms:sa-east-1:4123745646545:key/asdfsdfdsa-8a5b-sdafasdf
    aws_profile: default
```

# terraform e tfenv

Execute os seguintes comandos para instalar o ``tfenv``, controlador de versões de do Terraform.

Documentação: https://github.com/tfutils/tfenv

```bash
cd $HOME
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

Liste versões que podem ser instaladas:

```bash
tfenv list-remote
```

Instale as seguintes versões do Terraform usando o tfenv:

```bash
tfenv install 1.11.4
```

Defina como padrão a seguinte versão:

```bash
tfenv use 1.11.4
```

Para desinstalar uma versão do terraform com o tfenv, use o seguinte comando:

```bash
tfenv uninstall <VERSAO>
```

Liste as versões instaladas:

```bash
tfenv list
```

Apenas no desenvolvimento de um código que faz uso do terraform, você pode obrigar o projeto a usar uma versão específica:

Crie o arquivo ``.terraform-version`` na raiz do projeto com o número da versão desejada. Exemplo:

```bash
cat .terraform-version
1.11.4
```

# terraform-docs

Execute os seguintes comandos para instalar o terraform-docs

Documentação: https://github.com/segmentio/terraform-docs

```bash
VERSION=v0.20.0

curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$VERSION/terraform-docs-$VERSION-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz terraform-docs
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin/terraform-docs

rm terraform-docs.tar.gz
terraform-docs --version
```

# terragrunt e tgenv

Execute os seguintes comandos para instalar o ``tgenv``, controlador de versões de do Terragrunt.

Documentação:
- https://github.com/cunymatthieu/tgenv
- https://blog.gruntwork.io/how-to-manage-multiple-versions-of-terragrunt-and-terraform-as-a-team-in-your-iac-project-da5b59209f2d

```bash
cd $HOME
git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
sudo ln -s ~/.tgenv/bin/* /usr/local/bin
```

## Problema conhecido

Existe um problema nas versões do tgenv em que versões muito antigas do terragrunt não são instaladas/listadas remotamente. Isso ocorre devido uma query utilizada no código https://github.com/cunymatthieu/tgenv/blob/master/libexec/tgenv-list-remote#L12 que usa API do GitHub. Para isso, temos dois possíveis workarounds

Workaround 3 (Fix proposto e revisado em PR em aberto):
https://github.com/cunymatthieu/tgenv/pull/15/files

Altere o arquivo ``~/.tgenv/libexec/tgenv-list-remote`` para que fique exatamente na seguinte forma, como abaixo:

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

Liste as versões que podem ser instaladas:

```bash
tgenv list-remote
```

Instale as seguintes versões do Terragrunt usando o tgenv:

```bash
tgenv install 0.77.2
```

Liste as versões instaladas:

```bash
tgenv list
```

Defina como padrão uma determinada versão:

```bash
tgenv use 0.77.2
```

Para desinstalar uma versão do terraform com o tfenv, use o seguinte comando:

```bash
tgenv uninstall <VERSAO>
```

Apenas no desenvolvimento de um código que faz uso do terragrunt, você pode obrigar o projeto a usar uma versão específica:

Crie o arquivo ``.terragrunt-version`` na raiz do projeto com o número da versão desejada. Exemplo:

```bash
cat .terragrunt-version
0.77.2
```

# vault-cli

Utilitário de linha de comando do Hashicorp Vault: https://developer.hashicorp.com/vault

> Antes de continuar, se tiver o yq instalado, remova-o com os seguintes comandos:

```bash
sudo apt remove vault
# ou
sudo rm /usr/bin/vault
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="1.19.3+ent"

asdf plugin list all | grep vault
asdf plugin add vault https://github.com/asdf-community/asdf-hashicorp.git
asdf latest vault

asdf install vault $VERSION
asdf list vault

# Definindo a versão padrão
asdf global vault $VERSION
asdf list vault
```

Fonte: https://asdf-vm.com/guide/introduction.html

# yq

Utilitário de linha de comando para edição de arquivos YAML: https://github.com/mikefarah/yq

> Antes de continuar, se tiver o yq instalado, remova-o com os seguintes comandos:

```bash
sudo apt remove yq
# ou
sudo rm /usr/bin/yq
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
YQ_1="3.4.1"   # homologada
YQ_2="4.35.1"  # homologada
YQ_3="4.45.1"

asdf plugin list all | grep yq
asdf plugin add yq https://github.com/sudermanjr/asdf-yq.git
asdf latest yq
asdf install yq $YQ_1
asdf install yq $YQ_2
asdf install yq $YQ_3
asdf list yq

# Definindo a versão padrão
asdf global yq $YQ_3
asdf list yq
```

Fonte: https://asdf-vm.com/guide/introduction.html

# tig

Utilitário em text-mode interface para git: https://jonas.github.io/tig/

```bash
sudo apt-get install -y tig
```

# ec2-instance-selector

Uma ferramenta CLI e que recomenda tipos de instância com base em critérios de recursos como vcpus e memória.

Documentação: https://github.com/aws/amazon-ec2-instance-selector

```bash
VERSION=v3.1.1
sudo curl -Lo /usr/local/bin/ec2-instance-selector https://github.com/aws/amazon-ec2-instance-selector/releases/download/${VERSION}/ec2-instance-selector-`uname | tr '[:upper:]' '[:lower:]'`-amd64
sudo chmod +x /usr/local/bin/ec2-instance-selector
ec2-instance-selector --help
```

# [OPCIONAL] Aliases úteis

## bashrc

Aliases úteis a serem cadastrados no arquivo ``$HOME/.bashrc``.

> Após a inclusão executar o comando ``source ~/.bashrc`` para refletir as alterações.

```bash
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias aws_docker='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws public.ecr.aws/aws-cli/aws-cli:2.22.28'
alias bat='bat --theme ansi'
alias connect_eks='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias k='kubectl'
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
alias nettools='kubectl run --rm -it nettools-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=aeciopires/nettools:2.1.0 -n NAMESPACE /bin/bash'
alias randompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}'
# Ubuntu 22.04/24.04
alias set-dns-cabeado='sudo resolvectl dns enp7s0 1.1.1.1'
alias set-dns-wifi='sudo resolvectl dns wlp6s0 1.1.1.1'
alias show-hidden-files='du -sch .[!.]* * |sort -h'
alias ssm='aws ssm start-session --target CHANGE_EC2_ID --region CHANGE_REGION --profile CHANGE_PROFILE'
alias terradocs='terraform-docs markdown table . > README.md'
alias alertmanager='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE && kubectl port-forward alertmanager-monitor-alertmanager-0 9093:9093 -n monitoring ; kubectx -'
alias prometheus='kubectl port-forward prometheus-monitor-prometheus-0 9090:9090 -n monitoring'
alias sc="source $HOME/.bashrc"
alias randompass='pwgen 16 1'
alias randompass2='date +%s | sha3sum | base64 | head -c 12; echo'
alias sc="source $HOME/.bashrc"
alias python=python3
alias pip=pip3
alias kubepug="kubectl-depreciations"
alias kind_create="kind create cluster --name kind-multinodes --config $HOME/kind-3nodes.yaml"
alias kind_delete="kind delete clusters \$(kind get clusters)"
```

# [OPCIONAL] Clipboard Indicator

- https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator

# [OPCIONAL] Flameshot

- https://flameshot.org/

Instale com o seguinte comando:

```bash
sudo apt install -y flameshot
```

# [OPCIONAL] kind

O kind (Kubernetes in Docker) é outra alternativa para executar o Kubernetes num ambiente local para testes e aprendizado, mas não é recomendado para uso em produção.

Para instalar o kind execute os seguintes comandos.

> Antes de continuar, se tiver o kind instalado, remova-o com o seguinte comando:

```bash
sudo rm /usr/local/bin/kind
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="0.27.0"
asdf plugin list all | grep kind
asdf plugin add kind https://github.com/johnlayton/asdf-kind.git
asdf latest kind
asdf install kind $VERSION
asdf list kind
# Definindo a versão padrão
asdf global kind $VERSION
```

Para criar um cluster com múltiplos nós locais com o Kind, crie um arquivo do tipo YAML para definir a quantidade e o tipo de nós no cluster que você deseja.

No exemplo a seguir, será criado o arquivo ``$HOME/kind-3nodes.yaml`` para especificar um cluster com 1 nó master (que executará o control plane do Kubernetes) e 2 workers (que executará o data plane do Kubernetes).

```bash
cat << EOF > $HOME/kind-3nodes.yaml
# References:
# Kind release image: https://github.com/kubernetes-sigs/kind/releases
# Configuration: https://kind.sigs.k8s.io/docs/user/configuration/
# Metal LB in Kind: https://kind.sigs.k8s.io/docs/user/loadbalancer
# Ingress in Kind: https://kind.sigs.k8s.io/docs/user/ingress

# Config compatible with kind v0.27.0
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
nodes:
  - role: control-plane
    image: kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f
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
    image: kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f
  - role: worker
    image: kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f
EOF
```

Crie um cluster chamado ``kind-multinodes`` utilizando as especificações definidas no arquivo ``$HOME/kind-3nodes.yaml``.

```bash
kind create cluster --name kind-multinodes --config $HOME/kind-3nodes.yaml
```

Para visualizar os seus clusters utilizando o kind, execute o comando a seguir.

```bash
kind get clusters
```

Para destruir o cluster, execute o seguinte comando que irá selecionar e remover todos os clusters locais criados no Kind.

```bash
kind delete clusters $(kind get clusters)
```

Referências:
- https://github.com/badtuxx/DescomplicandoKubernetes/blob/master/day-1/DescomplicandoKubernetes-Day1.md#kind
- https://kind.sigs.k8s.io/docs/user/quick-start/
- https://github.com/kubernetes-sigs/kind/releases
- https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/#kind-kubernetes-made-easy-in-a-container

Repositório alternativo para uso do kind com nginx-controller, linkerd e outras ferramentas: https://github.com/rafaelperoco/kind

# [OPCIONAL] minikube

Existem alguns cenários (como o híbrido) em que é necessário a utilização de cluster dedicados agnósticos às cloud providers e com a necessidade de VMs dedicadas. Nesse caso a utilização do minikube, é bem vinda.

Documentação: https://minikube.sigs.k8s.io/docs/

Execute os seguintes comandos para instalação:

> Antes de continuar, se tiver o minikube instalado, remova-o com os seguintes comandos:

```bash
sudo apt remove minikube
# ou
sudo rm /usr/bin/minikube
# ou
sudo rm /usr/local/bin/minikube
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="1.35.0"

asdf plugin list all | grep minikube
asdf plugin add minikube https://github.com/alvarobp/asdf-minikube.git
asdf latest minikube
asdf install minikube $VERSION
asdf list minikube

# Definindo a versão padrão
asdf global minikube $VERSION
asdf list minikube
```

Para iniciar um cluster com 2 nodes e utilizando a versão 1.30.2 do kubernetes, pode ser utilizado o seguinte comando:

> O driver default do minikube é o docker.

```bash
minikube start --driver=docker --nodes 2 --profile multi-node --kubernetes-version=v1.32.2
```

Para adicionar um novo node ao cluster execute:

```bash
minikube node add --worker --profile multi-node
```

Para destruir o cluster execute o seguinte comando:

```bash
minikube delete --all
```

# [OPCIONAL] trivy

Instalando trivy via asdf

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="0.62.0"

asdf plugin list all | grep trivy
asdf plugin add trivy https://github.com/zufardhiyaulhaq/asdf-trivy.git
asdf latest trivy

asdf install trivy $VERSION
asdf list trivy

# Definindo a versão padrão
asdf global trivy $VERSION
asdf list trivy
```

## Instalando trivy via Docker

Para realizar um scan de vulnerabilidades de imagens Docker localmente, antes de enviar para o Docker Hub, ECR, GCR ou outro registry remoto, você pode utilizar o trivy: https://github.com/aquasecurity/trivy

A documentação no GitHub apresenta as informações sobre a instalação no Ubuntu e outras distribuições GNU/Linux e/ou outros sistemas operacionais, mas também é possível executar via Docker utilizando os seguintes comandos:

```bash
mkdir /tmp/caches
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/caches:/root/.cache/ aquasec/trivy image IMAGE_NAME:IMAGE_TAG
```

# [OPCIONAL] tflint

Instalando tflint via asdf

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="0.56.0"

asdf plugin list all | grep tflint
asdf plugin add tflint https://github.com/skyzyx/asdf-tflint.git
asdf latest tflint

asdf install tflint $VERSION
asdf list tflint

# Definindo a versão padrão
asdf global tflint $VERSION
asdf list tflint
```
