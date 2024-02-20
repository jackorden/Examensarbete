# Examensarbete

Enable passwordless SSH to be able to run ansible on the hosts.

How to run playbook:
ansible-playbook playbook.yml -i inventory.ini --extra-vars "@passwd.yml" --ask-vault-pass
