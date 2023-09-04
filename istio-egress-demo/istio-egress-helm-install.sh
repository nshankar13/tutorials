#!/bin/bash

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create ns istio-system
kubectl create ns istio-egress

helm install istio-base istio/base -n istio-system --set defaultRevision=default

helm install istiod istio/istiod -n istio-system --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY --wait

helm install istio-egress istio/gateway -n istio-egress --set nodeSelector.egress="enabled" --set tolerations[0].key="egress" --set tolerations[0].operator="Equal" --set tolerations[0].value="enabled" --set tolerations[0].effect="NoSchedule" --set name=istio-egressgateway --set service.type=ClusterIP
