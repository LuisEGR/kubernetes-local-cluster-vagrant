#!/bin/bash
CONTAINERD_VERSION=1.7.16
# DOCKER_CE_VERSION=5:26.1.1-1~ubuntu-$(lsb_release -cs)
# KUBERNETES_VERSION=1.30.0



echo ">>>>>>>>> Installing prerequisites"
# Install packages to allow apt to use a repository over HTTPS.
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo apt install -y net-tools


# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# apt-get update
# apt-cache madison docker-ce






sudo apt-get update --fix-missing
sudo apt-get install -y systemd


# sudo apt-mark hold grub-pc grub-pc-bin grub2-common grub-common
# sudo apt-get dist-upgrade -y




# echo ">>>>>>>>> Installing Containerd"
# sudo apt-get install libseccomp2
# wget -q https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz
# wget -q https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz.sha256sum
# sha256sum --check cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz.sha256sum

# sudo tar --no-overwrite-dir -C / -xzf cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz
# sudo systemctl daemon-reload
# sudo systemctl start containerd



echo ">>>>>>>>> Installing Docker + Containerd"


# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


 sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # apt-cache madison containerd.io
# # Install Docker CE.
# apt-get install -y \
#   docker-ce=${DOCKER_CE_VERSION} \
#   docker-ce-cli=${DOCKER_CE_VERSION}

# # Setup daemon.
# cat > /etc/docker/daemon.json <<EOF
# {
#   "exec-opts": ["native.cgroupdriver=systemd"],
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "100m"
#   },
#   "storage-driver": "overlay2"
# }
# EOF

# mkdir -p /etc/systemd/system/docker.service.d

# # Restart and enable docker service.
systemctl daemon-reload
systemctl start docker
systemctl enable docker

sudo systemctl restart docker

docker info

# # Hold Docker at this specific version.
apt-mark hold docker-ce

sudo usermod -a -G docker vagrant # add vagrant user to docker group



# Add Kubernetes apt repository.
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

## Update apt package index with the new repository
apt-get update

# Install kubelet, kubeadm and kubectl.
# apt-cache madison kubelet

sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

# # Turn off swap for kubeadm.
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab





# Clear apt cache.
sudo apt-get clean


# Clear bash history.
# cat /dev/null > ~/.bash_history && history -c && exit






sudo sysctl -w net.ipv6.conf.all.forwarding=1

NODE_IP=$(hostname -I | cut -d' ' -f2)
# sudo sed "s/127.0.0.1.*m/$NODE_IP m/" -i /etc/hosts
echo "${NODE_IP} masterk8s" >> /etc/hosts
echo "masterk8s" > /etc/hostname
hostnamectl set-hostname masterk8s

echo "IP::::"$NODE_IP
hostname -i
hostname

echo ">>>>>>>>> Installing Kubernetes"
# Install kubernetes via kubeadm.
# kubeadm init --apiserver-advertise-address=$NODE_IP



# Fixes [ERROR CRI]: container runtime is not running: out...
# https://github.com/containerd/containerd/issues/4581
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

# sudo kubeadm init \
# --pod-network-cidr=10.244.0.0/16,2001:db8:42:0::/56 \
# --service-cidr=10.96.0.0/16,2001:db8:42:1::/112 \
# # --extra-config=kubelet.cgroup-driver=cgroupfs \
# --apiserver-advertise-address=$NODE_IP

# kubeadm init --config=kubeadm-config.yaml
kubeadm init
echo ">>>>>>>>> preparing kubectl"


# Hostname -i must return a routable address on second (non-NATed) network interface.
# @see http://kubernetes.io/docs/getting-started-guides/kubeadm/#limitations
# sed "s/127.0.0.1.*m/$NODE_IP m/" -i /etc/hosts

echo ">>>>>>>>> Join file"


# Export k8s cluster token to an external file.
# OUTPUT_FILE=/vagrant/join.sh
# rm -rf /vagrant/join.sh
kubeadm token create --print-join-command > /vagrant/join.sh
sudo chmod +x /vagrant/join.sh

ip addr
# whoami

# sudo su - vagrant
# whoami
