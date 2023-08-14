#!/bin/bash

echo "Starting..."
## Reconfigure agent
echo "> Setting up of datadog-agent"
helm install datadog-agent -f dash/datadog-values.yaml datadog/datadog --set datadog.apiKey=$DD_API_KEY
## Restart kubernetes Deployment and Services
echo "> (Building) Running micro-services"

# Pull all missing images
docker pull redis:alpine
docker pull mariadb
docker pull busybox:latest

# Skaffold build and run
## Loop until 18 pods are up 
skaffold build --platform=linux/amd64
until [[ $(kubectl get pods | awk 'END{print NR}') -gt 17 ]]; do skaffold run --platform=linux/amd64; done

echo "> Configuring extras"
# Setting variable to check agent status
export AGENT_POD=$(kubectl get pods | sed -e '/datadog-agent/!d' | sed -n '/cluster/!p' | sed -n '/metrics/!p' | awk -F' ' '{print $1}')
