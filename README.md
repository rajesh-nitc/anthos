# Anthos
Aws Eks and Gcp Gke on Anthos
> Gke on Aws is out of scope as access to anthos-gke cli is not public

## Getting Started

### Create and Register Clusters
```
./_helpers/workstation.sh
cd terraform/environments/dev/create-register-clusters
terraform init
terraform plan
terraform apply --auto-approve
```
### Install ASM on Registered Clusters
```
cd anthos-service-mesh
./eks/asm_on_eks.sh
./gke/asm_on_gke.sh
```

### Introduce ACM

## Troubleshooting

Logs of gke-connet pod:
```
for ns in $(kubectl get ns -o jsonpath={.items..metadata.name} -l hub.gke.io/project); do
  echo "======= Logs $ns ======="
  kubectl logs -n $ns -l app=gke-connect-agent
done
```