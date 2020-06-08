# Packer files to build RKE OVA using vsphere-iso or vmware-iso

This builds a simple Ubuntu 18.04 OVA or QCOW2 (WIP) with RKE or K3s and Helm-3 installed.


# Requirements

Tested with:
Packer version 1.5.5
Linux
  - to vSphere 6.x
  - vmWare Workstation for Linux
MacOS
  - to vSphere 6.x
  - vmWare Fusion

## Build an image

Update the variables.json file with your specifc info.

Use make, and select your build platform:

### rke-ova-local or k3s-ova-local

Builds an OVA on your local machine using VMware Workstation, Player, Fusion etc

### rke-ova-vsphere or k3s-ova-vsphere

Builds an OVA on a remote vSphere cluster. 

### qcow2

Not implemented yet, but will enable building a qcow2 for use by KVM

## Possible additions

Add vbox support?
