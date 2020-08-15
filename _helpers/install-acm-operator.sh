#!/bin/bash

ssh-keygen -t rsa -b 4096 \
 -C "rajesh-nitc" \
 -N '' \
 -f ~/acm-git-ssh-keys

# Gke
export KUBECONFIG=/home/rajesh_debian/.kube/config
kubectl apply -f anthos-config-management-operator/config-management-operator.yaml
kubectl create secret generic git-creds \
--namespace=config-management-system \
--from-file=ssh=~/acm-git-ssh-keys
kubectl apply -f anthos-config-management-operator/config-management-gke.yaml

# Eks
# export KUBECONFIG=/home/rajesh_debian/anthos/terraform/environments/dev/create-register-clusters/kubeconfig_my-eks-cluster
# kubectl apply -f anthos-config-management-operator/config-management-operator.yaml
# kubectl create secret generic git-creds \
# --namespace=config-management-system \
# --from-file=ssh=~/acm-git-ssh-keys
# kubectl apply -f anthos-config-management-operator/config-management-eks.yaml