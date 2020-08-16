#!/bin/bash

set -eux

# Gke
gcloud container clusters get-credentials my-gke-cluster --region=us-central1
kubectl apply -f ../anthos-config-management-operator/config-management-operator.yaml
kubectl create secret generic git-creds \
--namespace=config-management-system \
--from-file=ssh=/home/rajesh_debian/acm-git-ssh-keys
kubectl apply -f ../anthos-config-management-operator/config-management-gke.yaml

# Eks
# export KUBECONFIG=/home/rajesh_debian/anthos/terraform/environments/dev/create-register-clusters/kubeconfig_my-eks-cluster
# kubectl apply -f anthos-config-management-operator/config-management-operator.yaml
# kubectl create secret generic git-creds \
# --namespace=config-management-system \
# --from-file=ssh=~/acm-git-ssh-keys
# kubectl apply -f anthos-config-management-operator/config-management-eks.yaml