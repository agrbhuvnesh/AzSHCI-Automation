$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

#With Az-RestMethod

$apiVersion = "2023-03-01"

Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId

$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty ResourceId

foreach ($cluster in $clusters) {
    $path = "$cluster/arcSettings/default/consentAndInstallDefaultExtensions?api-version=$apiVersion"

    Write-Host ("Consenting for mandatory extensions on cluster $cluster")

    Invoke-AzRestMethod `
        -Path $path `
        -Method POST `
        -AsJob
}

#with Az stackHCI Powershell

Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId

#Consent and Install Default Extensions for all clusters in a resource group

$clusters = (Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters").Name

foreach ($cluster in $clusters) {

    Write-Host ("Consenting for mandatory extensions on cluster $cluster")

    Invoke-AzStackHciConsentAndInstallDefaultExtension `
                        -ResourceGroupName $resourceGroup `
                        -ClusterName $cluster
}

#Consent and Install Default Extensions for a particular cluster in a resource group

$clusterName = ""

Invoke-AzStackHciConsentAndInstallDefaultExtension `
                        -ResourceGroupName $resourceGroup `
                        -ClusterName $clusterName

#with Az CLI

az login --tenant $tenant
az account set --subscription $subscription

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

#Consent and Install Default Extensions for all clusters in a resource group

az stack-hci arc-setting consent-and-install-default-extension `
                                    --arc-setting-name "default" `
                                    --ids $clusters `
                                    --resource-group $resourceGroup 

#Consent and Install Default Extensions for a particular cluster in a resource group

$clusterName = ""

az stack-hci arc-setting consent-and-install-default-extension `
                                    --arc-setting-name "default" `
                                    --cluster-name $clusterName `
                                    --resource-group $resourceGroup 



