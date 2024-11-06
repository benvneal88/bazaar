### Setting up a new host


Run this locally to enable remote SSH
    
    su - root
    apt-get install curl

    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts.yaml
    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/host_init.sh

    chmod +x host_init.sh
    ./host_init.sh


Test ssh is enabled:

    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no bazaaradmin@192.168.1.151