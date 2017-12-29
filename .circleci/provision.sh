#!/bin/sh

EXTPACK_NAME="Oracle_VM_VirtualBox_Extension_Pack-4.3.36.vbox-extpack"

# Add apt-key sources for virtualbox.
apt-get -y update
apt-get -y install sudo wget curl
wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc | apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian precise non-free contrib" >>/etc/apt/sources.list.d/virtualbox.org.lists
# Install the bare-minimum dependencies to allow us to connect
# via Ansible, even in CI.
apt-get update -y
apt-get install -y linux-headers-$(uname -r) build-essential virtualbox dkms python ansible

wget http://download.virtualbox.org/virtualbox/4.3.36/$EXTPACK_NAME -O /tmp/$EXTPACK_NAME
VBoxManage extpack install "$EXTPACK_NAME"
wget https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb -O /tmp/vagrant_2.0.1_x86_64.deb
dpkg -i vagrant_2.0.1_x86_64.deb
