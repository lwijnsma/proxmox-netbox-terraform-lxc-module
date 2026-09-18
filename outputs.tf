output "instance_ip_addr" {
  value = netbox_available_ip_address.vm_ip.ip_address
}