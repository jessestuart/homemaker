# vi: set ft=ruby :
Vagrant.configure('2') do |config|

  # # ======================================
  # # Definitions for the VirtualBox machine
  # # ======================================
  config.vm.define 'virtualbox', autostart: true do |vbox|
    vbox.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end
    vbox.vm.box = 'alpine/alpine64'
    # vbox.vm.network 'forwarded_port', guest: 80, host: 8080
    vbox.vm.provision 'shell', inline: 'apk update; apk add python2-dev'
    vbox.vm.provision :ansible do |ansible|
      ansible.playbook = 'bootstrap.yml' end
  end

  # ====================================
  # Definitions for the Docker container
  # ====================================

  config.vm.define 'docker', autostart: true do |dkr|
    # system('bash bin/generate_keys.sh')
    dkr.vm.provider 'docker' do |d, override|
      override.vm.box = nil
      override.vm.allowed_synced_folder_types = :rsync
      d.image = "jdeathe/centos-ssh:centos-7-2.2.3"
      d.name = "linux-dev-workstation"
      d.remains_running = true
      d.has_ssh = true
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

    # dkr.ssh.private_key_path = 'keys/vagrantssh.key'
    # dkr.ssh.username = 'vagrant'

    dkr.vm.provision 'shell', inline: 'apk update; apk add python2-dev'
    # dkr.vm.provision :ansible do |ansible|
    #   ansible.playbook = 'bootstrap.yml'
    # end

    # dkr.vm.provision :ansible do |ansible|
    #   ansible.playbook = 'bootstrap.yml'
    #   ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
    #   ansible.verbose = 'vvvv'
    # end
    # dkr.vm.synced_folder '.', "/vagrant"
  end
end


# config.vm.define 'docker', autostart: false do |dkr|
#   puts dkr
#   config.vm.provider :docker do |docker, override|
#     override.vm.box = nil
#     override.vm.allowed_synced_folder_types = :rsync
#     docker.image = "jdeathe/centos-ssh:centos-7-2.2.3"
#     docker.name = "linux-dev-workstation"
#     docker.remains_running = true
#     docker.has_ssh = true
#     docker.env = {
#       :SSH_USER => 'vagrant',
#       :SSH_SUDO => 'ALL=(ALL) NOPASSWD:ALL',
#       :LANG     => 'en_US.UTF-8',
#       :LANGUAGE => 'en_US:en',
#       :LC_ALL   => 'en_US.UTF-8',
#       :SSH_INHERIT_ENVIRONMENT => 'true',
#     }
#     docker.vm.provision :ansible do |ansible|
#       ansible.playbook = 'bootstrap.yml'
#     end
#     # There is no newline after the existing insecure key, so the new key ends
#     # up on the same line and breaks SSH
#     override.ssh.insert_key = false
#     override.ssh.proxy_command = "docker run -i --rm --link linux-dev-workstation alpine/socat - TCP:linux-dev-workstation:22,retry=3,interval=2"
#   end
# end