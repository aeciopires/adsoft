<!-- TOC -->

- [About](#about)
- [How to Deploy Nginx in Kubernetes](#how-to-deploy-nginx-in-kubernetes)
- [Install nginx-redirect](#install-nginx-redirect)

<!-- TOC -->

# About

My Helm Values for deploy of nginx using helm chart for proxy/redirect services externals to Kubernetes.

For install nginx-ingress in Kubernetes cluster see [Install nginx-redirect](#install-nginx-redirect) section.


# How to Deploy Nginx in Kubernetes

Install and configure the prerequisites cited in [README.md](../README.md) in ``Prerequisites`` section.

Add Helm repo official stable charts:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm repo update
```

Install plugin Helm secrets.

```bash
helm plugin install https://github.com/futuresimple/helm-secrets
```

Download and configure the parameters for deploy of ``nginx``.

```bash
cd ~
git clone https://github.com/aeciopires/adsoft.git
cd adsoft/helm_apps/nginx
```

Edit the parameters in `values.yaml` and `secrets.yaml` files.

List the namespaces of cluster.

```bash
kubectl get namespaces
```

Create the namespaces ``redirect`` if not exists in cluster.

```bash
kubectl create namespace redirect
```

Deploy Nginx in cluster Kubernetes.

```bash
helm install nginx \
 -f ~/adsoft/helm_apps/nginx/values.yaml \
  bitnami/nginx -n redirect
```

Reference: https://github.com/bitnami/charts/tree/master/bitnami/nginx

List all releases using Helm.

```bash
helm list -n redirect
```

View the pods.

```bash
kubectl get pods -n redirect
kubectl get svc --namespace redirect -w nginx
```

View informations of pods.

```bash
kubectl describe pods/NAME_POD -n redirect
```

View all containers of pod.

```bash
kubectl get pods NAME_POD -n redirect -o jsonpath='{.spec.containers[*].name}*'
```

View the logs container of service and pods.

```bash
kubectl logs -f svc/nginx -n redirect
kubectl logs -f pods/NAME_POD -c NAME_CONTAINER -n redirect
```

Access prompt of container.

```bash
kubectl exec -it pods/NAME_POD -c NAME_CONTAINER -n redirect -- sh
```

View informations of service.

```bash
kubectl get svc
kubectl get pods --output=wide -n redirect
kubectl describe services nginx -n redirect
```

Access Nginx in http://IP-SERVER:80.


Delete nginx using Helm.

```bash
helm uninstall nginx -n redirect
```

# Install nginx-redirect

References for install nginx-ingress in Kubernetes cluster:

* https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
* https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
* https://asilearn.org/install-nginx-ingress-controller-on-kubernetes-9efb9765cc7a
* https://docs.nginx.com/nginx-ingress-controller/configuration/virtualserver-and-virtualserverroute-resources/
* https://github.com/nginxinc/kubernetes-ingress
* https://stackoverflow.com/questions/51597410/aws-eks-is-not-authorized-to-perform-iamcreateservicelinkedrole
* https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md
* https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
* https://docs.nginx.com/nginx-ingress-controller/configuration/ingress-resources/advanced-configuration-with-annotations/
* https://docs.giantswarm.io/guides/advanced-ingress-configuration/
* https://stackoverflow.com/questions/51874503/kubernetes-ingress-network-deny-some-paths
* https://www.edureka.co/community/19277/access-some-specific-paths-while-using-kubernetes-ingress
* https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
* https://imti.co/kubernetes-ingress-nginx-cors/
* https://stackoverflow.com/questions/54083179/how-can-i-correctly-setup-custom-headers-with-nginx-ingress
* https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
* https://flaviocopes.com/http-curl/