resource "proxmox_virtual_environment_vm" "tango-test1" {
    
    for_each = {
        for index,vm in var.vm_config:
        vm.name => vm
    }

    name        = each.value.name
    description = "Created by Terraform"
    node_name = "pve"

    clone {
        vm_id = each.value.vmid_to_clone
    }

    cpu {
        cores = each.value.cpu
        type = "host"
        numa = true
    }
    memory {
        dedicated = each.value.ram
    }
    network_device {
        bridge = "vmbr0"
        model = "virtio"
    }

    disk {
        datastore_id = "local-lvm"
        file_format = "raw"
        interface = "scsi0"
        size = each.value.size
    }

    operating_system {
        type = "l26"
    }
    machine = "q35"
    agent {
        enabled = true
    }

    initialization {
        ip_config {
            ipv4 {
                address = format("%s%s%s","10.6.67.",222 + each.value.idx,"/24")
                gateway = "10.6.67.1"
            }
        }
 
    }
}