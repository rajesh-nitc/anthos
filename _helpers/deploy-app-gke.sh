#!/bin/bash

set -eux

export KUBECONFIG=/home/$USER/.kube/config
kubectl apply -f ../kubernetes-manifests/
