# vi: set ft=ruby :
Vagrant.configure('2') do |config|

  # ======================================
  # Definitions for the VirtualBox machine
  # ======================================

  config.cache.auto_detect = true
  config.vm.define 'virtualbox', autostart: true do |vbox|
    vbox.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end
    # vbox.vm.box = 'alpine/alpine64'
    vbox.vm.box = 'centos/7'
    # vbox.vm.network 'forwarded_port', guest: 80, host: 8080
    vbox.vm.provision :ansible do |ansible|
      ansible.playbook = 'bootstrap.yml'
      ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
    end
  end

  # ====================================
  # Definitions for the Docker container
  # ====================================

  config.vm.define 'docker', autostart: true do |docker|
    docker.vm.provider 'docker' do |d, override|
      override.vm.box = nil
      override.vm.allowed_synced_folder_types = :rsync
      d.image = "jdeathe/centos-ssh:centos-7-2.2.3"
      d.name = "linux-dev-workstation"
      d.remains_running = true
      d.has_ssh = true
      d.force_host_vm = false
      d.env = {
        :SSH_USER => 'vagrant',
        :SSH_SUDO => 'ALL=(ALL) NOPASSWD:ALL',
        :LANG     => 'en_US.UTF-8',
        :LANGUAGE => 'en_US:en',
        :LC_ALL   => 'en_US.UTF-8',
        :SSH_INHERIT_ENVIRONMENT => 'true',
      }
      # There is no newline after the existing insecure key, so the new key ends
      # up on the same line and breaks SSH
      override.ssh.insert_key = false
      override.ssh.proxy_command = "docker run -i --rm --link linux-dev-workstation alpine/socat - TCP:linux-dev-workstation:22,retry=3,interval=2"
    end

    docker.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", inline:
      "ps aux | grep 'sshd:' | awk '{print $2}' | xargs kill"
    docker.vm.provision 'jhell', inline: 'yum -y update; yum -y install rsync python2-dev'

    docker.vm.provision :ansible do |ansible|
      ansible.playbook = 'bootstrap.yml'
      ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
    end
  end

end
