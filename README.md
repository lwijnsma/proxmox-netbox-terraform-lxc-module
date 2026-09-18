# Proxmox - Netbox - Cloud-init
| A Proxmox terraform module to create cloud-init lxc's and add them to Netbox

## Usage

Create a main.tf with the following content:
```HCL
module "proxmox" {
  source = "github.com/lwijnsma/proxmox-netbox-terraform-lxc-module"

  lxc_cpus = 2
  lxc_memory = 2048

  lxc_disk_size = 20
  lxc_datastore = "local-llxc"
  
  qemu_agent = true

  lxc_hostname = "test"
  lxc_username = "username"
  sshkeys = ["ssh-ed25519 <SSH_KEY>"]
  
  lxc_vlan_id = "1"
  ip_range = "Netbox Ip range description"
}
```

Create a provider.tf with the following:
```HCL
provider "netbox" {
  server_url = "https://demo.netbox.dev"
  api_token  = "<your api key>"
}


provider "proxmox" {
  endpoint = "https://10.0.0.2:8006/"

  username = "username@realm"
  password = "a-strong-password"
  
}
```
See [e-breuninger/netbox](https://registry.terraform.io/providers/e-breuninger/netbox/latest/docs) For more info about the netbox provider settings
See [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest/docs) for more info about the proxmox provider settings
