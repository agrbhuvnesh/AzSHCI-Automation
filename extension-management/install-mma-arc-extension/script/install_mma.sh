#!/bin/bash
subscriptionId=""
resourceGroup=""
tenantId=""
extensionname="MicrosoftMonitoringAgent"
publisherName="Microsoft.EnterpriseCloud.Monitoring"
extensionType="MicrosoftMonitoringAgent"
workspaceId="yourworkspaceid"
workspaceKey="yourworkspacekey"
typeHandlerVersion="1.10"

# Using CLI

az login --tenant $tenantId
az account set -s $subscriptionId

clusters=($(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv))

for cluster in "${clusters[@]}"; do

    currentCluster=$cluster
    echo "Installing MMA extension for cluster $currentCluster"

    az stack-hci extension create \
        --arc-setting-name "default" \
        --cluster-name $currentCluster \
        --extension-name $extensionname \
        --resource-group $resourceGroup \
        --auto-upgrade true \
        --publisher $publisherName \
        --type $extensionType \
        --settings "{\"workspaceId\":\"$workspaceId\"}" \
        --protected-settings "{\"workspaceKey\":\"$workspaceKey\"}" \
        --type-handler-version $typeHandlerVersion
done