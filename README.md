# bazaar

I have two goals for this project:
    1. Learn and become more familiar with infrastructure provisioning tools and configuration tools. 
    2. Create a development environment for friends to launch web apps and become familiar with docker and containers.

In this project I will provision a minilab cluster (4 nodes) for easy deployment and monitoring of containerized services and jobs. I will use as much automation as is reasonable to go from bare metal debian OS to Proxmox VE to host Virtual Machines and deploy any mix of orchestration tools (Docker Swarm, Nomad, K8s) with a push of a button. 

Tools chosen:

Hypervisor: Proxmox VE
Configuration Manager: Ansible
Operating Systems: debian
Virtual Machine deployment method: cloud-init debian (other OSs supported)
Container Orchestration: Docker Swarm (Nomad or K8s in the future)

