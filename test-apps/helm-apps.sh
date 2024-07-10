# Kubernetes Dashboard
# https://github.com/kubernetes/dashboard
# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard -f config/kubernetes-dashboard.values.yaml

# Token to access dashboard
kubectl create serviceaccount cluster-admin-dashboard -n kubernetes-dashboard
# TODO: set minimal access instead of admin
kubectl create clusterrolebinding cluster-admin-dashboard --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:cluster-admin-dashboard
kubectl create token cluster-admin-dashboard -n kubernetes-dashboard

# Cert-manager
helm repo add jetstack https://charts.jetstack.io --force-update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.0 \
  --set crds.enabled=true

# Test cert-manager installation
kubectl apply -f test-cert-manager.yaml 
kubectl describe certificate -n cert-manager-test
kubectl delete -f test-cert-manager.yaml

# Create Let's Encrypt Issuer
kubectl apply -f config/letsencrypt-issuer.yaml


# Falco
# https://falco.org/docs/getting-started/falco-kubernetes-quickstart/
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
kubectl create namespace falco

helm install falco -n falco --set driver.kind=ebpf --set tty=true falcosecurity/falco \
--set falcosidekick.enabled=true \
--set falcosidekick.config.slack.webhookurl=$(base64 --decode <<< "aHR0cHM6Ly9ob29rcy5zbGFjay5jb20vc2VydmljZXMvVDA0QUhTRktMTTgvQjA1SzA3NkgyNlMvV2ZHRGQ5MFFDcENwNnFzNmFKNkV0dEg4") \
--set falcosidekick.config.slack.minimumpriority=notice \
--set falcosidekick.config.customfields="user:k8sadmin"

# Chaos Mesh
# https://chaos-mesh.org/docs/production-installation-using-helm/
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm search repo chaos-mesh
kubectl create ns chaos-mesh
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --set chaosDaemon.runtime=crio --set chaosDaemon.socketPath=/var/run/crio/crio.sock --version 2.6.3
kubectl get po -n chaos-mesh

## TODO: try Istio