#!/bin/bash

set -eux

export KUBECONFIG=/home/rajesh_debian/.kube/config
export PROJECT_ID=$(gcloud config get-value project)
export CLUSTER_NAME=my-gke-cluster
export CLUSTER_LOCATION=us-central1
PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")
gcloud config set project $PROJECT_ID
gcloud config set compute/region ${CLUSTER_LOCATION}
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"

gcloud services enable \
    container.googleapis.com \
    compute.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com \
    cloudtrace.googleapis.com \
    meshca.googleapis.com \
    meshtelemetry.googleapis.com \
    meshconfig.googleapis.com \
    iamcredentials.googleapis.com \
    anthos.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    cloudresourcemanager.googleapis.com

gcloud container clusters update ${CLUSTER_NAME} --region=$CLUSTER_LOCATION --update-labels=mesh_id=${MESH_ID}
gcloud container clusters update ${CLUSTER_NAME} --region=$CLUSTER_LOCATION --workload-pool=${WORKLOAD_POOL}
gcloud container clusters update ${CLUSTER_NAME} --region=$CLUSTER_LOCATION --enable-stackdriver-kubernetes

curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  "https://meshconfig.googleapis.com/v1alpha1/projects/${PROJECT_ID}:initialize"

curl -LO https://storage.googleapis.com/gke-release/asm/istio-1.6.5-asm.7-linux-amd64.tar.gz
tar xzf istio-1.6.5-asm.7-linux-amd64.tar.gz
cd istio-1.6.5-asm.7
export PATH=$PWD/bin:$PATH

kpt pkg get https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git/asm@release-1.6-asm .
kpt cfg set asm gcloud.container.cluster ${CLUSTER_NAME}
kpt cfg set asm gcloud.core.project ${PROJECT_ID}
kpt cfg set asm gcloud.compute.location ${CLUSTER_LOCATION}

istioctl install -f asm/cluster/istio-operator.yaml
kubectl create namespace my-namespace
kubectl label namespace my-namespace istio-injection=enabled --overwrite