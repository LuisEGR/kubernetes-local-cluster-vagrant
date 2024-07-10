# Kubernetes Cluster Setup with Vagrant and Hyper-V

<p align="center">
  <img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" alt="Kubernetes" width="200"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/8/87/Vagrant.png" alt="Vagrant" width="200"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/58/Hyper-V_Logo.png" alt="Hyper-V" width="200"/>
</p>

This project provides a set of scripts and Vagrant configurations to create a Kubernetes cluster using the latest version of Kubernetes. The cluster consists of a control plane node and multiple worker nodes, all provisioned using Vagrant with Hyper-V on Windows and the Ubuntu 22.04 (Jammy Jellyfish) base box.


## Requirements

Before setting up the Kubernetes cluster, ensure your system meets the following requirements:

1. **Hardware Requirements:**
   - A Windows 10 or Windows Server 2016 (or later) machine with virtualization support.
   - Minimum 16GB RAM (32GB or more recommended for better performance).
   - At least 50GB of free disk space.

2. **Software Requirements:**
   - Windows 10 Pro, Enterprise, or Education (64-bit) or Windows Server 2016 (or later).
   - [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) enabled.
   - [Vagrant](https://www.vagrantup.com/) (version 2.2.18 or later) installed.
   - [Git](https://git-scm.com/downloads) installed (for cloning the repository).

3. **Network Requirements:**
   - A working internet connection for downloading necessary packages and container images.
   - The ability to create and configure a Hyper-V external network switch.

4. **Additional Notes:**
   - Ensure that your system's BIOS settings have virtualization technology enabled.
   - If you're using Windows 10 Home edition, you'll need to upgrade to Pro, Enterprise, or Education to use Hyper-V.
   - Disable any other virtualization software (like VirtualBox) that might interfere with Hyper-V.

Please make sure all these requirements are met before proceeding with the cluster setup.

## Network Setup

Before provisioning the cluster, you need to create a Hyper-V external network switch. Run the following PowerShell script with administrator privileges:

```powershell
# Name of the new virtual switch
$switchName = "Public Switch"

# Get the physical network adapter for the external switch
$netAdapter = Get-NetAdapter -Name "Ethernet" 

# Create the new external virtual switch
New-VMSwitch -Name $switchName -NetAdapterName $netAdapter.Name -AllowManagementOS $true
```

Make sure to adjust the `$netAdapter` name if your primary network adapter is named differently.

## Project Structure

The project has the following directory structure:

```
.
├── common
│   ├── calico.yaml
│   ├── install.sh
│   ├── kubeadm-config.yaml
│   ├── local-path-storage.yaml
│   ├── metallb-native.yaml
│   └── nginx-ingress-controller-bm.yaml
├── control-plane
│   ├── configure.sh
│   └── Vagrantfile
├── images
├── node-worker
│   ├── configure.sh
│   ├── join.sh
│   ├── kube_config.yaml
│   └── Vagrantfile
├── test-apps
│   ├── config
│   │   ├── kubernetes-dashboard.values.yaml
│   │   └── letsencrypt-issuer.yaml
│   ├── helm-apps.sh
│   ├── nginx.yaml
│   ├── persistent-pod-local-path.yaml
│   └── test-cert-manager.yaml
└── workers
```

## Cluster Components

The Kubernetes cluster is set up with the following components:

- [Kubernetes](https://kubernetes.io/) v1.30.0
- [Calico](https://www.tigera.io/project-calico/) CNI plugin for networking
- [Helm](https://helm.sh/) package manager for deploying applications
- [NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/) for exposing services
- [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) for cluster management
- [cert-manager](https://cert-manager.io/) for automatic TLS certificate management
- [Falco](https://falco.org/) for runtime security monitoring
- [Chaos Mesh](https://chaos-mesh.org/) for chaos engineering experiments

## Usage

To provision the Kubernetes cluster, follow these steps:

1. Ensure Hyper-V is enabled and the "Public Switch" network is created.
2. Clone this repository.
3. Navigate to the `control-plane` directory and run `vagrant up` to provision the control plane node.
4. Navigate to the `node-worker` directory and run `vagrant up` to provision the worker nodes.
5. Use `vagrant ssh control-plane` to SSH into the control plane node and verify the cluster status using `kubectl get nodes`.
6. Deploy the test applications by running the `helm-apps.sh` script in the `test-apps` directory.

## Customization

You can customize the cluster configuration by modifying the following files:

- `common/kubeadm-config.yaml`: Kubernetes cluster configuration file used by kubeadm.
- `control-plane/Vagrantfile` and `node-worker/Vagrantfile`: Vagrant configuration files for the control plane and worker nodes. You can adjust the number of worker nodes, resource allocation, and network settings here.
- `test-apps/config`: Configuration files for the test applications.

## Limitations and Known Issues

- The MetalLB load balancer is currently not working and is commented out in the scripts.
- IPv6 support for Calico CNI is not fully configured.
- The Kubernetes Dashboard is accessible using the `kubectl proxy` command, but it is not exposed externally.

Please refer to the individual scripts and configuration files for more details on the specific steps and configurations applied during the provisioning process.

## Contributing

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the project's GitHub repository.

## License

This project is licensed under the [MIT License](LICENSE).