# All hosts
Host *
# Security
ForwardAgent no
# Connection multiplexing
ControlMaster auto
ControlPersist 2m
ControlPath ~/.ssh/ansible-%r@%h:%p
# Connect through bastion hosts
ProxyCommand ssh -i ../../cert/id_rsa -o StrictHostKeyChecking=no -W %h:%p ec2-user@${swarm_master_public_ip}
