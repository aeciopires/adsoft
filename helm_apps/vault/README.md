<!-- TOC -->

- [Requirements](#requirements)
- [Install Vault in kind cluster](#install-vault-in-kind-cluster)
- [Create secrets in vault and configure apps](#create-secrets-in-vault-and-configure-apps)

<!-- TOC -->

# Requirements

Install the following binaries following the instructions on the [REQUIREMENTS.md](../../REQUIREMENTS.md) file.

- asdf
- docker
- kind cluster
- helm
- kubectl
- vault-cli

# Install Vault in kind cluster

Reference: https://blog.aeciopires.com/instalando-o-hashicorp-vault-no-kubernetes-gke-usando-o-helm-e-configurando-um-bucket-gcs-para-armazenamento/

Run the follow commands:

```bash
# Add helm repository of vault
helm repo add hashicorp https://helm.releases.hashicorp.com

# Update repository list
helm repo update

# List all vault versions
helm search repo vault --versions

# Install vault in kind cluster
VAULT_CHART_VERSION=0.29.1
helm upgrade --install vault \
  hashicorp/vault --version "$VAULT_CHART_VERSION" -f values.yaml \
  --namespace vault --create-namespace --debug --timeout=900s --wait

# Get resources created
kubectl get all -n vault

# Get vault status
kubectl exec vault-0 --namespace vault -- vault status
```

In other terminal, run the command:

```bash
# Create port-forward to vault
kubectl port-forward pod/vault-0 8200:8200 -n vault
```

Back to first terminal and run the commands:

```bash
# Initialize vault
export VAULT_ADDR=http://127.0.0.1:8200

vault operator init
```

Annotate the result of command init, like this

```text
Unseal Key 1: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Unseal Key 2: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
Unseal Key 3: CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
Unseal Key 4: DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
Unseal Key 5: EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

Initial Root Token: hvs.blablablablablabla
```

Run the follow command 3 times inserting the each unseal key:

```bash
# Unseal vault
vault operator unseal "Unseal Key 1"
vault operator unseal "Unseal Key 2"
vault operator unseal "Unseal Key 3"
```

Run the follow commands:

```bash
# Get vault status
vault status

# Login to vault
vault login

# Configure vault and enable kubernetes integration
kubectl apply -f vault-secret.yaml -n vault

VAULT_HELM_SECRET_NAME=$(kubectl -n vault get secrets --output=json | jq -r '.items[].metadata | select(.name|startswith("vault-token-")).name')

kubectl describe serviceaccount vault -n vault

vault auth enable kubernetes

TOKEN_REVIEW_JWT=$(kubectl -n vault get secret $VAULT_HELM_SECRET_NAME --output='go-template={{ .data.token }}' | base64 --decode)

KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

KUBE_HOST=https://kubernetes.default.svc.cluster.local

vault write auth/kubernetes/config \
     token_reviewer_jwt="$TOKEN_REVIEW_JWT" \
     kubernetes_host="${KUBE_HOST}" \
     kubernetes_ca_cert="$KUBE_CA_CERT" \
     issuer="https://kubernetes.default.svc.cluster.local"
```

# Create secrets in vault and configure apps

Reference: https://blog.aeciopires.com/hashicorp-vault-entregando-segredos-para-uma-aplicacao-no-kubernetes/

Run the follow commands:

```bash
# Creating kv engine in vault to store secrets
PATH_KV_NAME="my-group-secrets"
vault secrets enable -path="$PATH_KV_NAME" --version=2 kv

# Creating secrets in vault for app2
vault kv put "$PATH_KV_NAME"/my-app-1 \
  DB_PASSWORD="password1" \
  DB_USER="user1" \
  DB_HOST="172.17.0.1" \
  DB_PORT="5432" \
  DB_NAME="db1"

# Creating secrets in vault for app2
vault kv put "$PATH_KV_NAME"/my-app-2 \
  DB_PASSWORD="password2" \
  DB_USER="user2" \
  DB_HOST="172.17.0.2" \
  DB_PORT="3306" \
  DB_NAME="db2"

# Creating policy for each application access the secrets path in vault
vault policy write policy-my-group-secrets -<<EOF
path "my-group-secrets/*" {
  capabilities = ["read", "list"]
}
EOF

# Creating service account for each application
MY_NAMESPACE=my-namespace
kubectl create namespace "$MY_NAMESPACE"
kubectl apply -f sa-my-app-1.yaml -f sa-my-app-2.yaml -n "$MY_NAMESPACE"

# Role role-my-app-1
vault write "auth/kubernetes/role/role-my-app-1" \
  bound_service_account_names="sa-my-app-1" \
  bound_service_account_namespaces="$MY_NAMESPACE" \
  token_policies="policy-my-group-secrets"

# Role role-my-app-2
vault write "auth/kubernetes/role/role-my-app-2" \
  bound_service_account_names="sa-my-app-2" \
  bound_service_account_namespaces="$MY_NAMESPACE" \
  token_policies="policy-my-group-secrets"

# Creating deployment and service for each application
kubectl apply -f deployment-my-app-1.yaml -f deployment-my-app-2.yaml  -n "$MY_NAMESPACE"

# Inspecting the resources created
kubectl get pods,deploy,service -n "$MY_NAMESPACE"
kubectl describe pod/NAME_POD1 -n "$MY_NAMESPACE"
kubectl describe pod/NAME_POD2 -n "$MY_NAMESPACE"
```
