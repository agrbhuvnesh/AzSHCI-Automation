#!/bin/bash

# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantId=$(echo "$variables" | jq -r '.tenantId')
extensionName=$(echo "$variables" | jq -r '.extensionName')

# Login using Azure Active Directory
login=$(az login --tenant $tenantId)
az account set -s $subscriptionId

# Get all clusters in the resource group
echo "Get all clusters in the resource group"
clusters=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

# Delete all extensions for all the clusters in the resource group
echo "Delete all extensions for all the clusters in the resource group"
for currentCluster in $clusters; do
    echo "Deleting Arc Extensions for cluster $currentCluster"
    az resource delete  --ids $(az stack-hci extension list \
                                --arc-setting-name "default"  \
                                --cluster-name $currentCluster \
                                --resource-group $resourceGroup \
                                --subscription $subscriptionId \
                                --query "[].id" -o tsv) 
done

# To delete a particular extension for all the clusters in the resource-group 

echo "To delete a $extensionName extension for all the clusters in the resource-group "
for currentCluster in $clusters; do
    echo "Deleting Arc Extension $extensionName for cluster $currentCluster"
    az stack-hci extension delete \
        --arc-setting-name "default"  \
        --name "${extensionName}" \
        --cluster-name "${currentCluster}" \
        --resource-group "${resourceGroup}" \
        --no-wait
done
