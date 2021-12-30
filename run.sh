#!/usr/bin/env bash

set -x

export LOCATION=germanywestcentral

export RESOURCE_GROUP=AZURE-AKS-WINPOOL
export CLUSTER_NAME=AKS-CLUSTER-WINPOOL

export USERNAME_WINDOWS=azureuser
export PASSWORD_WINDOWS=`echo $RANDOM | md5sum | head -c 16; echo;`"#$*AZ"

set +x
echo "################################################################################"
echo "### Location Frankfurt"
echo "################################################################################"
set -x

az group create \
    --name ${RESOURCE_GROUP} \
    --location ${LOCATION}

sleep 20

time az aks create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTER_NAME} \
    --node-count 2 \
    --network-plugin azure \
    --windows-admin-username ${USERNAME_WINDOWS} \
    --windows-admin-password ${PASSWORD_WINDOWS}


sleep 60

az group list \
    --query [].name \
    --output table

sleep 20

az resource list \
    --location ${LOCATION} \
    --query [].name \
    --output table

sleep 20

az aks nodepool add \
    --resource-group ${RESOURCE_GROUP} \
    --cluster-name ${CLUSTER_NAME} \
    --node-count 2 \
    --os-type Windows \
    --name winnp

sleep 60

az group list \
    --query [].name \
    --output table

sleep 20

az resource list \
    --location ${LOCATION} \
    --query [].name \
    --output table

sleep 20

az aks get-credentials \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTER_NAME} \
    --overwrite-existing

sleep 20

set +x
echo "################################################################################"
echo "### get nodes and pods"
echo "################################################################################"
set -x

kubectl get nodes

sleep 20

kubectl get deployments --all-namespaces

kubectl get pods --all-namespaces

sleep 20

az aks delete \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTER_NAME} \
    --yes

sleep 20

az group delete \
    --name ${RESOURCE_GROUP} \
    --no-wait \
    --yes

sleep 20