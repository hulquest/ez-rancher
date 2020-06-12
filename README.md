# ez-rancher
Terraform to deploy a Rancher cluster on vSphere

## requirements
If you're running locally without the docker container:
* Helm 3
* Kubectl
* Terraform RKE plugin

## usage
provsion some VMs and install RKE
`terraform apply`

Finish it up by throwing rancher on top with helm
`./finalize.sh`
