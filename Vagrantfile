# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.synced_folder ".", "/vagrant", type: "smb"
  config.vm.define "admin" do |web|
    config.vm.box = "generic/ubuntu2204"
    # config.vm.network "public_network", bridge: "Public Switch", use_dhcp_assigned_default_route: true
    config.vm.provider "hyperv" do |vb|
      # Customize the amount of memory on the VM:
      vb.maxmemory = "4096"
      vb.memory = "2048"
      vb.cpus = "2"
    end

    config.vm.provision "file", source: "./calico.yaml", destination: "calico.yaml"
    config.vm.provision "file", source: "./kubeadm-config.yaml", destination: "kubeadm-config.yaml"
    config.vm.provision "file", source: "./ip-masq-agent.yaml", destination: "ip-masq-agent.yaml"
    config.vm.provision "file", source: "./nginx.yaml", destination: "nginx.yaml"

    config.vm.provision "shell", path: "all.sh"
    config.vm.provision "shell", path: "user.sh", privileged: false
    config.vm.provision "shell", path: "containerd_prereq.sh"
    config.vm.provision "shell", path: "install.sh"
    config.vm.provision "shell", path: "configure.sh"
  end







  # config.vm.define "worker" do |web|
  #   config.vm.box = "generic/ubuntu2310"
  #   config.vm.network "public_network", bridge: "Public Switch", use_dhcp_assigned_default_route: true

  #   config.vm.provider "hyperv" do |vb|
  #       # Customize the amount of memory on the VM:
  #       vb.maxmemory = "4096"
  #       vb.memory = "2048"
  #       vb.cpus = "2"
  #   end

  #   config.vm.provision "file", source: "./calico.yaml", destination: "calico.yaml"
  #   config.vm.provision "file", source: "./kubeadm-config.yaml", destination: "kubeadm-config.yaml"
  #   config.vm.provision "file", source: "./ip-masq-agent.yaml", destination: "ip-masq-agent.yaml"
  #   config.vm.provision "file", source: "./nginx.yaml", destination: "nginx.yaml"
  
  # end



#   # Create a forwarded port mapping which allows access to a specific port
#   # within the machine from a port on the host machine. In the example below,
#   # accessing "localhost:8080" will access port 80 on the guest machine.
#   # NOTE: This will enable public access to the opened port
#   # config.vm.network "forwarded_port", guest: 80, host: 8080

#   # Create a forwarded port mapping which allows access to a specific port
#   # within the machine from a port on the host machine and only allow access
#   # via 127.0.0.1 to disable public access
# #   config.vm.network "forwarded_port", guest: 80, host: 8081, host_ip: "127.0.0.1"

#   # Create a private network, which allows host-only access to the machine
#   # using a specific IP.
#   # config.vm.network "private_network", ip: "192.168.33.10"

#   # Create a public network, which generally matched to bridged network.
#   # Bridged networks make the machine appear as another physical device on
#   # your network.
# #   config.vm.network "public_network", bridge: "TP-Link Wireless Nano USB Adapter"
# #   config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)", use_dhcp_assigned_default_route: true
#   #Automatic ipv6 support
#   config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)", use_dhcp_assigned_default_route: true

#   # Share an additional folder to the guest VM. The first argument is
#   # the path on the host to the actual folder. The second argument is
#   # the path on the guest to mount the folder. And the optional third
#   # argument is a set of non-required options.
#   # config.vm.synced_folder "../data", "/vagrant_data"

#   # Provider-specific configuration so you can fine-tune various
#   # backing providers for Vagrant. These expose provider-specific options.
#   # Example for VirtualBox:
#   #
  
# #   config.vm.hostname = "masterk8s"
#   config.vm.provider "hyperv" do |vb|

#   #
#   #   # Customize the amount of memory on the VM:
#       vb.maxmemory = "4096"
#       vb.memory = "2048"
#       vb.cpus = "2"
#   end
#   #
#   # View the documentation for the provider you are using for more
#   # information on available options.

#   # Enable provisioning with a shell script. Additional provisioners such as
#   # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
#   # documentation for more information about their specific syntax and use.
# #   config.vm.provision "shell", inline: <<-SHELL
# #      apt-get update
# #     #  apt-get install -y git
# #     #  apt-get install -y nano
# #     #  apt-get install -y curl
# #     #  apt-get install -y wget
# #     #  apt-get install -y nginx
# #      ifconfig
# #     #  sudo dpkg -l | grep systemd
# #     #  sudo dpkg -L systemd
# #     sudo apt-get install -y systemd
# #   SHELL

#   config.vm.provision "file", source: "./calico.yaml", destination: "calico.yaml"
#   config.vm.provision "file", source: "./kubeadm-config.yaml", destination: "kubeadm-config.yaml"
#   config.vm.provision "file", source: "./ip-masq-agent.yaml", destination: "ip-masq-agent.yaml"
#   config.vm.provision "file", source: "./nginx.yaml", destination: "nginx.yaml"

#   # config.vm.provision "shell", path: "all.sh"
#   # config.vm.provision "shell", path: "user.sh", privileged: false
# #   config.vm.provision "shell", path: "containerd_prereq.sh"
# #   config.vm.provision "shell", path: "install.sh"
# #   config.vm.provision "shell", path: "configure.sh"
end
