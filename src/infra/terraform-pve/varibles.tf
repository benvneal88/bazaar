variable "pve_tf_password" {
  description = "Password for Proxmox user"
  type        = string
  sensitive   = true
}

variable "pve_tf_user" {
  description = "Password for Proxmox user"
  type        = string
}

variable "pve_ip_address" {
  description = "IP address for primary pve node"
  type        = string
}

variable "pve_port" {
  description = "Port for primary pve node"
  type        = string
}

variable "pve_domain" {
  description = "Proxmox default domain"
  type        = string
}

variable "pve_default_node" {
  description = "Proxmox default noe"
  type        = string
}
