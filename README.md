RegentOfOrigin's Kubernetes Configuration
=========================================

This is a sample kubernetes cluster configuration. The general test
environment is a 3+ baremental Microk8s cluster with coredns installed.
See my ansible repo for how I bootstraped that cluster.

# Assumptions

- You are able to route to 10.0.0.0/8 from your local network
- You have a functioning initial CNI
- There is an nfs server at tartarus.node.internal exporting /tank/kubernetes
- You are using cloudflare for external domains
- You are able to forward the ports you desire from the edge (your router) to
  10.5.0.1
- Your home assistant instance has a local DNS entry at homeassistant.svc.internal
- Helm 3 is installed locally
- Cluster kubernetes version is sufficiently recent

# Bootstrapping

Bootstrapping is achieved by using helm to install Argo CD (overriding the full name),
then importing our app of apps. The sync waves are configured such that cert-manager
and nginx will be configured before updating argocd to utilize a publicly accessible
ingress. The initially installed Argo CD with overridden full name will be adopted by
Argo CD with proper provenance.

```shell
helm repo add argo https://argoproj.github.io/argo-helm
helm install --namespace argocd --create-namespace argocd argo/argo-cd --set fullnameOverride=argo-cd-argocd
# Run a second time so the CRDs are installed but we don't ignore validation
helm upgrade --namespace argocd --create-namespace argocd argo/argo-cd --set fullnameOverride=argo-cd-argocd --set-file 'extraObjects[0]=_meta/app-of-apps.yaml'
```

Note, you will need to create a secret with your cloudflare api token as soon as
the cert-manager namespace exists. You can solve this by manually creating the
cert-manager namespace, or initializing the app of apps and then creating the secret.

To create the secret, run:

```shell
kubectl create -n cert-manager secret generic cloudflare-api-token-secret --from-literal=api-token=<Your Secret Here>
```
