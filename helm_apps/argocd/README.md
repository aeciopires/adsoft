# install-argocd

<!-- TOC -->

- [install-argocd](#install-argocd)
- [Requirements](#requirements)
- [Installing ArgoCD in kind](#installing-argocd-in-kind)
- [References](#references)

<!-- TOC -->

# Requirements

- Install all packages and binaries following the instructions on the [REQUIREMENTS.md](../../REQUIREMENTS.md) file.

# Installing ArgoCD in kind

Add the helm repository.

```bash
helm repo add argo https://argoproj.github.io/argo-helm
```

Update all the repositories to ensure helm is aware of the latest versions.

```bash
helm repo update
```

Search for all the Helm chart versions.

```bash
helm search repo argo/argo-cd --versions
```

Install ArgoCD using the following command:

```bash
ARGOCD_CHART_VERSION=10.9.6

helm upgrade --install argocd \
  argo/argo-cd --version "$ARGOCD_CHART_VERSION" \
  --namespace argocd --create-namespace --debug --timeout=900s
```

List the resources.

```bash
kubectl get all -n argocd
```

Create a port-forward to access ArgoCD web interface:

```bash
kubectl -n argocd port-forward svc/argocd-server 8443:443
```

This will create a forward from the application running in the Kubernetes cluster on port 443/TCP to port 8443/TCP on the local host. This way, you can open a browser at the address: https://localhost:8443 (ArgoCD uses a self-signed certificate by default, so accept it in the browser). If you close the terminal or press CTRL+C, the port-forward will be terminated and you will lose access.

The default login is admin and a random password will be generated. To obtain it, run the following command in another terminal:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

After logging into Argo CD, change your password at the following address: https://localhost:8443/user-info?changePassword=true

After changing the password in the web interface, you can remove the secret ``argocd-initial-admin-secret``, which contains the initial password, with the following command:

```bash
kubectl -n argocd delete secret argocd-initial-admin-secret
```

You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli

# References

- https://artifacthub.io/packages/helm/argo/argo-cd
- https://blog.aeciopires.com/usando-o-argo-cd-para-implementar-a-abordagem-gitops-nos-clusters-kubernetes/
- https://argo-cd.readthedocs.io/en/stable/
- https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/
