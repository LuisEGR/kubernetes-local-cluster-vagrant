sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd


sed "s/127.0.0.1.*m/$NODE_IP m/" -i /etc/hosts

# adduser k8user
# adduser k8user sudo

sudo systemctl enable kubelet.service
# sudo kubeadm init
sudo kubeadm init --cri-socket /run/containerd/containerd.sock --apiserver-advertise-address=$NODE_IP


# sed "s/127.0.0.1.*m/$NODE_IP m/" -i /etc/hosts


# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# echo "------- KubeConfig File:"
# cat $HOME/.kube/config


OUTPUT_FILE=/vagrant/join.sh
rm -rf /vagrant/join.sh
kubeadm token create --print-join-command > /vagrant/join.sh
chmod +x $OUTPUT_FILE