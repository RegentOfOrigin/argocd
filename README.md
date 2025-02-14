RegentOfOrigin's Kubernetes Configuration
=========================================

This is my Kubernetes cluster configuration. The tested basis for these
configs is a 3+ baremetal Microk8s cluster with coredns installed. See
my ansible repo for how I bootstrap that repository.

# Assumptions

- You are able to route to 10.0.0.0/8 from your local network
- You have a functioning CNI
- There is an nfs server at tartarus.internal exporting /tank/kubernetes
- You are using cloudflare for external domains
- You are able to forward the ports you desire from the edge (your
  router) to 10.7.0.1
- Your home assistant instance is accessible from 10.0.23.255:8123
- Helm 3 is installed locally
- Cluster kubernetes version is sufficiently recent

# Bootstrapping

Bootstrapping is achieved by using helm to install Argo CD and automatically
load this repository. This relies on automatic syncing and sync waves
to roll out the various projects effectively.

Secrets need to be made available to your applications in advance. This
is a bit of a pain in the ass because most applications will deploy into
their own namespaces. To resolve this, we'll use ExternalSecrets and a
dedicated `secrets` namespace to seed these secrets.

At the time of this writing, only cert-manager requires a pre-allocated 
secret. Start by creating a [dedicated API token in your cloudflare
account](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens).

Now we can seed our `secrets` namespace:

```shell
kubectl create namespace secrets
kubectl create -n secrets secret generic cloudflare-api-token-secret --from-literal=<YOUR_API_TOKEN>
```

Now download [meta.yaml](argocd/meta.yaml). We can now
install a minimal version of the Argo CD chart that will automatically
sync to a high availability version including all of our applications.

```shell
helm repo add argocd https://argoproj.github.io/argo-helm
helm install argocd argocd/argo-cd --set-file "extraObjects[0]=meta.yaml"
```