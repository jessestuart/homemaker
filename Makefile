SHELL = /bin/sh

.PHONY: default
default:
	vagrant up default

# ============================
# Ansible tasks.
# ============================

.PHONY: lint test
lint:
	@PLAYBOOK ?= $1
	ansible-lint "./ansible/$PLAYBOOK" -x "ANSIBLE0004,ANSIBLE0010"

.PHONY: clean
clean:
	@rm -rf **/*.retry
	@rm -rf ./packer/packer_cache
	vagrant destroy

.PHONY: all
all:
	@echo "Building all:"
	# TODO

.PHONY: provision
provision:
	vagrant provision default

.PHONY: galaxy
galaxy:
	@echo "Installing Ansible Galaxy dependencies."
	-@ansible-galaxy install -i -r ./ansible/requirements.yml &>/dev/null

.PHONY: create_users
create_users:
	@echo ""
	@echo "Running playbook to create SSH users."
	ansible-playbook -i hosts/all provision.yml

