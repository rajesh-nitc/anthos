#!/bin/bash

set -eux

export KUBECONFIG=/home/rajesh_debian/anthos/terraform/environments/dev/create-register-clusters/kubeconfig_my-eks-cluster
kubectl apply -f ../kubernetes-manifests/