#!/bin/bash
CONTAINERD_VERSION=1.5.7
DOCKER_CE_VERSION=5:20.10.9~3-0~ubuntu-$(lsb_release -cs)
KUBERNETES_VERSION=1.22.2-00


# Install packages to allow apt to use a repository over HTTPS.
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo apt install net-tools

# Turn off swap for kubeadm.
swapoff -a
sed -i '/swap/d' /etc/fstab

echo "[TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 3] Enable and Load Kernel modules"
cat >>/etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter


echo "[TASK 4] Add Kernel settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

sudo sysctl -w net.ipv6.conf.all.forwarding=1




echo "[TASK 5] Install containerd runtime"
apt update -qq >/dev/null 2>&1
apt install -qq -y containerd apt-transport-https >/dev/null 2>&1
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd >/dev/null 2>&1




echo "[TASK 5] Install systemd"
sudo apt-get update 
sudo apt-get install -y systemd >/dev/null 2>&1




# Add Kubernetes apt repository.

## Download the Google Cloud public signing key
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

## Add the Kubernetes apt repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

## Update apt package index with the new repository
apt-get update

# Install kubelet, kubeadm and kubectl.
# apt-cache madison kubelet

apt-get install -y kubelet=${KUBERNETES_VERSION} kubectl=${KUBERNETES_VERSION} kubeadm=${KUBERNETES_VERSION}

# Hold the Kubernetes components at this specific version.
apt-mark hold kubelet kubeadm kubectl





# # Clear apt cache.
# apt-get clean


# # Clear bash history.
# cat /dev/null > ~/.bash_history && history -c && exit







NODE_IP=$(hostname -I | cut -d' ' -f2)
# sudo sed "s/127.0.0.1.*m/$NODE_IP m/" -i /etc/hosts
echo "${NODE_IP} k8s-node0" >> /etc/hosts
echo "k8s-node0" > /etc/hostname
hostnamectl set-hostname k8s-node0

echo "IP::::"$NODE_IP
hostname -i
hostname

echo ">>>>>>>>> Installing Kubernetes"
# Install kubernetes via kubeadm.
# kubeadm init --apiserver-advertise-address=$NODE_IP


# sudo kubeadm init \
# --pod-network-cidr=10.244.0.0/16,2001:db8:42:0::/56 \
# --service-cidr=10.96.0.0/16,2001:db8:42:1::/112 \
# # --extra-config=kubelet.cgroup-driver=cgroupfs \
# --apiserver-advertise-address=$NODE_IP


echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1



# kubeadm init --config=kubeadm-config.yaml
# kubeadm init --apiserver-advertise-address=$NODE_IP \
# --pod-network-cidr=10.10.0.0/16,2001:db8:42:0::/64 \
# --service-cidr=10.20.0.0/16,2001:db8:42:1::/112 \
# --feature-gates=IPv6DualStack=true

# kubeadm init --apiserver-advertise-address=$NODE_IP \
# --pod-network-cidr=10.10.0.0/16,2806:2f0:93c0:4e98::/64 \
# --service-cidr=10.20.0.0/16,2806:2f0:93c0:4e98::/64 \
# --feature-gates=IPv6DualStack=true

# kubeadm join 192.168.100.127:6443 --token tlg2f3.1vvz5yjlfy3nvibs --discovery-token-ca-cert-hash sha256:61df7dd2d5d54c248566176f8d04aea220229ee5d6a390960c0cc54478959c9a 

ip addr
# whoami

# sudo su - vagrant
# whoami

# echo "HOME:::::::"$HOME

sudo apt-get install -y zsh
sudo apt-get install -y git-core

yes|sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s /bin/zsh vagrant

