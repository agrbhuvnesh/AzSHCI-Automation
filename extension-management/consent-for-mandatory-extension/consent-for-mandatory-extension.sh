#!/bin/bash

subscriptionId=""
resourceGroup=""
tenantId=""
 

# Login using Azure Active Directory
az login --tenant $tenantId
az account set --subscription $subscriptionId

 

# Get all clusters in a resource group
clusters=$(az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv)

 

# Consent and Install Default Extensions for all clusters in a resource group
for cluster in $clusters
do
    echo "Consenting for mandatory extensions on cluster $cluster"
    az stack-hci arc-setting consent-and-install-default-extension \
                                    --arc-setting-name "default" \
                                    --cluster-name $cluster \
                                    --resource-group $resourceGroup 
done

 

# Consent and Install Default Extensions for a particular cluster in a resource group
$clusterName=""
az stack-hci arc-setting consent-and-install-default-extension \
                                    --arc-setting-name "default" \
                                    --cluster-name $clusterName \
                                    --resource-group $resourceGroup 

