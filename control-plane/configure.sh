#!/bin/bash


# Prepare kubectl.
sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
sudo cp /etc/kubernetes/admin.conf /vagrant/kube_config.yaml

echo ">>>>>>>>> Untaint node"


# Untaint control plane node.
kubectl taint nodes control-plane node-role.kubernetes.io/control-plane:NoSchedule-

# Display nodes
kubectl get no -o wide


# CNI
kubectl apply -f calico.yaml
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







# Testing ngnix server
kubectl apply -f nginx.yaml
