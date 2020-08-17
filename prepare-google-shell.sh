#!/bin/bash

set -eux

cd /home/$USER

# Install aws cli
if [[ $(command -v aws) ]]; then
    echo "Skipping..The binary aws is already installed"
else
    echo "Installing aws cli"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Install aws-iam-authenticator
if [[ $(command -v aws-iam-authenticator) ]]; then
    echo "Skipping..The binary aws-iam-authenticator is already installed"
else
    echo "Installing aws-iam-authenticator"
    curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/aws-iam-authenticator
    chmod +x ./aws-iam-authenticator
    sudo mv aws-iam-authenticator /usr/local/bin
fi

# Install nomos
if [[ $(command -v nomos) ]]; then
    echo "Skipping..The binary nomos is already installed"
else
    echo "Installing nomos"
    gsutil cp gs://config-management-release/released/latest/linux_amd64/nomos nomos
    chmod +x ./nomos
    sudo mv nomos /usr/local/bin
fi

# Install kpt
if [[ $(command -v kpt) ]]; then
    echo "Skipping..The binary kpt is already installed"
else
    sudo apt-get install -y google-cloud-sdk-kpt
fi

# Terraform service account
export PROJECT_ID=$(gcloud config get-value project)
TERRAFORM_SERVICE_ACCOUNT=$1
gcloud iam service-accounts create $TERRAFORM_SERVICE_ACCOUNT
gcloud iam service-accounts keys create $TERRAFORM_SERVICE_ACCOUNT-key.json \
     --iam-account $TERRAFORM_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding \
    $PROJECT_ID \
    --member serviceAccount:$TERRAFORM_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/owner

# Allowing gke connect pod to connect to gke hub
PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")
COMPUTE_ENGINE_DEFAULT_SERVICE_ACCOUNT="$PROJECT_NUMBER-compute@developer.gserviceaccount.com"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member \
serviceAccount:"$COMPUTE_ENGINE_DEFAULT_SERVICE_ACCOUNT" \
--role "roles/gkehub.connect"

# Enable Google Cloud APIs
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable gkehub.googleapis.com
gcloud services enable gkeconnect.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable stackdriver.googleapis.com
gcloud services enable storage-api.googleapis.com
gcloud services enable storage-component.googleapis.com