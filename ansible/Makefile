galaxy:
	@echo ""
	@echo "Installing Ansible Galaxy dependencies."
	@ansible-galaxy install -i -r requirements.yml

create_users:
	@echo ""
	@echo "Running playbook to create SSH users."
	@ansible-playbook -i hosts/all provision.yml
