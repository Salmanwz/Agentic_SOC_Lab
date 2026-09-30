locals {
  is_static_ip = var.ip_config != "dhcp"
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  vm_id     = var.vm_id
  node_name = var.node_name
  tags      = var.tags

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.disk_datastore
    interface    = "scsi0"
    size         = var.disk_size_gb
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    datastore_id = var.disk_datastore

    user_account {
      username = var.vm_username
      password = var.vm_password
      keys     = var.ssh_public_key == null ? [] : [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = local.is_static_ip ? var.ip_config : "dhcp"
        gateway = local.is_static_ip ? var.gateway : null
      }
    }
  }

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      clone,
    ]
  }
}
