# Anthos
Eks and Gke on Gke Hub

## Getting Started (WIP)

```
./bootstrap.sh
cd terraform/environments/dev
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```

gcloud container clusters get-credentials my-gke-cluster --region=us-central1