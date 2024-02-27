# Tango AB - Testing environment

## Configuration of Proxmox

- Version: 8.1.3
- Hostname: pve
- Username: root
- IP Address: 10.6.67.221/24
- Gateway: 10.6.67.1/24
- Port: 8006

### Storage

- local: Here is where ISO images, CT containers and backups are stored.
- local-lvm: Here is where the VM disks and corresponding cloudinit and CT volumes are stored. The templates used by the VMs are also stored here.

![storage](images/image5.png)

### VM template

In order to automate the creation of virtual machines they are cloned from a template. The image used to create the template, which the test VMs are based on, is a cloud image.  

"ubuntu-22.04-minimal-cloudimg-amd64.img" is the cloud image used to create the template "ubuntu-2204-template1" in this testing environment.

On the Proxmox node "pve" the cloud image is installed using the shell command `wget`

```bash
wget https://cloudimages.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img" 
```

#### These are the non-default settings used to create the  VM template

- Name: ubuntu-2204-template1
- VMID: 1000
- Do not use any media
- Qemu Agent: Enabled
- Delete scsi0 disk
- Add CloudInit Drive: local-lvm
- CloudInit settings
  
![cloudinit](images/image1.png)

#### Shell

Afterwards, some shell commands are executed on the Proxmox node "pve". If a new testing template is needed, replace [vmid], [old_image_name], [image_name] and [size] with corresponding values.  

To be able to see the VM later through the console in Proxmox and configure it:  

```bash
qm set [vmid] --serial0 socket --vga serial0 
```

The image is renamed so it has the .qcow2 as the extension, otherwise Proxmox won't be able to use it:

```bash
mv [old_image_name] [image_name].qcow2" 
```

Next, the image is resized before using it in Proxmox:

```bash
qemu-img resize [image_name] [size] 
``` 

The template size in this environment is 32GB.

Before the disk is imported to the storage "local-lvm", the "qemu-guest-agent" is installed directly on the image, which is a daemon that exchanges information between the host and guest:

```bash
sudo apt install guestfs-tools
virt-customize –a [image_name] --install qemu-guest-agent 
qm importdisk [vmid] [image_name] local-lvm 
```

#### GUI
Now we move from the shell to the GUI, and under the template, the disk that just got imported is added:

![disk](images/image3.png)

##### Thereafter, these non-default settings are changed
- The scsi0 is enabled and the boot order is changed to this:
![bootorder](images/image2.png)

- Start at boot: Yes

The template is finalized after right clicking the VM "ubuntu-2204-template1" and clicking "Convert to template".

**NOTE:** After converting the VM to a template, changes can no longer be made, make sure all the desired settings are set before doing so. If the testing template needs to be updated, start over from the beginning. If a new testing template is to be created using the same cloud image, you start from this step:

```bash
qm importdisk [vmid] [image_name] local-lvm
```

### Terraform

Terraform is the tool used to provision the VMs inside this testing environment. In order to use it an endpoint, an API-token and a provider API are needed:

- Endpoint: https://10.6.67.221:8006
- API-token was created in Proxmox and stored in the file "credentials.tf". This is used to connect to the Proxmox node "pve" through Terraform.
![api-token](images/image4.png)

- Provider API: "bpg/proxmox"
- Version: ">= 0.46.6"

https://registry.terraform.io/providers/bpg/proxmox/latest


[Link to Code File](Terraform)

#### Cloud-init

The testing template "ubuntu-2204-template1" uses Cloud-init, which means that the settings which were set applies to every VM created using said template. However, these settings can be overridden if we specify these Cloud-init settings inside the .tf file that is applied through `Terraform apply`

### Ansible

#### Installation and configuration of Ansible

This command is used  

```bash
ansible-playbook playbook.yml -i inventory.ini --extra-vars "@passwd.yml" --ask-vault-pass --ssh-common-args='-o StrictHostKeyChecking=no'
```


### Docker 
Docker 
Docker Compose 
 
### Configuration of Github 
 
#### Configuration of Github Actions 
Github Actions CI/CD 
Runners 
Workflows 
Ansible-lint 
.yml 
Testing 
Changes in docker-compose triggers a workflow that spins up a docker container and tests the code 

### Deployment

Deploying the whole testing environment with a oneliner.

```bash
cd Terraform/ && terraform apply -auto-approve && cd .. && ansible-playbook playbook.yml -i inventory.ini --extra-vars "@passwd.yml" --ask-vault-pass --ssh-common-args='-o StrictHostKeyChecking=no'
```


