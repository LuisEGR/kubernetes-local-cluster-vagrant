#!/bin/bash


echo ">>>>>>>>> Installing Kubernetes"
# Install kubernetes via kubeadm.
# kubeadm init --apiserver-advertise-address=$NODE_IP



# Fixes [ERROR CRI]: container runtime is not running: out...
# https://github.com/containerd/containerd/issues/4581
# sudo rm /etc/containerd/config.toml
# sudo systemctl restart containerd

# sudo kubeadm init \
# --pod-network-cidr=10.244.0.0/16,2001:db8:42:0::/56 \
# --service-cidr=10.96.0.0/16,2001:db8:42:1::/112 \
# # --extra-config=kubelet.cgroup-driver=cgroupfs \
# --apiserver-advertise-address=$NODE_IP

sed -i "s/LOAD_BALANCER_DNS/$NODE_IP/g" common/kubeadm-config.yaml
echo ">>>kubeadm-config.yam<<<"
cat common/kubeadm-config.yaml

kubeadm init --config=common/kubeadm-config.yaml
# kubeadm init
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





# Prepare kubectl.
sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
sudo cp /etc/kubernetes/admin.conf /vagrant/kube_config.yaml

echo ">>>>>>>>> Untaint node"


# Untaint control plane node.
# So it can run pods as well
kubectl taint nodes control-plane node-role.kubernetes.io/control-plane:NoSchedule-

# Display nodes
kubectl get no -o wide


# CNI
kubectl apply -f common/calico.yaml
# kubectl apply -f flannel.yaml





# Wait for the Calico pod to be ready
echo "Waiting for Calico pod to be ready..."

# Function to check if the Calico pod is ready
is_calico_ready() {
  kubectl get pods -n kube-system -l k8s-app=calico-node -o jsonpath='{.items[*].status.phase}' | grep -q "Running"
}

# Retry until the Calico pod is ready or timeout after 5 minutes
retries=30
while ! is_calico_ready; do
  if [ "$retries" -eq 0 ]; then
    echo "Timed out waiting for Calico pod to be ready"
    exit 1
  fi

  echo "Calico pod not ready yet. Retrying in 10 seconds..."
  sleep 10
  retries=$((retries-1))
done

echo "Calico pod is ready!"

# # IPv6 Egress
#kubectl apply -f ip-masq-agent.yaml

# curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
# sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
# sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
# rm cilium-linux-amd64.tar.gz{,.sha256sum}

# cilium install
# sudo apt install kubectx

# Validate IPV6 cluster
# kubectl get nodes masterk8s -o go-template --template='{{range .spec.podCIDRs}}{{printf "%s\n" .}}{{end}}'

# kubectl config set-context admin --user=cluster-admin --namespace=kube-system




#!/bin/bash

# Update Calico configuration
# calico_conf="/etc/cni/net.d/10-calico.conflist"
# calico_ipv4_pool="10.14.0.0/16"

# if [ -f "$calico_conf" ]; then
#     sed -i -e 's/"ipv4_pools": \[".*"\]/"ipv4_pools": \["'"$calico_ipv4_pool"'"\]/g' "$calico_conf"
#     echo "Updated Calico configuration with IPv4 pool: $calico_ipv4_pool"
# else
#     echo "Calico configuration file not found: $calico_conf"
# fi



# # Restart Calico pods
# kubectl delete pod -n kube-system -l k8s-app=calico-node
# echo "Restarted Calico pods"



# Update CoreDNS ConfigMap
# coredns_forward="forward . 8.8.8.8 8.8.4.4"

# # Get the current CoreDNS ConfigMap
# configmap=$(kubectl get configmap -n kube-system coredns -o yaml)
# echo $configmap
# # Update the forward directive in the ConfigMap
# # updated_configmap=$(echo "$configmap" | sed -e 's/forward.*$/'"$coredns_forward"'/g')

# updated_configmap=$(echo "$configmap" | sed -e '/forward/,/cache/ {
#     s/forward.*//
#     /cache/i \
#         '"$coredns_forward"'
# }')


# echo $updated_configmap
# # Apply the updated ConfigMap
# echo "$updated_configmap" | kubectl apply -f -

# echo "Updated CoreDNS ConfigMap with forward directive: $coredns_forward"

# # Restart CoreDNS pods
# kubectl rollout restart deployment/coredns -n kube-system
# echo "Restarted CoreDNS pods"



# TODO: Metallb is not working!
# Pre-requisite for METALLB
# https://metallb.universe.tf/installation/#preparation
# kubectl get configmap kube-proxy -n kube-system -o yaml
# kubectl get configmap kube-proxy -n kube-system -o yaml | \
# sed -e "s/strictARP: false/strictARP: true/" | \
# kubectl apply -f - -n kube-system
# kubectl apply -f common/metallb-native.yaml



# HELM installation
# https://helm.sh/docs/intro/install/
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm --help



kubectl apply -f common/local-path-storage.yaml

#https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
kubectl apply -f common/nginx-ingress-controller-bm.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx --field-selector=status.phase=Running -o name)
kubectl exec $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version

cd test-apps
chmod +x helm-apps.sh
sh helm-apps.sh


# Test ngnix server
kubectl apply -f nginx.yaml

kubectl apply -f persistent-pod-local-path.yaml

cd ..



