terraform {
  required_providers {
    proxmox = {
      source  = "Terraform-for-Proxmox/proxmox"
      version = ">=0.0.1"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.proxmox_api_node.ip_address}:{${var.proxmox_api_node.port}}/api2/json"
  pm_user    = var.proxmox_api_user
  #pm_password = var.proxmox_password
  pm_tls_insecure = true
}
