terraform {
  required_providers {
    proxmox = {
      source  = "Terraform-for-Proxmox/proxmox"
      version = ">=0.0.1"
    }
  }
}

provider "proxmox" {
    pm_api_url = "https://${var.pve_ip_address}:${var.pve_port}/api2/json"
    pm_password = var.pve_tf_password
    pm_user = var.pve_tf_user
    pm_tls_insecure = true
}
