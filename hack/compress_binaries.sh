#!/usr/bin/env sh

# compress binaries
echo -e "======== compressing binaries"
upx /bin/terraform /bin/kubectl /bin/terragrunt
echo -e "========"

# compress terraform plugins
echo -e "======== compressing terraform plugins"
upx `find /terraform/vsphere-rancher/.terraform/plugins -type f -name "terraform-provider-*"`
echo -e "========"
