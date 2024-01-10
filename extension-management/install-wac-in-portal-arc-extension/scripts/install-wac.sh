#!/bin/bash

# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantId=$(echo "$variables" | jq -r '.tenantId')
settingsConfig="{'port':'6516'}"
extensionname="AdminCenter"
publisherName="Microsoft.AdminCenter"
extensionType="AdminCenter"
connectivityProps="{enabled:true}"
RPName="Microsoft.AzureStackHCI"
ApiVersion="2023-02-01"

# Login using Azure Active Directory
az login --tenant $tenantId
az account set -s  $subscriptionId

# Get all clusters in the resource group
echo "Getting all clusters in the resource group"
clusters=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

# Install WAC extension for each cluster
echo "Installing WAC extension for each cluster"
for currentCluster in $clusters; do
    echo "Enabling Connectivity for cluster $currentCluster"
    az stack-hci arc-setting update \
        --resource-group $resourceGroup \
        --cluster-name $currentCluster \
        --name "default" \
        --connectivity-properties $connectivityProps

    echo "Installing WAC extension for cluster $currentCluster"
    az stack-hci extension create \
        --arc-setting-name "default"  \
        --cluster-name $currentCluster \
        --extension-name $extensionname \
        --resource-group $resourceGroup \
        --publisher $publisherName  \
        --type $extensionType \
        --settings "$settingsConfig"
done
