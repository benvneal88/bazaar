### Setting up New Hosts

On the new host, run these commands to enable root SSH into the host.
    
    su - root
    apt-get install curl

    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts/init/bin/enable_root_ssh.sh
    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts/init/keys/node_key.pub

    chmod +x enable_root_ssh.sh
    ./enable_root_ssh.sh


Test ssh authentication is working. SSH with key file will bypass a password requirement.

    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@192.168.1.195
    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@192.168.1.11
    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@192.168.1.151


## First Time Setup

On the control host which can be the local machine. Setup Ansigle

Install Ansbile
    brew install ansible

Congiure hosts file at `src/ansible/inventory/{env}/hosts.yml`

     cd src/ansible

Verify PVE nodes are running:

    ansible -i inventory/dev/hosts.yml pve_nodes -m ping

Reboot PVE nodes if needed:

    ansible all -i inventory/dev/hosts.yml -b -m reboot --become


## Setup Proxmox Virtual Environment Cluster

Run the ansible playbooks to install Proxmox VE on a new debian image.

    ansible-playbook -i inventory/dev/hosts.yml playbooks/deploy.pve_step1.yml

Some manual steps are need to add a new node to the Proxmox VE cluster

    pvecm add "{host_node_ip}"


## Setup PVE Virtual Machines

Once the Nodes are configured with PVE and added to the cluster create the VMs:

    ansible-playbook -i inventory/dev/hosts.yml playbooks/deploy.pve_step2.yml
    ansible-playbook -i inventory/dev/hosts.yml playbooks/deploy.vms.yml

# Start and Stop VMs

    ansible-playbook -i inventory/dev/hosts.yml playbooks/start.vms.yml
    ansible-playbook -i inventory/dev/hosts.yml playbooks/stop.vms.yml

# SSH into VMs
    ssh -i src/init/keys/vm_key -o StrictHostKeyChecking=no admin@<vm_ip_address>

    ssh -i src/init/keys/vm_key -o StrictHostKeyChecking=no admin@192.168.1.10
    ssh -i src/init/keys/vm_key  admin@192.168.1.22 -o StrictHostKeyChecking=no
    
    ansible -i inventory/dev/hosts.yml vms -m ping

# Setup Docker Swarm

    ansible-playbook -i inventory/dev/hosts.yml playbooks/deploy.swarm.yml

# Deploy Stack to Docker Swarm

    ansible-playbook -i inventory/dev/hosts.yml playbooks/deploy.stack.yml

    docker login https://192.168.1.10:5000
    curl -v --cacert /etc/ssl/certs/registry_ca.crt https://192.168.1.10:5000/v2/


<!-- 

## Setup Proxmox VMs


We will use Terraform to manage the resources within Proxmox

Install Terraform on your local machine

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    brew update
    brew upgrade hashicorp/tap/terraform


Create Proxmox User for Terraform

SSH into the a PVE host:

    pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
    pveum user add terraform-prov@pve --password <password>
    pveum aclmod / -user terraform-prov@pve -role TerraformProv

Follow Terraform-for-Promox installation instructions to set up the proxmox provider

https://github.com/Terraform-for-Proxmox/terraform-provider-proxmox
https://registry.tf-registry-prod-use1.terraform.io/providers/Terraform-for-Proxmox/proxmox/latest/docs/guides/installation


    git clone git@github.com:Terraform-for-Proxmox/terraform-provider-proxmox.git
    cd terraform-provider-proxmox
    go install github.com/Terraform-for-Proxmox/terraform-provider-proxmox/v2@latest
    make
    version=0.0.1
    arch=linux_arm64
    mkdir -p ~/.terraform.d/plugins/local.registry.com/Terraform-for-Proxmox/proxmox/${version}/${linux_arm64}/
    cp bin/terraform-provider-proxmox ~/.terraform.d/plugins/local.registry.com/Terraform-for-Proxmox/proxmox/${version}/${linux_arm64}/
    ls -al ~/.terraform.d/plugins/local.registry.com/Terraform-for-Proxmox/proxmox/${version}/${linux_arm64}/ -->


## Troubleshooting Networking

    cat /etc/network/interfaces


## Initializing VMs for Terraform

Use clout-init image to create a template

https://pve.proxmox.com/wiki/Cloud-Init_Support
https://github.com/Terraform-for-Proxmox/terraform-provider-proxmox/blob/master/docs/guides/cloud_init.md

https://registry.tf-registry-prod-use1.terraform.io/providers/Terraform-for-Proxmox/proxmox/latest/docs/guides/cloud_init

Copy vm keys to the Proxmox node. These will get added to the VM and the proxmox nodes

    scp -i ~/.ssh/bazaar_root_key /Users/ben/dev/bazaar/src/infra/hosts/init/keys/vm_key.pub  root@192.168.1.195:/root/.ssh/vm_key.pub
    scp -i ~/.ssh/bazaar_root_key /Users/ben/dev/bazaar/src/infra/hosts/init/keys/vm_key  root@192.168.1.195:/root/.ssh/vm_key


Create 


## Set up Minio for Object Storage


minio/minio

version: '3.8'

services:
  minio:
    image: minio/minio
    container_name: minio-1
    restart: always
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: admin
      MINIO_ROOT_PASSWORD: adminpishi
    volumes:
      - /share/CACHEDEV1_DATA/Container/container-station-data/application/mino-1:/data
    command: server /data --console-address :9001

