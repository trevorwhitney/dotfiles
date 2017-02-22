Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: <<-SCRIPT
    cd /vagrant
    bin/install.sh
  SCRIPT
end
