### Setting up a new host


Run this locally to enable remote SSH
    
    su - root
    apt-get install curl

    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts.yaml
    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts/init.sh
    curl -O https://raw.githubusercontent.com/benvneal88/bazaar/refs/heads/main/src/infra/hosts/public_key.pub
    
    chmod +x init.sh
    ./init.sh


Test ssh is enabled:

    ssh -i '~/.ssh/bazaar_root_key' -o StrictHostKeychecking=no bazaaradmin@192.168.1.151