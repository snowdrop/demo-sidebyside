#!/bin/bash

INGRESSGATEWAY=istio-ingressgateway
IP_ADDRESS="$(minikube ip):$(kubectl get svc istio-ingressgateway --namespace istio-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')"
HOST_URL=$(kubectl get routes.serving.knative.dev quarked  -o jsonpath='{.status.url}')
STRIPPED=$(echo $HOST_URL | cut -f2 -d':' | cut -f3 -d'/')

siege -r 1 -c 200 -d 2 -v -H "Host: ${STRIPPED}" ${IP_ADDRESS}
