RegentOfOrigin's Kubernetes Configuration
=========================================

This is a sample kubernetes cluster configuration. The general test
environment is a 3+ baremental Microk8s cluster with coredns installed.
See my ansible repo for how I bootstraped that cluster.

# Assumptions

- You are able to route to 10.0.0.0/8 from your local network
- You have a functioning CNI
- There is an nfs server at tartarus.internal exporting /tank/kubernetes
- You are using cloudflare for external domains
- You are able to forward the ports you desire from the edge (your router) to
  10.7.0.1
- Your home assistant instance is accessible from 10.0.23.255:8123
- Helm 3 is installed locally
- Cluster kubernetes version is sufficiently recent

# Bootstrapping

Bootstrapping is achieved by using helm to install Argo CD and automatically
load this repository. This relies on automatic syncing and sync waves to roll
out the various projects effectively.

Secrets need to be made available to your applications in advance.

Now download [argo-cd.yaml](applications/argo-cd.yaml). We can now install a
version of Argo CD that will then bootstrap itself and the rest of this
repository.

```shell
helm repo add argocd https://argoproj.github.io/argo-helm
helm install argocd argocd/argo-cd --set-file 'extraObjects[0]=argo-cd.yaml'
```
