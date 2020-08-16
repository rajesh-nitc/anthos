#!/bin/bash

set -eux

export KUBECONFIG=/home/rajesh_debian/.kube/config
kubectl apply -f ../kubernetes-manifests/
