# Kubernetes

This repository includes all the required components for setting up a Kubernetes Cluster on-premise, for testing and dev purposes, this is not recomended for production usage since cloud options can provide stronger security and reliability, eg. GKE, Anthos.

This provide a full cloud environment so you can deploy applications inside your own computer, this includes:

- ingress controller (for accesing pods from outside your network)
- local-path-storage (for providing PV and PVC from your local storage)
- calico (for providing networking CNI and security policies, including IPv6 support) 
- metrics-server (for accesing usage stats with `kubectl top no`/`kubectl top po`)
- metallb (for provisioning services type=LoadBalancer, using local IPs)


Docker is replaced in favor of containerd since Docker is depercated since k8s@1.20

---
## Requirements

- VirtualBox >= 6.1
- Vagrant >= 2.2
- At least 8Gb RAM available
- At least 4vCPU avaliable

---
## Install

just clone the repo and then run vagrant up:
```bash
git clone git@github.com:LuisEGR/vagrant-k8s.git
cd vagrant-k8s
vagrant up
# wait provision to finish...
vagrant ssh
```

---

## Components installed:

### System 
- Kernel Linux 5.4.0-88-generic  
- Ubuntu 20.04 - focal x64  
- Containerd@1.5.7 



### Kubernetes components

- kubeadm@1.22.2  
- kubelet@1.22.2  
- kubectl@1.22.2  

### Kubernetes applications

- nginx-ingress-controller
- local-path-storage
- calico
- metrics-server




