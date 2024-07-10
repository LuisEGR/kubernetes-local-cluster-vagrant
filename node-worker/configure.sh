#!/bin/bash
echo ">>>>>>> Configuring node $HOSTNAME"

sudo mkdir -p /home/vagrant/.kube
sudo mv kube_config.yaml /home/vagrant/.kube/config

kubectl get no -o wide

# Set role = worker
kubectl label node $HOSTNAME node-role.kubernetes.io/worker=worker

# HELM installation
# https://helm.sh/docs/intro/install/
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm --help



# Prepare kubectl.
# sudo mkdir -p /home/vagrant/.kube
# sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
# sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
# sudo cp /etc/kubernetes/admin.conf /vagrant/kube_config.yaml


# Display nodes
#kubectl get no -o wide

