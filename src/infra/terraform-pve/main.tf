resource "proxmox_vm_qemu" "vm1" {
  name       = "example-vm"
  target_node = "bazaar-1"
  cores      = 2
  memory     = 2048
  disk {
    size = "32G"
    storage = "local-lvm"
  }
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
}
