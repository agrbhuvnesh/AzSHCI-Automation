#!/bin/bash

# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantId=$(echo "$variables" | jq -r '.tenantId')
clusterName=$(echo "$variables" | jq -r '.clusterName')
desiredProperties="{diagnosticLevel:Basic,windowsServerSubscription:Disabled}"

# Login using Azure Active Directory
login=$(az login --tenant $tenantId)
az account set -s $subscriptionId

# Get all clusters in a resource group
echo "Getting all clusters in a resource group"
clusters=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv)

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for multiple clusters with tags
echo "Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for multiple clusters with tags"
az stack-hci cluster update \
				--desired-properties $desiredProperties \
				--tags tag1="tag1" tag2="tag2" \
				--ids $clusters

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for a particular cluster with tags
echo "Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for $clusterName with tags"
az stack-hci cluster update \
				--desired-properties $desiredProperties \
				--tags tag1="tag1" tag2="tag2" \
				--name $clusterName \
				--resource-group $resourceGroup
