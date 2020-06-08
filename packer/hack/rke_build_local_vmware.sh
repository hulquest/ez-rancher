#!/bin/bash

rm -rf _output/vmware
packer build -only=vmware-iso -var-file=./variables.json rke-server.json

cd _output/vmware

# Change output artifact to OVA
find rke-ubuntu.vmx | xargs -I'{}' ovftool -tt=OVA '{}' rke-ubuntu.ova

# Unpack created OVA
tar -xvf rke-ubuntu.ova

# Change name of disk file (if we don't do this vSphere complains for some reason)
mv rke-ubuntu-disk1.vmdk disk-0.vmdk

# Update disk file name in XML manifest
cot --force  add-disk -f file1 disk-0.vmdk rke-ubuntu.ovf

# Pack into OVA again
tar -cvf rke-ubuntu.ova rke-ubuntu.ovf disk-0.vmdk

# Go back to artifact directory
cd ../../

# Copy the OVA into its final output directory
mkdir -p images/ova
cp _output/vmware/rke-ubuntu.ova images/ova/rke-ubuntu.ova

# Add properties to the OVA, this can be used to initialize cloud-init on upload time
cot -f edit-properties images/ova/rke-ubuntu.ova \
-t iso \
-p user-data+string \
-p public-keys+string \
-p password+string \
-p instance-id=id-ovf+string \
-p hostname+string \
-p seedfrom+string --user-configurable

# Rename NIC to nic0, this is the name our deployment code expects
cot -f edit-hardware images/ova/rke-ubuntu.ova -n 1 --nic-types vmxnet3 --nic-names nic0
cot -f edit-hardware images/ova/rke-ubuntu.ova -N nic0

# Change OVA file permissions
chmod -R 755 images/ova/rke-ubuntu.ova
