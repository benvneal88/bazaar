#!/bin/bash

##############################################################################
# things to double-check:
# 1. user directory
# 2. your SSH key location
# 3. which bridge you assign with the create line (currently set to vmbr100)
# 4. which storage is being utilized (script uses local-zfs)
##############################################################################



IMAGE_NAME="debian-12-genericcloud-arm64-20241110-1927"
DISK_IMAGE="$IMAGE_NAME.qcow2"
IMAGE_TEMPLATE_NAME="$IMAGE_NAME-cloudinit-template"
IMAGE_URL="https://cdimage.debian.org/images/cloud/bookworm/20241110-1927/$DISK_IMAGE"


# Download the disk image
rm -f "$DISK_IMAGE"
wget -q "$IMAGE_URL"


sudo virt-customize -a "$DISK_IMAGE" --install qemu-guest-agent
sudo virt-customize -a "$DISK_IMAGE" --ssh-inject root:file:/root/.ssh/vm_key.pub

if sudo qm list | grep -qw "9022"; then
    sudo qm destroy 9022
fi

sudo qm create 9022 --name "$IMAGE_TEMPLATE_NAME" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr100
sudo qm importdisk 9022 "$DISK_IMAGE" local-zfs
sudo qm set 9022 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9022-disk-0
sudo qm set 9022 --boot c --bootdisk scsi0
sudo qm set 9022 --ide2 local-zfs:cloudinit
sudo qm set 9022 --serial0 socket --vga serial0
sudo qm set 9022 --agent enabled=1
sudo qm template 9022

echo "Next up, clone VM, then expand the disk"
echo "You also still need to copy ssh keys to the newly cloned VM"