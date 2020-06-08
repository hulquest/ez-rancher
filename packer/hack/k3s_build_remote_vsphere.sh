#!/bin/bash

packer build -only=vsphere-iso -var-file=./variables.json k3s-server.json

# TODO: Add a govc call to pull down the resultant image?
