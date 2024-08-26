# Ingress NGINX Controller: Example

## Install

```bash
kind create cluster --config cluster.yaml
```

```bash
kubectl apply -f nginx.yaml
```

```bash
kubectl apply -f usage.yaml
```

## Test

```bash
curl 127.0.0.1/foo/hostname
foo-app
```

```bash
curl 127.0.0.1/bar/hostname
bar-app
```

## Cleanup

```bash
kind delete clusters kind
```
