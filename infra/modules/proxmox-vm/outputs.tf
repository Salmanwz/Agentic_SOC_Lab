output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "ipv4_address" {
  description = "First reported IPv4 address (requires the QEMU guest agent to be running)."
  value       = try(proxmox_virtual_environment_vm.this.ipv4_addresses[1][0], null)
}
