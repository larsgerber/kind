# Replication issue

Create the cluster

```bash
kind create cluster --config kind-cluster.yaml
```

Install Capsule

```bash
helm repo add projectcapsule https://projectcapsule.github.io/charts
helm upgrade --install capsule projectcapsule/capsule --version 0.10.0 -n capsule-system --create-namespace
```

Install Capsule Proxy

```bash
helm upgrade --install capsule-proxy projectcapsule/capsule-proxy --version 0.9.13 -n capsule-system --values values.yaml
```

Setup tenant

```bash
kubectl create -f tenant.yaml
kubectl create ns oil-bar
kubectl get tenant oil -o jsonpath='{.metadata.uid}'
kubectl patch ns oil-bar --type=merge -p='{"metadata": { "ownerReferences": [{ "apiVersion": "capsule.clastix.io/v1beta2", "kind": "Tenant", "name": "oil", "uid": "<tenant uid>" }] }}'
kubectl get tenant oil
```

Configure replicaton

```bash
kubectl create -f netpol.yaml -f globaltenantresource.yaml
kubectl get netpol -n oil-bar allow-all-ingress
```

We use a custom webhook logger to show the below diff. For simple use cases the following tool [kubectl-watch-diff](https://github.com/alexmt/kubectl-watch-diff) can be used.

```diff
=== NetworkPolicy allow-all-ingress UPDATE detected ===
User: system:serviceaccount:capsule-system:capsule
Change detected in full object (excluding volatile fields):
--- old
+++ new
@@ -9,7 +9,6 @@
     "creationTimestamp": "2025-09-12T10:53:06Z",
     "generation": 1,
     "labels": {
-      "capsule.clastix.io/managed-by": "oil",
       "capsule.clastix.io/resources": "0",
       "capsule.clastix.io/tenant": "oil",
       "foo": "bay",
10.244.0.1 - - [12/Sep/2025 12:43:15] "POST /validate?timeout=10s HTTP/1.1" 200 -

=== NetworkPolicy allow-all-ingress UPDATE detected ===
User: system:serviceaccount:capsule-system:capsule-proxy
Change detected in full object (excluding volatile fields):
--- old
+++ new
@@ -9,6 +9,7 @@
     "creationTimestamp": "2025-09-12T10:53:06Z",
     "generation": 1,
     "labels": {
+      "capsule.clastix.io/managed-by": "oil",
       "capsule.clastix.io/resources": "0",
       "capsule.clastix.io/tenant": "oil",
       "foo": "bay",
10.244.0.1 - - [12/Sep/2025 12:43:15] "POST /validate?timeout=10s HTTP/1.1" 200 -
```
