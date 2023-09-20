$subscriptionId = "" #enter subscription id here
$resourceGroup = "" #enter the resource group where the clusters exist
$tenantId = "" #enter the tenant id here

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

$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

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

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv

#Consent and Install Default Extensions for all clusters in a resource group

foreach ($cluster in $clusters) {

    Write-Host ("Consenting for mandatory extensions on cluster $cluster")

    az stack-hci arc-setting consent-and-install-default-extension `
                                    --arc-setting-name "default" `
                                    --cluster-name $cluster `
                                    --resource-group $resourceGroup 
}
#Consent and Install Default Extensions for a particular cluster in a resource group

$clusterName = ""

az stack-hci arc-setting consent-and-install-default-extension `
                                    --arc-setting-name "default" `
                                    --cluster-name $clusterName `
                                    --resource-group $resourceGroup 



