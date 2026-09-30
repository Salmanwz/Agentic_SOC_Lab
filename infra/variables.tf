variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint, e.g. https://proxmox.homelab.local:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token, format 'user@realm!token-id=uuid'. Set as TF_VAR_proxmox_api_token in infra/.env (loaded by tofu.sh)."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure_tls" {
  description = "Skip TLS verification for the Proxmox API (typical for a self-signed homelab cert)."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH username OpenTofu uses to reach the Proxmox node directly (for file uploads etc)."
  type        = string
  default     = "root"
}

variable "proxmox_node" {
  description = "Name of the Proxmox node to place VMs on."
  type        = string
}

variable "template_vm_id" {
  description = "VM ID of the cloud-init-enabled template to clone for new VMs."
  type        = number
}

variable "vm_username" {
  description = "Default user created via cloud-init on each VM."
  type        = string
  default     = "ops"
}

variable "vm_password" {
  description = "Password for vm_username on every VM. Set as TF_VAR_vm_password in infra/.env."
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Optional SSH public key injected into each VM via cloud-init for the default user. Leave null if the template already provides a login."
  type        = string
  default     = null
}

variable "network_bridge" {
  description = "Proxmox network bridge to attach VM NICs to."
  type        = string
  default     = "vmbr0"
}
