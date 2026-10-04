# install-zabbix-argocd

<!-- TOC -->

- [install-zabbix-argocd](#install-zabbix-argocd)
- [Requirements](#requirements)
- [Deploy Zabbix using ArgoCD](#deploy-zabbix-using-argocd)
- [References](#references)

<!-- TOC -->

# Requirements

- Install all packages and binaries following the instructions on the [REQUIREMENTS.md](../../../REQUIREMENTS.md) file.
- Install ArgoCD following the instructions on the [README.md](../README.md) file.
- The ``application.yaml`` file reads the ``zabbix_values.yaml`` file from the ``master`` branch of the https://github.com/aeciopires/adsoft repository. If you use a fork, change the ``repoURL`` and ``targetRevision`` in ``application.yaml``.

# Deploy Zabbix using ArgoCD

Deploy the application:

```bash
cd adsoft/helm_apps/argocd/zabbix
kubectl apply -f application.yaml
```

You can see the application status in: https://localhost:8443/applications (see the port-forward command in the [README.md](../README.md) file)

Accessing Zabbix:

```bash
kubectl -n monitoring port-forward svc/zabbix-zabbix-web 8080:80
```

Access URL: http://localhost:8080

- Login: Admin
- Password: zabbix

# References

- https://github.com/zabbix-community/helm-zabbix
- https://artifacthub.io/packages/helm/argo/argo-cd
- https://blog.aeciopires.com/usando-o-argo-cd-para-implementar-a-abordagem-gitops-nos-clusters-kubernetes/
- https://argo-cd.readthedocs.io/en/stable/
- https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/
