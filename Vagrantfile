# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  # ======================================
  # Definitions for the VirtualBox machine
  # ======================================
  config.vm.define 'virtualbox', autostart: true do |vbox|
    vbox.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end
    vbox.vm.box = 'alpine/alpine64'
    vbox.vm.network 'forwarded_port', guest: 80, host: 8080
    vbox.vm.network 'forwarded_port', guest: 5050, host: 5050
    vbox.vm.provision 'shell', inline: 'apk update; apk add python2-dev'
    vbox.vm.provision :ansible do |ansible|
      ansible.playbook = 'bootstrap.yml'
    end
  end

  # --------------------------------------------------------------------
  # Definitions for the Docker container
  # --------------------------------------------------------------------
  #config.vm.define 'docker', autostart: true do |dkr|
  #  system('bash genkeys.sh')
  #  dkr.vm.provider 'docker' do |d|
  #    d.has_ssh = true
  #    d.build_dir = '.'
  #  end

  #  dkr.ssh.private_key_path = 'keys/vagrantssh.key'
  #  dkr.ssh.username = 'vagrant'

  #  dkr.vm.provision :ansible do |ansible|
  #    ansible.playbook = 'playbook.yml'
  #    ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
  #    # ansible.verbose = 'vvvv'
  #  end
  #  dkr.vm.synced_folder '.', "/vagrant"
  #  # Tell the user what to do next
  #  dkr.vm.provision 'shell', inline: "echo 'Finished! Now try logging in with: vagrant ssh docker'"
  #end
end
