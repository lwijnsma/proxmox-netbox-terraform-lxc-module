variable "pve_node" {
  type = string
  default = "pve"
}

variable "lxc_hostname" {
  type = string
}

variable "lxc_tags" {
  type = list(string)
  default = ["terraform"]
}
variable "lxc_bridge" {
  type = string
  default = "lxcbr0"
}
variable "lxc_datastore" {
  type = string
  default = "local-llxc"
}
variable "lxc_disk_size" {
  type = number
  default = 20
}
variable "lxc_memory" {
  type = number
  default = 2048
}
variable "lxc_cpus" {
  type = number
  default = 2
}
variable "lxc_vlan_id" {
  type = number
  default = 1610
}
variable "lxc_description" {
  type = string
  default = "Managed by Terraform"
}
variable "netbox_cluster" {
  type = string
  default = "Proxmox"
}
variable "netbox_tenant" {
  type = string
}
variable "netbox_device_role" {
  type = string
  default = "Application Server"
}
variable "sshkeys" {
  type = list(string)
  default = null
}
variable "ip_range" {
  type = string
  default = "VM's"
}
