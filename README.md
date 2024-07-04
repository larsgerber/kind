# Kind cluster setup with NGINX

```bash
kind create cluster --config ./config/cluster.yaml
```

```bash
kubectl apply -f ./config/nginx.yaml
```

```bash
kubectl apply -f ./config/usage.yaml
```
