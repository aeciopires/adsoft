# CLAUDE.md

This file gives guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About the repository

Examples of infrastructure as code (IaC) and tooling maintained by ADSoft (Aécio and Déo Software). There is no single build: each directory is an independent example. All content (code, comments and documentation) is written in English (en-US).

| Directory | Content |
| --- | --- |
| `app_python/` | Python app instrumented with `prometheus-client` (Docker + Docker Compose) |
| `app_nodejs/` | Contact list app: Node.js, Express 5, Mongoose 9, MongoDB 8.0 and AngularJS 1.8.3 front-end |
| `app_crud_api/` | CRUD REST API: Node.js, Express 5, Mongoose 9 and MongoDB 8.0 |
| `prometheus/install_prometheus-operator_k8s/` | `deploy.sh`/`lib.sh` to install the `kube-prometheus-stack` Helm chart with `helm secrets`, Helm values per cloud/environment/cluster in `helm_vars/`, exporter values and a Python 3 Elasticsearch exporter |
| `helm_apps/` | Argo CD (and a Zabbix `Application`) and HashiCorp Vault (chart values plus example deployments using the Vault Agent Injector) |
| `aws_services/live/` | Terragrunt code for AWS (VPC, EKS, EKS Blueprints addons, KMS, key pair, ACM, Route53, SES, EC2, ASG, ALB) |
| `gcp_services/live/` | Terragrunt code for GCP (shared VPC host project and a product project with GKE, Cloud SQL, KMS, buckets, Artifact Registry) |
| `softwares-ubuntu.md`, `softwares-macos.md` | Guides to install the tools used by the repository (referenced by `REQUIREMENTS.md`) |

## Conventions

- Write everything in English (en-US). Keep the Markdown TOC (`<!-- TOC -->` blocks) in sync with the headings.
- Versions must come from official sources (GitHub tags/releases of the project, the official Helm chart index, PyPI, npm, Docker Hub, `releases.hashicorp.com`, `dl.k8s.io`, official documentation). Do not guess versions, image tags, chart keys or module inputs: check them in the chart `values.yaml`, the module `variables.tf` or the upgrade guides (`docs/UPGRADE-*.md`, `docs/upgrading_to_*.md`) of the module repository.
- Tools are installed with [mise](https://mise.jdx.dev) (not asdf). Use `mise use -g TOOL@VERSION` for user defaults (saved in `~/.config/mise/config.toml`) and `mise.toml` files to pin versions per project (not `.tool-versions`, `.terraform-version` or `.terragrunt-version`). Check that a tool exists in the mise registry (`registry/` of https://github.com/jdx/mise) before using it: some names differ (`aws-cli`) or point to other projects (`jj` is Jujutsu, not tidwall/jj).
- Use `docker compose` (Compose v2 plugin). The Compose files do not have the obsolete `version` key.
- `softwares-macos.md` uses iTerm2, Zsh (`~/.zshrc`) with oh-my-zsh and the Spaceship theme, and Colima (not Docker Desktop) with the Homebrew `docker`, `docker-compose` and `docker-buildx` packages. `softwares-ubuntu.md` uses Bash (`~/.bashrc`). Both guides install Claude Code (`claude`).
- Do not commit `node_modules` (it is in `.gitignore`); commit the `package-lock.json` files, used by `npm ci` in the Dockerfiles.

## Pinned versions (where to change them)

- Terraform/Terragrunt: `aws_services/live/mise.toml` and `gcp_services/live/mise.toml` (Terraform 1.16.5, Terragrunt 1.1.6). Run `mise trust && mise install` in these directories.
- Terraform modules: the `source = "tfr:///...?version=X"` line of each template `.hcl` file (for example `vpc/vpc.hcl`, `eks/eks-1-36.hcl`).
- kube-prometheus-stack chart: `CHART_VERSION` in `prometheus/install_prometheus-operator_k8s/deploy.sh`.
- Argo CD chart: `helm_apps/argocd/README.md`. Zabbix chart: `targetRevision` in `helm_apps/argocd/zabbix/application.yaml`. Vault chart: `helm_apps/vault/README.md` (`values.yaml` is the chart default values plus the injector customizations).

## How to test

There is no CI in the repository (only `.codeac.yml` running tflint on `aws_services`). Validate changes with the commands below.

Sample apps (Docker required):

```bash
cd app_python && docker compose up --build      # app on :8002, metrics on :8001
cd app_nodejs && docker compose up --build      # app on :8080, API /api/contacts
cd app_crud_api && docker compose up --build    # API on :9000/api/cars
```

The apps read `MONGODB_URI` (default: the `db` service of the Compose file). To refresh a lock file after changing `package.json`, run `npm install` in `app_nodejs/lista-contatos` or `app_crud_api/crud`.

Shell scripts:

```bash
shellcheck -x prometheus/install_prometheus-operator_k8s/deploy.sh prometheus/install_prometheus-operator_k8s/lib.sh
```

Helm values (render without a cluster):

```bash
helm template monitor prometheus-community/kube-prometheus-stack --version 91.9.0 \
  -f prometheus/install_prometheus-operator_k8s/helm_vars/values.yaml \
  -f prometheus/install_prometheus-operator_k8s/helm_vars/aws/values.yaml \
  -f prometheus/install_prometheus-operator_k8s/helm_vars/aws/testing/mycluster3.yaml
```

Terragrunt code:

```bash
cd aws_services/live && terragrunt hcl fmt --check
cd aws_services/live/testing/regions/us-east-2/mycustomer/vpc/net-gyr4 && terragrunt render --format json
cd aws_services/live/testing/regions/us-east-2/mycustomer/vpc/net-gyr4 && terragrunt validate
```

Units with `dependency` blocks have no `mock_outputs`, so `terragrunt validate`/`plan` needs the dependencies applied first (or temporary `mock_outputs`). Terragrunt ignores inputs that the module does not declare, and Terraform drops unknown attributes of `object(...)` variables, so always compare inputs with the module `variables.tf` after upgrading a module.

## Gotchas

- Terragrunt 1.x: use `terragrunt run --all <command>` (not `run-all`); the state bucket is created only with `--backend-bootstrap` (or `terragrunt backend bootstrap`); docs are at https://docs.terragrunt.com.
- The S3 backend uses `use_lockfile = true` (the `dynamodb_table` option is deprecated in Terraform).
- `terraform-aws-modules/eks` v21 renamed the `cluster_*` inputs (for example `cluster_name` -> `name`, `cluster_version` -> `kubernetes_version`, `cluster_addons` -> `addons`). See `docs/UPGRADE-21.0.md` of the module.
- `terraform-aws-modules/route53` v6 removed the `zones` and `records` submodules: the root module manages the zone (`create_zone`) and the `records` map.
- `terraform-aws-modules/ec2-instance` v6: `root_block_device` is an object with `size`/`type`, and a security group is created unless `create_security_group = false`.
- `find_in_parent_folders()` must receive a file name (the root config is `root.hcl`, there is no parent `terragrunt.hcl`).
- Helm 4: `helm upgrade --dry-run` takes a value (`client`, `server` or `none`), plugins are verified by default and helm-secrets is split into three plugins for Helm 4.
- The Grafana admin password of kube-prometheus-stack is random (secret `monitor-grafana`, key `admin-password`).
- `kubectl version --short` was removed in kubectl 1.28.
- The Argo CD UI is served with TLS: port-forward `svc/argocd-server` port 443.
- The kubelet of recent `kindest/node` images (v1.37.0) does not start on hosts with cgroup v1.
