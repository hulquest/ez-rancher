# ez-rancher
Terraform to deploy a Rancher cluster on vSphere

## requirements
If you're running locally without the docker container:
* Helm 3
* Kubectl
* Terraform RKE plugin

## usage
provsion some VMs and install RKE and Rancher Server
`terraform apply`

## as a Docker container
`docker run -it --rm -v ${PWD}/terraform.tfvars:/terraform/terraform.tfvars -v ${PWD}/deliverables:/terraform/deliverables ez-rancher apply -state=deliverables/terraform.tfstate`

# Releases will be published as container images in Github
