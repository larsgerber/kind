# Transparent Encryption with WireGuard

[Source](https://isovalent.com/blog/post/tutorial-transparent-encryption-with-ipsec-and-wireguard/)

## Install and verify

```bash
kind create cluster --config cluster.yaml
````

```bash
cilium install -f helm-values.yaml --version v1.16.0
````

```bash
kubectl get ciliumnode kind-worker2 \
  -o jsonpath='{.metadata.annotations.network\.cilium\.io/wg-pub-key}'
```

```bash
CILIUM_POD=$(kubectl -n kube-system get po -l k8s-app=cilium --field-selector spec.nodeName=kind-worker2 -o name)
echo $CILIUM_POD
```

```bash
kubectl -n kube-system exec -ti $CILIUM_POD -- bash
```

```bash
cilium status | grep Encryption
```

```bash
apt-get update
apt-get -y install tcpdump
```

## pod-to-pod encryption

```bash
tcpdump -n -i cilium_wg0
```

```bash
kubectl apply -f pod1.yaml -f pod2.yaml -o yaml
```

```bash
POD2=$(kubectl get pod pod-worker2 --template '{{.status.podIP}}')
echo $POD2
```

```bash
kubectl exec -ti pod-worker -- ping $POD2
```

```bash
POD3=$(kubectl get pod pod-worker3 --template '{{.status.podIP}}')
echo $POD3
```

```bash
kubectl exec -ti pod-worker -- bash -c "while true; do curl -I http://$POD3/login?token=12345; sleep 2; done"
```

## node-to-node encryption

```bash
ETH0_IP=$(ip a show eth0 | sed -ne '/inet 172\.18\.0/ s/.*inet \(172\.18\.0\.[0-9]\+\).*/\1/p')
echo $ETH0_IP
```

```bash
tcpdump -n -i cilium_wg0 src $ETH0_IP and dst port 4240
```

## Cleanup

```bash
helm -n kube-system uninstall cilium
```

```bash
kind delete clusters kind
```
