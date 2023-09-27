#!/bin/bash

subscriptionId=""
resourceGroup=""
tenantId=""

# Login using Azure Active Directory
login=$(az login --tenant $tenantId)
az account set -s $subscriptionId

# Get all clusters in a resource group
echo "Getting all clusters in the resource group"
clusterIds=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv)

# Delete all clusters in a resource group
echo "Deleting all clusters in the resource group"
az stack-hci cluster delete --ids $clusterIds --resource-group $resourceGroup

# Delete a particular cluster in a resource group
clusterName=""
echo "Deleting cluster $clusterName"
az stack-hci cluster delete --name $clusterName --resource-group $resourceGroup
