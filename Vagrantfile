# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/precise64'
  config.vm.provision :shell, path: 'bootstrap.sh'
  config.vm.network 'forwarded_port', guest: 80, host: 8000
end
