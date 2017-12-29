# vi: set ft=ruby :
Vagrant.configure('2') do |config|

  # ======================================
  # Definitions for the VirtualBox machine
  # ======================================

  config.vm.define 'default', autostart: true do |vbox|
    vbox.vm.provider 'virtualbox' do |v, override|
      v.memory = 2048
			v.cpus = 2
			override.nfs.functional = false
    end

    vbox.vm.box = 'centos/7'

    if Vagrant.has_plugin?("vagrant-cachier")
      # Configure cached packages to be shared between instances of the same
      # base box. More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
      config.cache.scope = :box

      # OPTIONAL: If you are using VirtualBox, you might want to use that to
      # enable NFS for shared folders. This is also very useful for
      # vagrant-libvirt if you want bi-directional sync
      config.cache.synced_folder_opts = {
        type: :nfs,
        # The nolock option can be useful for an NFSv3 client that wants to
        # avoid the NLM sideband protocol. Without this option, apt-get might
        # hang if it tries to lock files needed for /var/cache/* operations.
        # All of this can be avoided by using NFSv4 everywhere. Please note
        # that the tcp option is not the default.
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
      # For more information please check:
      # http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
    end

    vbox.vm.provision 'shell', inline: 'yum -y update; yum -y install python nfs-utils'
    vbox.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/bootstrap.yml'
    end
  end
end
