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
export NAMESPACE="$KUBE_NAMESPACE"
export IMAGE="$KUBE_IMAGE"
export NAME="$SELECTOR_NAME"

kubectl config current-context
echo "${NAMESPACE}"
echo "${IMAGE}"
echo "${NAME}"
kubectl get deployments ${NAME} --namespace=${NAMESPACE}
kubectl set image deployments/${NAME} ${NAME}=${IMAGE} --namespace=${NAMESPACE} --record
#kubectl delete pods -l app=${NAME} --namespace=${NAMESPACE}
