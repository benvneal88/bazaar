variable "proxmox_api_password" {
  description = "Password for Proxmox user"
  type        = string
  sensitive   = true
}


variable "proxmox_api_user" {
  description = "Password for Proxmox user"
  type        = string
  default = "terraform-prov@pve"
}

variable "proxmox_api_node" {
    description = "Main Proxmox node for tf api calls"
    default = {
        ip_address = "192.168.1.195"
        port = "8006"
    }
}

