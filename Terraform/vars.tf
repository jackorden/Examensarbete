variable "vm_config" {
    type = list(object({
        idx = number
        name = string
        vmid_to_clone = number
        cpu = number
        ram = number
        size = number
    }))
    default = [
    {
        idx = 0
        name = "tango-test1"
        vmid_to_clone = 1000
        cpu = 1
        ram = 2048
        size = 32
    },
    {
        idx = 1
        name = "tango-test2"
        vmid_to_clone = 1000
        cpu = 1
        ram = 2048
        size = 32
    },
    {
        idx = 2
        name = "tango-test3"
        vmid_to_clone = 1000
        cpu = 1
        ram = 2048
        size = 32
    }
    ]
}

test

 