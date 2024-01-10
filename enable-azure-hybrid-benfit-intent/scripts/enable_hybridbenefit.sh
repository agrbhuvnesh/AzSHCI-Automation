#!/bin/bash

# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantId=$(echo "$variables" | jq -r '.tenantId')
clusterName=$(echo "$variables" | jq -r '.clusterName')

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
az login --tenant $tenantId
az account set --subscription $subscriptionId

# Get all clusters in a resource group
echo "Getting all clusters in a resource group"
clusters=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv)

# Enable Hybrid benefit for all clusters in a resource group
echo "Enabling Azure Hybrid Benefit for all clusters"
az stack-hci cluster extend-software-assurance-benefit \
                                    --ids $clusters \
                                    --resource-group $resourceGroup \
                                    --software-assurance-intent "enable"

# Enable Hybrid benefit for a particular cluster in a resource group
echo "Enabling Azure Hybrid Benefit for cluster $clusterName"
az stack-hci cluster extend-software-assurance-benefit \
                                    --cluster-name $clusterName \
                                    --resource-group $resourceGroup \
                                    --software-assurance-intent "enable"