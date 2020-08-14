# Anthos
Aws Eks and Gcp Gke on Anthos

## Getting Started (WIP)

```
./bootstrap.sh
cd terraform/environments/dev
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```

## Troubleshooting

Logs of gke-connet pod:
```
for ns in $(kubectl get ns -o jsonpath={.items..metadata.name} -l hub.gke.io/project); do
  echo "======= Logs $ns ======="
  kubectl logs -n $ns -l app=gke-connect-agent
done
```