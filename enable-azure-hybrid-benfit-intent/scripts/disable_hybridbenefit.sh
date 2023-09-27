#!/bin/bash

 

# Variables

subscriptionId=""
resourceGroup=""
tenantId=""
resourceType="Microsoft.AzureStackHCI/clusters"

 

# Using Command Line Interface (CLI)

 

# Login using Azure Active Directory

az login --tenant $tenantId

az account set --subscription $subscriptionId

 

# Get all clusters in a resource group

echo "Getting all clusters in a resource group"

clusters=$(az resource list --resource-group $resourceGroup --resource-type $resourceType --query "[].name" -o tsv)

 

# Disable Azure Hybrid benefit for each cluster

for cluster in $clusters

do

    echo "Disabling Azure Hybrid Benefit for cluster $cluster"

    az stack-hci cluster extend-software-assurance-benefit --cluster-name $cluster -g $resourceGroup --software-assurance-intent disable

done
