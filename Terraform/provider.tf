terraform {

    required_version = ">= 0.14"

    required_providers {
        proxmox = {
            source = "bpg/proxmox"
            version = ">= 0.46.6"
        }

    }

}

provider "proxmox" {

    endpoint = "https://10.6.67.221:8006"
    api_token = "root@pam!terraform=f337998e-a057-44f1-bf6f-32bcd68031e9"
# Kräver ej https
    insecure = true
}