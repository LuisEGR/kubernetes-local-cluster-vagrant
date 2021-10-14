# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"



  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
#   config.vm.network "public_network", bridge: "TP-Link Wireless Nano USB Adapter"
#   config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)", use_dhcp_assigned_default_route: true
  #Automatic ipv6 support
  config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)", use_dhcp_assigned_default_route: true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  
#   config.vm.hostname = "masterk8s"
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
     vb.cpus = "2"
  end

  config.vm.provision "file", source: "./calico.yaml", destination: "calico.yaml"
  config.vm.provision "file", source: "./kubeadm-config.yaml", destination: "kubeadm-config.yaml"
  config.vm.provision "file", source: "./ip-masq-agent.yaml", destination: "ip-masq-agent.yaml"
  config.vm.provision "file", source: "./nginx.yaml", destination: "nginx.yaml"
  config.vm.provision "file", source: "./metallb-cfg.yaml", destination: "metallb-cfg.yaml"
  config.vm.provision "file", source: "./metrics-server.yaml", destination: "metrics-server.yaml"

  config.vm.provision "shell", path: "all.sh"
  config.vm.provision "shell", path: "user.sh", privileged: false
#   config.vm.provision "shell", path: "containerd_prereq.sh"
#   config.vm.provision "shell", path: "install.sh"
#   config.vm.provision "shell", path: "configure.sh"
end