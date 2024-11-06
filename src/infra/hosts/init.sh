#!/bin/bash

# This script will add enable SSH and add public key (provided by a local NAS) for authentication with Ansisble or another configuration manager  

echo "Installing necessary packages..."
apt-get update
apt-get install -y openssh-server

# Ensure SSH directory exists and set correct permissions
echo "Configuring SSH directory and permissions..."
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Add public key to authorized_keys
echo "Adding public key to /root/.ssh/authorized_keys..."
mv "public_key.pub" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Configure SSH to allow root login with key-based authentication
echo "Configuring SSH to allow root login with key-based authentication..."
sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH service
echo "Restarting SSH service..."
systemctl restart ssh


