#!/bin/bash

subscriptionId=""
resourceGroup=""
tenantId=""
resourceType="Microsoft.AzureStackHCI/clusters"
desiredProperties="{diagnosticLevel:Basic,windowsServerSubscription:Enabled}"

# Login using Azure Active Directory
login=$(az login --tenant $tenantId)
az account set -s $subscriptionId

# Get all clusters in a resource group
echo "Getting all clusters in a resource group"
clusters=$(az resource list --resource-group $resourceGroup --resource-type $resourceType --query "[].id" -o tsv)

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for multiple clusters with tags
az stack-hci cluster update \
				--desired-properties $desiredProperties \
				--tags tag1="tag1" tag2="tag2" \
				--ids $clusters

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for a particular cluster with tags 
echo "Updating Diagnostic Level as Enhanced and and setting WSS as Enabled for $clusterName with tags"
clusterName=""
az stack-hci cluster update \
				--desired-properties $desiredProperties \
				--tags tag1="tag1" tag2="tag2" \
				--name $clusterName \
				--resource-group $resourceGroup
