# vi: set ft=ruby :
Vagrant.configure('2') do |config|

  # =======================================
  # Definitions for the VirtualBox machine.
  # =======================================

  config.vm.define 'default', autostart: true do |vbox|
    vbox.vm.box = 'centos/7'
    vbox.vm.provider 'virtualbox' do |v, override|
      v.memory = 2048
      v.cpus = 2
      override.nfs.functional = false
    end

    config.ssh.insert_key = true

    vbox.vm.provision 'shell', inline: 'yum -y update; yum -y install python'
    vbox.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/bootstrap.yml'
    end
  end

  config.vm.define 'arch', autostart: false do |vbox|
    vbox.vm.box = 'archlinux/archlinux'
    vbox.vm.provider 'virtualbox' do |v, override|
      v.memory = 2048
      v.cpus = 2
      override.nfs.functional = false
    end

    config.ssh.insert_key = true

    vbox.vm.provision 'shell', inline: 'test -e /usr/bin/python || yes | pacman -S python'
    vbox.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/bootstrap.yml'
      ansible.verbose = true
    end
  end

  # ======================================
  # Definitions for the Docker machine.
  # ======================================

  config.vm.define 'docker', autostart: true do |d|
    d.vm.provider :docker do |docker, override|
      override.vm.box = nil
      override.vm.allowed_synced_folder_types = :rsync if ENV.has_key?('CIRCLECI')
      docker.image = "jdeathe/centos-ssh:centos-7-2.3.0"
      docker.name = "homemaker"
      docker.remains_running = true
      docker.has_ssh = true
      docker.env = {
        :SSH_USER => 'vagrant',
        :SSH_SUDO => 'ALL=(ALL) NOPASSWD:ALL',
        :LANG     => 'en_US.UTF-8',
        :LANGUAGE => 'en_US:en',
        :LC_ALL   => 'en_US.UTF-8',
        :SSH_INHERIT_ENVIRONMENT => 'true',
      }
      override.ssh.proxy_command = "\
        docker run -i --rm --link homemaker alpine/socat - \
          TCP:homemaker:22,retry=3,interval=2 \
      "
    end
    d.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/bootstrap.yml'
      ansible.extra_vars = {
        user: 'vagrant'
      }
    end
  end

end
