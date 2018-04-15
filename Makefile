SHELL = /bin/sh

.PHONY: clean
clean:
	rm -rf **/*.retry
	rm -rf ./packer/packer_cache
	vagrant destroy

# ============================
# Available vagrant builders:
# 1) CentOS 7 (VM)
# 2) Arch Linux (VM)
# 3) CentOS 7 (Docker)
# ============================

.PHONY: all
all:
	vagrant provision default

.PHONY: default build-centos
default:
	vagrant up --provision

.PHONY: build-arch
arch:
	vagrant up arch --provision

.PHONY: build-docker
docker:
	vagrant up docker --provision

# ============================
# Ansible tasks.
# ============================

.PHONY: lint test
lint:
	@PLAYBOOK ?= $1
	ansible-lint "./ansible/$PLAYBOOK" -x "ANSIBLE0004,ANSIBLE0010"

.PHONY: galaxy
galaxy:
	@echo "Installing Ansible Galaxy dependencies."
	-@ansible-galaxy install -i -r ./ansible/requirements.yml &>/dev/null

.PHONY: create-users
create_users:
	@echo "Running playbook to create SSH users."
	ansible-playbook -i hosts/all provision.yml -t ssh-users
