#!/bin/bash -eux

# Install Ansible.
yum -y install ansible
if (test -e foo); then
	echo 'foo'
fi
