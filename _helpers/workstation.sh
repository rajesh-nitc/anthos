#!/bin/bash

# Install on workstation
# gcloud
# gsutil
# aws cli
# aws-iam-authenticator
# kubectl
# terraform

set -eux

export PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")
COMPUTE_ENGINE_DEFAULT_SERVICE_ACCOUNT="$PROJECT_NUMBER-compute@developer.gserviceaccount.com"

echo "Allowing gke connect pod to connect to gke hub"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member \
serviceAccount:"$COMPUTE_ENGINE_DEFAULT_SERVICE_ACCOUNT" \
--role "roles/gkehub.connect"

echo "Enabling APIs...WARNING =====> Not all the required apis are covered..."
gcloud --project "${PROJECT_ID}" services enable gkehub.googleapis.com \
    anthos.googleapis.com \
    container.googleapis.com \
    gkeconnect.googleapis.com \
    cloudresourcemanager.googleapis.com

echo "Installing aws-iam-authenticator"
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin