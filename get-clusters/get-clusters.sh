#!/bin/bash

# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantId=$(echo "$variables" | jq -r '.tenantId')
location=$(echo "$variables" | jq -r '.location')
IMDSStatus=$(echo "$variables" | jq -r '.IMDSStatus')
softwareStatus=$(echo "$variables" | jq -r '.softwareStatus')

# Login using Azure Active Directory
login=$(az login --tenant $tenantId)
az account set -s $subscriptionId

# Get clusters in location specified
echo "Get clusters in location $location"
az stack-hci cluster list --resource-group $resourceGroup --query "[?location=='$location'].{Name:name, Id:id}" -o table

# Get clusters with software assurance specified
echo "Get clusters with software assurance $softwareStatus"
az stack-hci cluster list --resource-group $resourceGroup --query "[?softwareAssuranceProperties.softwareAssuranceIntent=='$softwareStatus'].{Name:name, Id:id}" -o table
