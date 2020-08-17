#!/bin/bash


export KUBECONFIG=/home/$USER/anthos/terraform/environments/dev/create-register-clusters/kubeconfig_my-eks-cluster

curl -LO https://storage.googleapis.com/gke-release/asm/istio-1.6.5-asm.7-linux-amd64.tar.gz
tar xzf istio-1.6.5-asm.7-linux-amd64.tar.gz
cd istio-1.6.5-asm.7
export PATH=$PWD/bin:$PATH

kubectl create namespace istio-system
kubectl create namespace my-namespace
istioctl install --set profile=asm-multicloud
kubectl label namespace my-namespace istio-injection=enabled --overwrite

export HOST_KEY="hostname"
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].'"$HOST_KEY"'}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
echo "Ingress Gateway reachable at http://$INGRESS_HOST:$INGRESS_PORT"