# Connect to vSphere
provider "vsphere" {
  user           = var.vsphere-user
  password       = var.vsphere-password
  vsphere_server = var.vsphere-vcenter
  allow_unverified_ssl = var.vsphere-unverified-ssl
}

# Define vSphere settings 
data "vsphere_datacenter" "dc" {
  name = var.vsphere-datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vm-datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere-cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm-network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere-datacenter}/vm/Templates/${var.vm-template-name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Provisoin VMs
resource "vsphere_virtual_machine" "vm" {
  count = var.vm-count

  name             = "${var.vm-name}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder = var.vsphere-vm-folder

  num_cpus = var.vm-cpu
  memory   = var.vm-ram
  guest_id = var.vm-guest-id

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${var.vm-name}-${count.index + 1}-disk"
    size  = 80
    thin_provisioned = false
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  vapp {
    properties ={
      hostname = "${var.vm-name}-${count.index + 1}"
      user-data = base64encode(file("${path.module}/cloudinit/kickstart.yaml"))
    }
  }


  extra_config = {
    "guestinfo.metadata"          = base64encode("${file("${path.module}/cloudinit/metadata.yaml")}")
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode("${file("${path.module}/cloudinit/userdata.yaml")}")
    "guestinfo.userdata.encoding" = "base64"
  }
}

output "node_ips" {
  value = vsphere_virtual_machine.vm.*.default_ip_address
}

resource "time_sleep" "wait_cloudinit" {
  depends_on = [vsphere_virtual_machine.vm[0]]
  # 2m is probably excessive, but leave it for now
  create_duration = "2m"
}

# We'd like to just use this as our wait for RKE deploy, but then we run into things like ssh keep-alive timeout
# TODO: Look into modifying sshd config to use this instead of a dumb wait like we have above
resource  "null_resource" "wait_cloud_init" {
  depends_on = [time_sleep.wait_cloudinit]
  count = var.vm-count

  provisioner "remote-exec" {
    inline = [
      "sudo cloud-init status --wait"
    ]
    connection {
      host = vsphere_virtual_machine.vm["${count.index}"].default_ip_address
      type = "ssh"
      user = "ubuntu"
    }
  }

}

resource "rke_cluster" "cluster" {
  depends_on = [null_resource.wait_cloud_init]
  nodes {
    address = vsphere_virtual_machine.vm[0].default_ip_address
    user = "ubuntu"
    role = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }
  nodes {
    address = vsphere_virtual_machine.vm[1].default_ip_address
    user = "ubuntu"
    role = ["worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }
  nodes {
    address = vsphere_virtual_machine.vm[2].default_ip_address
    user = "ubuntu"
    role = ["worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}
