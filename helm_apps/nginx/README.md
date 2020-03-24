<!-- TOC -->

- [About](#about)
- [Prerequisites](#prerequisites)
- [How to Deploy Nginx in Kubernetes without Basic Authentication](#how-to-deploy-nginx-in-kubernetes-without-basic-authentication)
- [How to Deploy Nginx with Kubectl for enable Basic Authentication](#how-to-deploy-nginx-with-kubectl-for-enable-basic-authentication)
- [Command Utils for Troubleshooting](#command-utils-for-troubleshooting)
- [Install nginx-ingress for Services Internal Kubernetes Cluster](#install-nginx-ingress-for-services-internal-kubernetes-cluster)

<!-- TOC -->

# About

My Helm Values for deploy of nginx using helm chart for proxy/redirect services externals to Kubernetes.

For install nginx-ingress in Kubernetes cluster see [Install nginx-redirect](#install-nginx-redirect) section.


# Prerequisites

Install and configure the prerequisites cited in [README.md](../README.md) in ``Prerequisites`` section.

List the namespaces of cluster.

```bash
kubectl get namespaces
```

Create the namespace ``redirect`` if not exists in cluster.

```bash
kubectl create namespace redirect
```

# How to Deploy Nginx in Kubernetes without Basic Authentication

Add Helm repo Bitnami charts:

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
```

Edit the parameters in `adsoft/helm_apps/nginx/values.yaml` file.

Deploy Nginx in cluster Kubernetes with Helm.

```bash
helm install nginx \
 -f ~/adsoft/helm_apps/nginx/values.yaml \
  bitnami/nginx -n redirect
```

List all releases using Helm.

```bash
helm list -n redirect
```

Access Nginx in http://IP-LOADBALANCER:80.


Delete nginx using Helm.

```bash
helm uninstall nginx -n redirect
```

# How to Deploy Nginx with Kubectl for enable Basic Authentication

In Ubuntu 18.04 install package ``apache2-utils``.

```bash
sudo apt-get install apache2-utils
```

In CentOS 7 install package ``httpd-tools``

```bash
sudo yum install httpd-tools
```

Create ``/tmp/auth`` file and define password for user ``admin`` (by example).

```bash
htpasswd -c /tmp/auth admin
```

Generate ``server.key`` and ``server.crt`` files following the instructions in this tutorial: http://blog.aeciopires.com/configurando-o-grafana-para-funcionar-sobre-https/

Create the secrets in Kubernetes with Kubectl.

```bash
kubectl create secret generic basic-auth --from-file=/tmp/auth -n redirect
kubectl create secret generic key --from-file=server.key -n redirect
kubectl create secret generic cert --from-file=server.crt -n redirect
```

View the secret ``basic-auth``, ``key`` and ``crt`` create in Kubernetes.

```bash
kubectl get secret basic-auth -o yaml -n redirect
kubectl get secret key -o yaml -n redirect
kubectl get secret cert -o yaml -n redirect
```

Download and configure the parameters for deploy of ``nginx``.

```bash
cd ~
git clone https://github.com/aeciopires/adsoft.git
```

Edit the parameters in ``adsoft/helm_apps/nginx/deployment.yaml`` file.

Deploy Nginx in cluster Kubernetes with Kubectl for enable basic authentication and restrict source by IP address.

```bash
kubectl apply -f ~/adsoft/helm_apps/nginx/deployment.yaml -n redirect
```

Access Nginx in http://IP-LOADBALANCER:80 and https://IP-LOADBALANCER:443.

Delete nginx using Kubectl.

```bash
kubectl delete -f ~/adsoft/helm_apps/nginx/deployment.yaml -n redirect
```

References: 

* https://bitnami.com/stack/nginx/helm
* https://github.com/bitnami/charts/tree/master/bitnami/nginx
* https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/
* https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_except
* https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html
* https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/auth/basic
* https://kubernetes.io/docs/concepts/configuration/secret/
* https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
* https://www.jeffgeerling.com/blog/2019/mounting-kubernetes-secret-single-file-inside-pod
* https://www.magalix.com/blog/kubernetes-secrets-101
* https://cloud.google.com/kubernetes-engine/docs/concepts/secret
* https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
* https://aws.amazon.com/premiumsupport/knowledge-center/eks-cidr-ip-address-loadbalancer/
* https://medium.com/faun/how-to-assign-external-ip-address-static-to-a-gcp-kubernetes-engine-service-c5be91cdcfd5

# Command Utils for Troubleshooting

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
or
kubectl exec -it svc/nginx -n redirect -- sh
```

View informations of service.

```bash
kubectl get svc
kubectl get pods --output=wide -n redirect
kubectl describe services nginx -n redirect
```

Delete the namespace ``redirect`` in cluster.

```bash
kubectl delete namespace redirect
```

# Install nginx-ingress for Services Internal Kubernetes Cluster

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
