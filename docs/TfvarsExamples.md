# Example rancher.tfvars
There are a few different configuration options that can be set in the rancher.tfvars file for Terraform Rancher. Here are some examples of files:  

## DHCP
```hcl-terraform
control_plane_count    = 1
worker_count           = 2
vm_cpu                 = 2
vm_ram                 = 4096
vm_name                = "rancher"
vm_template_name       = "bionic-server-cloudimg-amd64"
vsphere_vcenter        = "vcenter.example.com"
vsphere_user           = "user"
vsphere_password       = "secret"
vsphere_unverified_ssl = "true"
vsphere_datacenter     = "datacenter1"
vm_datastore           = "datastore1"
vm_network             = "VMNet1"
rancher_server_url     = "rancher.example.com"
bootstrap_rancher      = false
rancher_password       = "solidfire"
```

## User defined IP addresses
```hcl-terraform
control_plane_count    = 1
worker_count           = 2
vm_cpu                 = 2
vm_ram                 = 4096
vm_name                = "rancher"
vm_template_name       = "bionic-server-cloudimg-amd64"
vsphere_vcenter        = "vcenter.example.com"
vsphere_user           = "user"
vsphere_password       = "secret"
vsphere_unverified_ssl = "true"
vsphere_datacenter     = "datacenter1"
vm_datastore           = "datastore1"
vm_network             = "VMNet1"
rancher_server_url     = "rancher.example.com"
static_ip_addresses    = ["10.1.1.2/24", "10.1.1.3/24", "10.1.1.4/24"]
default_gateway        = "10.0.0.1"
bootstrap_rancher      = false
rancher_password       = "solidfire"
```
