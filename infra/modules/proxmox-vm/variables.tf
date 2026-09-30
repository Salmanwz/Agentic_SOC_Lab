variable "name" {
  description = "VM name (also used as the cloud-init hostname)."
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID for the new VM."
  type        = number
}

variable "node_name" {
  description = "Proxmox node to place the VM on."
  type        = string
}

variable "template_vm_id" {
  description = "VM ID of the cloud-init-enabled template to clone."
  type        = number
}

variable "cpu_cores" {
  description = "Number of vCPU cores."
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "RAM in MB."
  type        = number
  default     = 4096
}

variable "disk_size_gb" {
  description = "Primary disk size in GB. Must be >= the template's disk size (Proxmox can only grow a cloned disk)."
  type        = number
  default     = 32
}

variable "disk_datastore" {
  description = "Proxmox storage/datastore id for the VM disk."
  type        = string
  default     = "WD_Black_Pool"
}

variable "network_bridge" {
  description = "Network bridge to attach the VM NIC to."
  type        = string
  default     = "vmbr0"
}

variable "ip_config" {
  description = "Static IP in CIDR form (e.g. \"192.168.1.50/24\"), or \"dhcp\" to use DHCP."
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "Gateway IP, required when ip_config is a static CIDR. Ignored for dhcp."
  type        = string
  default     = null
}

variable "vm_username" {
  description = "Default user created via cloud-init."
  type        = string
}

variable "vm_password" {
  description = "Password for vm_username, set via cloud-init."
  type        = string
  sensitive   = true
  default     = null
}

variable "ssh_public_key" {
  description = "Optional SSH public key injected via cloud-init for vm_username."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the VM in Proxmox."
  type        = list(string)
  default     = []
}
