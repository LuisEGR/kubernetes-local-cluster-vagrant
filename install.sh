# apt update
apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# apt update

CONTAINERD_VERSION=1.5.7
KUBERNETES_VERSION=1.22.2

echo "------ installing containerd"
sudo apt-get install libseccomp2
wget -q https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz
wget -q https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz.sha256sum
sha256sum --check cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz.sha256sum

sudo tar --no-overwrite-dir -C / -xzf cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz
sudo systemctl daemon-reload
sudo systemctl start containerd



echo "------ Installing Kubelet, Kubeadm, Kubeclt and Containerd..."
# apt-get install -y kubelet kubeadm kubectl 
apt-get install -y kubelet=${KUBERNETES_VERSION}
apt-get install -y kubeadm=${KUBERNETES_VERSION}
apt-get install -y kubectl=${KUBERNETES_VERSION}
apt-mark hold kubelet kubeadm kubectl



echo '[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock"
' > /etc/systemd/system/kubelet.service.d/0-containerd.conf


echo "------ File.../etc/systemd/system/kubelet.service.d/0-containerd.conf...."
cat /etc/systemd/system/kubelet.service.d/0-containerd.conf


sudo systemctl daemon-reload
