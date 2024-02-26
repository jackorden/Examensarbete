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

    endpoint = var.virtual_environment_endpoint
    api_token = var.virtual_environment_password
# Uses http instead of https
    insecure = true
}