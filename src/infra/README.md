### Setting up a new host


Run this locally to enable remote SSH
    
    su - root
    curl -O https://github.com/benvneal88/bazaar/blob/main/src/infra/hosts.yaml
    curl -O https://github.com/benvneal88/bazaar/blob/main/src/infra/host_init.sh

    ./host_init.sh


Test ssh is enabled:

    ssh -i '/Users/ben/.ssh/bazaar_root_key' -o StrictHostKeychecking=no root@IPADDRESS