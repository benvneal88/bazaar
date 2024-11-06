#!/bin/bash

# This script will add enable SSH and add public key for authentication with Ansisble or another configuration manager  


PUBKEY_FILE="public_key.pub"
# Define the path to the authorized_keys file
AUTHORIZED_KEYS_FILE="$HOME/.ssh/authorized_keys"


echo "Installing necessary packages..."
apt-get update
apt-get install -y openssh-server

if [[ ! -f "$PUBKEY_FILE" ]]; then
    echo "Public key file '$PUBKEY_FILE' not found."
    exit 1
fi

# Ensure the .ssh directory exists and has correct permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Ensure the authorized_keys file exists and has correct permissions
touch "$AUTHORIZED_KEYS_FILE"
chmod 600 "$AUTHORIZED_KEYS_FILE"

# Read the public key from the file
PUBKEY=$(<"$PUBKEY_FILE")

# Check if the key is already in authorized_keys
if grep -qxF "$PUBKEY" "$AUTHORIZED_KEYS_FILE"; then
    echo "Key already exists in '$AUTHORIZED_KEYS_FILE'."
else
    # Step 6: Append the key to authorized_keys
    echo "$PUBKEY" >> "$AUTHORIZED_KEYS_FILE"
    echo "Key added to '$AUTHORIZED_KEYS_FILE'."
fi


# # Configure SSH to allow root login with key-based authentication
# echo "Configuring SSH to allow root login with key-based authentication..."
# sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
# sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
# sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH service
echo "Restarting SSH service..."
systemctl restart ssh


