# Standalone UI

This directory holds an example `docker-compose.yaml` for how the standalone UI could work.

## Usage
Run the Standalone UI. This runs the UI and the `kind` helper container.
```bash
docker-compose up --build
docker run -it --rm -v ${PWD}:/deliverables -v Kubeconfig:/kubeconfig alpine:3.12.0 sh -c "cp /kubeconfig/kubeconfig /deliverables/kubeconfig"
kubectl --kubeconfig kubeconfig get nodes
```

Clean up
```bash
kind delete cluster
```

## Kind helper container
This directory has a `Dockerfile` for the kind helper container (kind-bootstrapper). It demonstrates how a container can create the kind cluster on a docker host.

## Troubleshooting
```bash
# show the kubeadm config from kind to validate settings like certSANs, feature-gates, etc
kubectl --kubeconfig kubeconfig -n kube-system get configmap kubeadm-config -o jsonpath='{.data.ClusterConfiguration}'
```
