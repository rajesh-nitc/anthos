#!/bin/bash

# workstation requires gcloud, aws cli, aws-iam-authenticator, kubectl, terraform, kpt

set -eux

export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $PROJECT_ID
PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")
COMPUTE_ENGINE_DEFAULT_SERVICE_ACCOUNT="$PROJECT_NUMBER-compute@developer.gserviceaccount.com"

echo "Allowing gke connect pod to connect to gke hub"
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

echo "Installing aws-iam-authenticator"
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin