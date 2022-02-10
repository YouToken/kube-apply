#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config
export KUBE_NAMESPACE="$NAMESPACE"
export KUBE_IMAGE="$IMAGE"
export SELECTOR_NAME="$NAME"

kubectl config current-context
echo "${KUBE_NAMESPACE}"
echo "${KUBE_IMAGE}"
echo "${SELECTOR_NAME}"
kubectl get deployments ${SELECTOR_NAME}
kubectl set image deployments ${SELECTOR_NAME} ${SELECTOR_NAME}=${KUBE_IMAGE} --namespace=${KUBE_NAMESPACE} --record
#kubectl delete pods -l app=${SELECTOR_NAME} --namespace=${KUBE_NAMESPACE}
