# Anthos
Aws Eks and Gcp Gke on Anthos
> Gke on Aws is out of scope. Access to anthos-gke cli is not there.

## Getting Started

### Create and Register Clusters
```
./_helpers/workstation.sh
cd terraform/environments/dev/create-register-clusters
terraform init
terraform plan
terraform apply --auto-approve
```
### Install ASM on Registered Clusters (EKS WIP)
```
cd anthos-service-mesh
./eks/asm_on_eks.sh
./gke/asm_on_gke.sh
```

### Introduce ACM (WIP)

Install the operator:
```
# Add Ssh public key to Github
./_helpers/install-acm-operator.sh
```
Initialize and Configure ACM Repo
```
cd anthos-config-management
nomos init
```

### Deploy App (WIP)
```
./_helpers/deploy-app-gke.sh
```
### Troubleshooting

Logs of gke-connet pod:
```
for ns in $(kubectl get ns -o jsonpath={.items..metadata.name} -l hub.gke.io/project); do
  echo "======= Logs $ns ======="
  kubectl logs -n $ns -l app=gke-connect-agent
done
```