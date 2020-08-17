# Anthos
Eks and Gke on Anthos
> Gke on Aws is out of scope for now as access to anthos-gke cli is not there

## Getting Started

### Prepare Google Cloud Shell Environment
```
./prepare-google-shell.sh
```
### Create and Register Clusters
Clusters info:

Cluster | Public/Private | Zonal/Regional | Network
--- | --- | --- | ---
Gke | Public | Regional | default
Eks | Public | Regional | default

```
# Update name of the terraform-sa file name in the below command
export GOOGLE_APPLICATION_CREDENTIALS=/home/$USER/<< name of the file >>.json
aws configure
cd terraform/environments/dev/create-register-clusters
terraform init
terraform validate
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

Install the ACM Operator:
```
./_helpers/acm-git-creds.sh
# Add Ssh public key to Github
./_helpers/install-acm-operator.sh
```
Initialize and Configure ACM Repo:
```
cd anthos-config-management
nomos init
```

### Deploy App (EKS WIP)
```
./_helpers/deploy-app-gke.sh
./_helpers/deploy-app-eks.sh
```

### Testing
```
curl http://$INGRESS_GATEWAY
```
### Troubleshooting

Logs of gke-connet pod:
```
for ns in $(kubectl get ns -o jsonpath={.items..metadata.name} -l hub.gke.io/project); do
  echo "======= Logs $ns ======="
  kubectl logs -n $ns -l app=gke-connect-agent
done
```