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

#Provisionando ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
