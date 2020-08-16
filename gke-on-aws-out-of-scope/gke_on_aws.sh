#!/bin/bash

set -eux

KMS_KEY1_ARN=$(aws kms create-key | jq -r '.KeyMetadata.Arn')
aws kms create-alias --alias-name=alias/first-kms-key --target-key-id=$KMS_KEY1_ARN

KMS_KEY2_ARN=$(aws kms create-key | jq -r '.KeyMetadata.Arn')
aws kms create-alias --alias-name=alias/second-kms-key --target-key-id=$KMS_KEY2_ARN

# GKE on AWS service accounts
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $PROJECT_ID

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

# Create the service accounts
gcloud iam service-accounts create management-sa
gcloud iam service-accounts create hub-sa
gcloud iam service-accounts create node-sa

# Download the keys
gcloud iam service-accounts keys create management-key.json \
     --iam-account management-sa@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts keys create hub-key.json \
     --iam-account hub-sa@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts keys create node-key.json \
     --iam-account node-sa@$PROJECT_ID.iam.gserviceaccount.com

# Grant roles to the management service account
gcloud projects add-iam-policy-binding \
    $PROJECT_ID \
    --member serviceAccount:management-sa@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/gkehub.admin
gcloud projects add-iam-policy-binding \
    $PROJECT_ID \
    --member serviceAccount:management-sa@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/serviceusage.serviceUsageViewer

# Grant roles to the hub service account
gcloud projects add-iam-policy-binding \
    $PROJECT_ID \
    --member serviceAccount:hub-sa@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/gkehub.connect

# Grant roles to the node service account
gcloud projects add-iam-policy-binding \
      $PROJECT_ID \
      --member serviceAccount:node-sa@$PROJECT_ID.iam.gserviceaccount.com \
      --role roles/storage.objectViewer