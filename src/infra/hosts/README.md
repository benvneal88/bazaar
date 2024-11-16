### Setting up New Hosts

On the new host, run these commands to enable root SSH into the host.
    
    su - root
    apt-get install curl

    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts/init/enable_root_ssh.sh
    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts/init/public_key.pub

    chmod +x init.sh
    ./init.sh


Test ssh authentication is working. SSH with key file will bypass a password requirement.

    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@192.168.1.195
    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@192.168.1.11
    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@192.168.1.151


# First Time Setup

On the control host which can be the local machine. Setup Ansigle

Install Ansbile
    brew install ansible

Congiure hosts file at `src/infra/hosts/inventory.yml`

Verify hosts are running

    ansible -i src/infra/hosts/inventory.yml all -m ping


# Manage Nodes

Run the ansible playbooks to install Proxmox VE on a new debian image.

    ansible-playbook -i src/infra/hosts/inventory.yml src/infra/hosts/playbooks/configure_networking.yml
    ansible-playbook -i src/infra/hosts/inventory.yml src/infra/hosts/playbooks/configure_proxmox_cluster.yml

Some manual steps are need to add a new node to the Proxmox VE cluster

    pvecm add "{host_node_ip}"

