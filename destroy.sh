#!/bin/bash

helm uninstall jenkins -n jenkins
helm uninstall ingress -n jenkins
kubectl delete secrets regcred -n jenkins
kubectl delete -f app/
kubectl delete -f jenkins/ingress.yaml
kubectl delete ns jenkins