#!/bin/bash

helm uninstall jenkins -n jenkins
helm uninstall ingress -n jenkins
helm uninstall argocd -n argocd
kubectl delete secrets regcred -n jenkins
kubectl delete -f k8s/app/
kubectl delete -f k8s/jenkins/ingress.yaml
kubectl delete ns jenkins
kubectl delete ns argocd