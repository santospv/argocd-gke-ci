#!/bin/bash

#Contectando autenticando no cluster
gcloud auth activate-service-account --key-file=serviceaccount.json
gcloud container clusters get-credentials pvs-devops-iac-gke --zone us-south1-c --project pvs-devops-iac

#Montando ambiente base
kubectl create namespace jenkins
chmod +x secret-docker.sh
./secret-docker.sh
helm install ingress ingress-nginx/ingress-nginx -n jenkins
helm install jenkins jenkins/jenkins --values k8s/jenkins/jenkins.yaml -n jenkins
kubectl apply -f k8s/jenkins/ingress.yaml
kubectl apply -f k8s/app/ingress.yaml

#Provisionando ArgoCD
kubectl create namespace argocd
helm install argocd argo-cd/argo-cd -n argocd
#kubectl port-forward service/argocd-server -n argocd 8080:443
#kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
