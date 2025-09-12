# Memory issue

Create the cluster

```bash
kind create cluster --config kind-cluster.yaml
```

Install the metrics-server

```bash
kubectl apply -f metrics-server.yaml
```

Generate a lot of CRDs

```bash
bash generate-crds.sh
```

Show CRD count

```bash
kubectl get crd --no-headers | wc -l
```

Install Capsule

```bash
helm upgrade --install capsule projectcapsule/capsule --version 0.10.0 -n capsule-system --create-namespace
```

Install Capsule Proxy, check memory usage

```bash
helm upgrade --install capsule-proxy projectcapsule/capsule-proxy --version 0.9.8 -n capsule-system --values values.yaml
kubectl top pod -n capsule-system
NAME                                          CPU(cores)   MEMORY(bytes)   
capsule-controller-manager-59d4575746-q65lz   1m           116Mi           
capsule-proxy-7dd489bbd6-vhtdt                5m           41Mi
```

Update Capsule Proxy, check memory usage again

```bash
helm upgrade --install capsule-proxy projectcapsule/capsule-proxy --version 0.9.9 -n capsule-system --values values.yaml
kubectl top pod -n capsule-system
NAME                                          CPU(cores)   MEMORY(bytes)   
capsule-controller-manager-59d4575746-q65lz   4m           120Mi           
capsule-proxy-86d475f5cc-6q7ts                82m          187Mi
```
