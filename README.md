# ez-rancher
Packer to build templates, and Terraform to deploy them

## Build some rancher/rke ovas with packer
See the README in the packer directory for details

## Deploy Rancher VMs on vSphere using Terraform
The basics are here, but it's not "done".  For now, just working through provisioning from templates.
Still having an issue specifying things like DS-Clusters under a folder, so just short circuiting to 
point directly a DS Host for now.
