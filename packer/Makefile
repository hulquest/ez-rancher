SHELL := /usr/bin/env bash

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: rke-ova-local
rke-ova-local: ## Build an ova using your local vmware (workstation, player etc) 
	hack/rke_build_local_vmware.sh

.PHONY: rke-ova-vsphere 
rke-ova-vsphere: ## Build an ova on a remote vSphere cluster (requires update to variables in the rke-server.json manifest)
	hack/rke_build_remote_vsphere.sh

.PHONY: k3s-ova-local
k3s-ova-local: ## Build an ova using your local vmware (workstation, player etc) 
	hack/k3s_build_local_vmware.sh

.PHONY: k3s-ova-vsphere 
k3s-ova-vsphere: ## Build an ova on a remote vSphere cluster (requires update to variables in the rke-server.json manifest)
	hack/k3s_build_remote_vsphere.sh


.PHONY: qcow2
qcow2: ## Build a qcow2 using a qemu/kvm build system
