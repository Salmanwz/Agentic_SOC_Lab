# The dockerhome VM already exists and is not managed here — only the Wazuh VM is provisioned.
module "wazuh_vm" {
  source = "./modules/proxmox-vm"

  name           = "wazuh"
  vm_id          = 8001
  node_name      = var.proxmox_node
  template_vm_id = var.template_vm_id

  # Wazuh manager + indexer (OpenSearch) + dashboard — indexer is memory-hungry.
  cpu_cores    = 4
  memory_mb    = 10240
  disk_size_gb = 250

  network_bridge = var.network_bridge
  ip_config      = "dhcp"

  vm_username    = var.vm_username
  vm_password    = var.vm_password
  ssh_public_key = var.ssh_public_key

  tags = ["soc-lab", "wazuh"]
}
