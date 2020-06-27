#!/usr/bin/env sh


image_name=$(docker inspect "$(hostname)" --format="{{ .Config.Image }}")
mnode_public_ip=$(docker run --rm --net host --entrypoint /bin/sh ${image_name} -c "ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p'")

cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "0.0.0.0"
featureGates:
  TTLAfterFinished: true
kubeadmConfigPatchesJSON6902:
- group: kubeadm.k8s.io
  version: v1beta2
  kind: ClusterConfiguration
  patch: |
    - op: add
      path: /apiServer/certSANs/-
      value: ${mnode_public_ip} # this needs to be the hostname and/or IP of the mnode its running on, its for the UI
- group: kubeadm.k8s.io
  version: v1beta2
  kind: ClusterConfiguration
  patch: |
    - op: add
      path: /apiServer/certSANs/-
      value: kind-control-plane
EOF

kind create cluster --config kind-config.yaml
# be sure a docker volume is mounted to the location below so the kubeconfig can be shared with the HCC UI
kind get kubeconfig > /kubeconfig/kubeconfig
