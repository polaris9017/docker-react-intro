#!/usr/bin/bash

# Written by moonrise917 and re-written by moonrise917 using Github Copilot

# Define the start and stop commands
START="start"
STOP="stop"

# Check if Docker and Kubernetes are installed
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found. Please install Docker."
    exit 1
fi

if ! command -v kubectl &> /dev/null
then
    echo "Kubectl could not be found. Please install Kubernetes."
    exit 1
fi

# Check if the Docker hub username is provided and valid
if [ -z $1 ]; then
  echo "Docker hub username is required!"
  exit 1
elif ! [[ $1 =~ ^[a-z0-9-]+$ ]]; then
  echo "Invalid Docker hub username! It should only contain lowercase letters, numbers, and dashes."
  exit 1
else
  # Check if the command is provided
  if [ -z $2 ]; then
    echo "Empty command!"
    exit 1
  # Check if the command is either 'start' or 'stop'
  elif [ $2 != $START ] && [ $2 != $STOP ] ; then
    echo "Invalid command!"
    exit 1
  fi

  # If the command is 'start', build and push the docker image, then apply the kubernetes configurations
  if [ $2 == $START ]; then
    docker build -t $1/node-react-app . || { echo 'Docker build failed' ; exit 1; }
    docker push $1/node-react-app:latest || { echo 'Docker push failed' ; exit 1; }

    kubectl apply -f ./deployment.yaml || { echo 'Kubernetes deployment failed' ; exit 1; }
    kubectl apply -f ./service.yaml || { echo 'Kubernetes service failed' ; exit 1; }
  # If the command is 'stop', delete the kubernetes service and deployment
  elif [ $2 == $STOP ]; then
    kubectl delete svc svc-react-app || { echo 'Kubernetes service deletion failed' ; exit 1; }
    kubectl delete deploy dpy-react-app || { echo 'Kubernetes deployment deletion failed' ; exit 1; }
  fi

fi