#!/bin/bash


# Prepare kubectl.
sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config


echo ">>>>>>>>> Untaint node"


# Untaint master node.
kubectl taint nodes masterk8s node-role.kubernetes.io/master:NoSchedule-



# Network:
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

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


#############
## METALLB ##
#############

# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \

kubectl apply -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/metallb.yaml
kubectl apply -f metallb-cfg.yaml



#############################
## PureLB - Kubernetes LB ##
#############################
# cat <<EOF | sudo tee /etc/sysctl.d/k8s_arp.conf
# net.ipv4.conf.all.arp_filter=1
# EOF
# sudo sysctl --system

# kubectl apply -f https://gitlab.com/api/v4/projects/purelb%2Fpurelb/packages/generic/manifest/0.0.1/purelb-complete.yaml
# kubectl apply -f https://gitlab.com/kubectl api-resources --api-group=purelb.ioapi/v4/projects/purelb%2Fpurelb/packages/generic/manifest/0.0.1/purelb-complete.yaml



kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml



kubectl apply -f metrics-server.yaml

# Validate IPV6 cluster
kubectl get nodes masterk8s -o go-template --template='{{range .spec.podCIDRs}}{{printf "%s\n" .}}{{end}}'


# kubectl config set-context admin --user=cluster-admin --namespace=kube-system

# kubectl apply -f nginx.yaml


# kubectl run  -it --rm  wget --image=cirrusci/wget -- sh
kubectl run pod01 --image=busybox --command -- sleep 


# Install CockroachDB
kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/v2.2.0/install/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/v2.2.0/install/operator.yaml

kubectl apply -f cockroach-crdb.yaml