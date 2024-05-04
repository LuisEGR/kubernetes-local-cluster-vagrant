#!/bin/bash


# Prepare kubectl.
sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
sudo cp /etc/kubernetes/admin.conf /vagrant/kube_config.yaml

echo ">>>>>>>>> Untaint node"


# Untaint master node.
kubectl taint nodes masterk8s node-role.kubernetes.io/master:NoSchedule-




# IPv6 Support
kubectl apply -f calico.yaml

# # IPv6 Egress
kubectl apply -f ip-masq-agent.yaml


# curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
# sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
# sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
# rm cilium-linux-amd64.tar.gz{,.sha256sum}

# cilium install


# sudo apt install kubectx





# Validate IPV6 cluster
kubectl get nodes masterk8s -o go-template --template='{{range .spec.podCIDRs}}{{printf "%s\n" .}}{{end}}'


# kubectl config set-context admin --user=cluster-admin --namespace=kube-system

kubectl apply -f nginx.yaml