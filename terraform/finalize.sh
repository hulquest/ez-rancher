#!/usr/bin/bash
export KUBECONFIG=./kube_config_cluster.yml
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.15.0

sleep 60
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.demo.org

