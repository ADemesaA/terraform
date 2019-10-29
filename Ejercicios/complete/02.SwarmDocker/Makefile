show-env:
	@echo "Environment:"
	@echo "--> AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)"
	@echo "--> AWS_SECRET_ACCESS_KEY=*****"
	@echo "--> AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION)"
	@echo "--> PROJECT_NAME=$(PROJECT_NAME)"
	@echo "--> ENVIRONMENT=$(ENVIRONMENT)"
	@echo "--> DOMAIN=$(DOMAIN)"

### Infrastructure
.PHONY: terraform-aws-init
terraform-aws-init:
	cd infrastructure/terraform-aws; terraform init
	
.PHONY: terraform-aws-state
terraform-aws-state:
	cd infrastructure/terraform-aws; terraform state list

.PHONY: terraform-aws-plan
terraform-aws-plan: show-env
	cd infrastructure/terraform-aws; terraform plan -var-file="envs/$(ENVIRONMENT).tfvars" -out=tfplan \
  									 -var="ENVIRONMENT=$(ENVIRONMENT)" \
  									 -var="project_name=$(PROJECT_NAME)" \
  									 -var="domain=$(DOMAIN)"

.PHONY: terraform-aws-apply
terraform-aws-apply:
	cd infrastructure/terraform-aws; terraform apply tfplan
	
.PHONY: terraform-aws-graph
terraform-aws-graph:
	cd infrastructure/terraform-aws; terraform graph > graph.txt

.PHONY: terraform-aws-destroy
terraform-aws-destroy:
	cd infrastructure/terraform-aws; terraform destroy -var-file="envs/$(ENVIRONMENT).tfvars" \
  									 -var="ENVIRONMENT=$(ENVIRONMENT)" \
  									 -var="project_name=$(PROJECT_NAME)" \
  									 -var="domain=$(DOMAIN)"
  									 
### Platform SWARM

.PHONY: ansible-ping
ansible-ping:
	cd platform/ansible; ansible -m ping all --inventory=swarm-inventory.ini --ssh-common-args='-o StrictHostKeyChecking=no -C -F ./ssh.cfg' --private-key=../../cert/id_rsa
	
.PHONY: ansible-install-docker
ansible-install-docker:
	cd platform/ansible; ansible-playbook --inventory=swarm-inventory.ini --ssh-common-args='-o StrictHostKeyChecking=no -C -F ./ssh.cfg' --private-key=../../cert/id_rsa swarm/playbook-docker.yaml

.PHONY: ansible-swarm-create
ansible-swarm-create:
	cd platform/ansible; ansible-playbook --inventory=swarm-inventory.ini --ssh-common-args='-o StrictHostKeyChecking=no -C -F ./ssh.cfg' --private-key=../../cert/id_rsa swarm/playbook-swarm.yaml

.PHONY: swarm-master-ssh
swarm-master-ssh:
	cd infrastructure/terraform-aws; eval "ssh -i ../../cert/id_rsa ec2-user@$$(terraform output leader-public-ip)"

.PHONY: show-dns-details
show-dns-details:
	cd infrastructure/terraform-aws; echo "\n\n\nAdd the next lines to hosts file:\n\n$$(terraform output leader-public-ip)  portainer.$(DOMAIN) traefik.$(DOMAIN)\n$$(terraform output leader-public-ip)  tomcat.$(DOMAIN) jenkins.$(DOMAIN) activemq.$(DOMAIN)\n\n"

.PHONY: swarm-deploy-commons
swarm-deploy-commons:
	cd platform/certificates/; sh generate_keystore.sh
	cd platform/ansible; ansible-playbook --inventory=swarm-inventory.ini --ssh-common-args='-o StrictHostKeyChecking=no -C -F ./ssh.cfg' --private-key=../../cert/id_rsa swarm/playbook-common.yaml
	
.PHONY: swarm-deploy-extras
swarm-deploy-extras:
	cd platform/ansible; ansible-playbook --inventory=swarm-inventory.ini --ssh-common-args='-o StrictHostKeyChecking=no -C -F ./ssh.cfg' --private-key=../../cert/id_rsa playbook-extras.yaml

###
.PHONY: aws-swarm
aws-swarm: terraform-aws-init terraform-aws-plan terraform-aws-apply ansible-install-docker ansible-swarm-create swarm-deploy-commons swarm-deploy-extras show-dns-details
