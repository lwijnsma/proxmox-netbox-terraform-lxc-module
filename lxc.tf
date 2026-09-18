data "netbox_cluster" "vm_cluster" {
  name = var.netbox_cluster
}

data "netbox_tenant" "tenant" {
  name = var.netbox_tenant
}

data "netbox_device_role" "role" {
  name = var.netbox_device_role
}

data "netbox_ip_range" "ip_range" {
  description = var.ip_range
}

resource "netbox_virtual_machine" "myvm" {
  cluster_id   = data.netbox_cluster.vm_cluster.id
  name         = var.lxc_hostname
  memory_mb    = var.lxc_memory
  vcpus        = var.lxc_cpus
  role_id      = data.netbox_device_role.role.id
  tenant_id    = data.netbox_tenant.tenant.id
}

resource "netbox_virtual_disk" "scsi0" {
  name               = "scsi0"
  description        = "Main disk"
  size_mb            = var.lxc_disk_size * 1024
  virtual_machine_id = netbox_virtual_machine.myvm.id
}

resource "netbox_interface" "myvm-eno1" {
  name               = "eno1"
  virtual_machine_id = resource.netbox_virtual_machine.myvm.id
}

resource "netbox_available_ip_address" "vm_ip" {
  ip_range_id =  data.netbox_ip_range.ip_range.id
  status       = "active"
  dns_name    = var.lxc_hostname
  virtual_machine_interface_id = resource.netbox_interface.myvm-eno1.id
}

resource "netbox_primary_ip" "myvm_primary_ip" {
  ip_address_id      = resource.netbox_available_ip_address.vm_ip.id
  virtual_machine_id = resource.netbox_virtual_machine.myvm.id
}

data "proxmox_file" "debian_container_template" {
  node_name    = var.pve_node
  datastore_id = "local"
  content_type = "vztmpl"
  file_name    = "debain-13-standard_13.6-1_amd64.tar.zst"
}


resource "random_password" "debian_container_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "debian_container_password" {
  value     = random_password.debian_container_password.result
  sensitive = true
}

resource "proxmox_virtual_environment_container" "lxc_container" {

  description = var.lxc_description
  tags        = var.lxc_tags
  node_name = var.pve_node

  unprivileged = true

  memory {
    dedicated = var.lxc_memory
  }

  cpu {
    cores = var.lxc_cpus
  }

  initialization {
    hostname = var.lxc_hostname

    ip_config {
      ipv4 {
        address = resource.netbox_available_ip_address.vm_ip.ip_address
        gateway = cidrhost(resource.netbox_available_ip_address.vm_ip.ip_address, 1)
      }
    }

    user_account {
      keys = var.sshkeys
      password = random_password.debian_container_password.result
    }
  }

  network_interface {
    name = "veth0"
    bridge = var.lxc_bridge
    vlan_id = var.lxc_vlan_id
  }

  disk {
    datastore_id = var.lxc_datastore
    size         = var.lxc_disk_size
  }

  operating_system {
    template_file_id = data.proxmox_file.debian_container_template.id
    type = "debian"
  }

}
