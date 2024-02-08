#!/bin/bash

# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantID=$(echo "$variables" | jq -r '.tenantId')
DCRFilePath="./DCRAssociation.json"
AMATestRuleName="AMATestRule"
description="Test DCR Rule for AMA"
location="East US"
arcsettingname="default"
extensionname="AzureMonitorWindowsAgent"
publisherName="Microsoft.Azure.Monitor"
extensionType="AzureMonitorWindowsAgent"

# Login using Azure Active Directory
az login --tenant $tenantID
az account set -s  $subscriptionId

# Create the Data Collection Rule
echo "Creating the Data Collection Rule"
az monitor data-collection rule create --name $AMATestRuleName --resource-group $resourceGroup --rule-file $DCRFilePath --description $description --location $location

# Get all clusters in the resource group
echo "Getting all clusters in the resource group"
clusters=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

# Install AMA extension for each cluster
echo "Installing AMA extension for each cluster"
for cluster in $clusters; do
    currentCluster=$cluster
    currentClusterId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/clusters/$currentCluster"
    echo "Installing AMA extension for cluster $currentCluster"
        az stack-hci extension create \
                            --arc-setting-name $arcsettingname  \
                            --cluster-name $currentCluster \
                            --extension-name $extensionname \
                            --resource-group $resourceGroup \
                            --auto-upgrade true \
                            --publisher $publisherName  \
                            --type $extensionType

        echo "creating data association rule for $currentCluster"
        az monitor data-collection rule association create \
                                --name "AMATestName$currentCluster" \
                                --resource $currentClusterId \
done
