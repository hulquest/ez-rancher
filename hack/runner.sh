#!/usr/bin/env bash

if ( ! docker stats --no-stream > /dev/null ); then
  echo 'Docker daemon is not running. Exiting'
  exit 1;
fi

operation=$1
tfvars=${2:-"${PWD}/rancher.tfvars"}
deliverables=${3:-"${PWD}/deliverables"}

if [ ! -f "$tfvars" ]; then
  echo 'Local tfvars file not found at:'
  echo "$tfvars"
  echo 'Exiting'
  exit 1;
fi

if [ ! -d "$deliverables" ]; then
  echo 'Local deliverables file not found at:'
  echo "$deliverables"
  echo 'Exiting'
  exit 1;
fi

make image
docker run -it --rm -v "$tfvars":/terraform/vsphere-rancher/rancher.tfvars -v "$deliverables":/terraform/vsphere-rancher/deliverables terraform-rancher "$operation" -state=deliverables/terraform.tfstate
