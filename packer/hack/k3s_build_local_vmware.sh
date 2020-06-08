#!/bin/bash

rm -rf _output/vmware
packer build -only=vmware-iso -var-file=./variables.json k3s-server.json

cd _output/vmware

# Change output artifact to OVA
find k3s-ubuntu.vmx | xargs -I'{}' ovftool -tt=OVA '{}' k3s-ubuntu.ova

# Unpack created OVA
tar -xvf k3s-ubuntu.ova

# Change name of disk file (if we don't do this vSphere complains for some reason)
mv k3s-ubuntu-disk1.vmdk disk-0.vmdk

# Update disk file name in XML manifest
cot --force  add-disk -f file1 disk-0.vmdk k3s-ubuntu.ovf

# Pack into OVA again
tar -cvf k3s-ubuntu.ova k3s-ubuntu.ovf disk-0.vmdk

# Go back to artifact directory
cd ../../

# Copy the OVA into its final output directory
mkdir -p images/ova
cp _output/vmware/k3s-ubuntu.ova images/ova/k3s-ubuntu.ova

# Add properties to the OVA, this can be used to initialize cloud-init on upload time
cot -f edit-properties images/ova/k3s-ubuntu.ova \
-t iso \
-p user-data+string \
-p public-keys+string \
-p password+string \
-p instance-id=id-ovf+string \
-p hostname+string \
-p seedfrom+string --user-configurable

# Rename NIC to nic0, this is the name our deployment code expects
cot -f edit-hardware images/ova/k3s-ubuntu.ova -n 1 --nic-types vmxnet3 --nic-names nic0
cot -f edit-hardware images/ova/k3s-ubuntu.ova -N nic0

# Change OVA file permissions
chmod -R 755 images/ova/k3s-ubuntu.ova
