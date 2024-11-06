#!/bin/bash

# This script will add enable SSH and add public key (provided by a local NAS) for authentication with Ansisble or another configuration manager  

echo "Installing necessary packages..."
apt-get update
apt-get install -y nfs-common openssh-server


NAS_SERVER_IP_ADDRESS="192.168.1.255"
echo "Identified NAS IP address as $NAS_SERVER_IP_ADDRESS"
NAS_SHARE_DIRECTORY="/cluster_storage/init"

MOUNT_POINT="/mnt/nfs/init"
KEY_PATH="/mnt/nfs/cluster_storage/init"
PUBLIC_KEY_FILE="bazaar_root_key.pub"
PUBLIC_KEY_PATH="$MOUNT_POINT/$PUBLIC_KEY_FILE"



# Create mount point
echo "Creating mount point..."
mkdir -p $MOUNT_POINT

echo "Mounting NAS NFS share..."
mount -t nfs $NAS_SERVER_IP_ADDRESS:$NAS_SHARE_DIRECTORY $MOUNT_POINT

# Check if the public key file exists
if [ ! -f "$PUBLIC_KEY_PATH" ]; then
  echo "Error: Public key file $PUBLIC_KEY_PATH not found."
  umount $MOUNT_POINT
  exit 1
fi

# Ensure SSH directory exists and set correct permissions
echo "Configuring SSH directory and permissions..."
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Add public key to authorized_keys
echo "Adding public key to /root/.ssh/authorized_keys..."
cat $PUBLIC_KEY_PATH >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Unmounting NFS share..."
umount $MOUNT_POINT

# Configure SSH to allow root login with key-based authentication
echo "Configuring SSH to allow root login with key-based authentication..."
sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH service
echo "Restarting SSH service..."
systemctl restart ssh


