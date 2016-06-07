# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

  config.vm.box = "centos/7"

  config.vm.define :server do |host|
    HOSTNAME = "server"
    PRIVATE_IP_ADDRESS = "192.168.33.10"

    host.vm.hostname = HOSTNAME
    host.vm.network "private_network", ip: PRIVATE_IP_ADDRESS
    host.vm.provision :shell, path: "stop-firewall.sh"
    host.vm.provision :shell, path: "set-hosts.sh"
    host.vm.provision :shell, path: "install-sensu-server.sh"
  end

  config.vm.define :client01 do |host|
    HOSTNAME = "client01"
    PRIVATE_IP_ADDRESS = "192.168.33.20"
    ARGS = HOSTNAME + " " + PRIVATE_IP_ADDRESS

    host.vm.hostname = HOSTNAME
    host.vm.network "private_network", ip: PRIVATE_IP_ADDRESS
    host.vm.provision :shell, path: "stop-firewall.sh"
    host.vm.provision :shell, path: "set-hosts.sh"
    host.vm.provision :shell, path: "install-sensu-client.sh", args: ARGS
  end

end
