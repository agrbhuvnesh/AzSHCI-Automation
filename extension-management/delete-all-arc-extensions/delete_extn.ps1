
$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$arcSettingName = "default"

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

# Get all clusters in the resource group
"Get all clusters in the resource group"
$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv

# Delete all extensions for all the clusters in the resource group
"Delete all extensions for all the clusters in the resource group"
foreach ($currentCluster in $clusters) {
    "Deleting Arc Extensions for cluster $currentCluster"
    az resource delete  --ids (az stack-hci extension list `
                                --arc-setting-name $arcSettingName  `
                                --cluster-name $currentCluster `
                                --resource-group $resourceGroup `
                                --subscription $subscriptionId `
                                --query "[].id" -o tsv) 
}

# To delete a particular extension for all the clusters in the resource-group 
$extensionName = "AzureMonitorWindowsAgent"
"To delete a $extensionName extension for all the clusters in the resource-group "
foreach ($currentCluster in $clusters) {
    "Deleting Arc Extension $extensionName for cluster $currentCluster"
    az stack-hci extension delete `
        --arc-setting-name $arcSettingName  `
        --name "${extensionName}" `
        --cluster-name "${currentCluster}" `
        --resource-group "${resourceGroup}" `
        --no-wait
}

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId
Set-AzContext -Subscription $subscriptionId

# Delete all extensions for a cluster in the resource group
$clusterName = ""
"Delete all extensions for a cluster $clusterName in the resource group"
$extensions = (Get-AzStackHciExtension -ClusterName $clusterName -ResourceGroupName $resourceGroup -ArcSettingName $arcSettingName).Name
foreach ($extension in $extensions) {
    {
        "Deleting Arc Extension $extensionName for cluster $clusterName"
        Remove-AzStackHciExtension -ClusterName $clusterName -ResourceGroupName $resourceGroup -ArcSettingName $arcSettingName -Name $extension -NoWait
    }
}

# Delete a particular extension for a cluster in the resource group
$extensionName = ""
"Delete a particular extension $extensionName for a cluster $clusterName in the resource group"
Remove-AzStackHciExtension -ClusterName $clusterName `
                            -ResourceGroupName $resourceGroup `
                            -ArcSettingName $arcSettingName `
                            -Name $extensionName `
                            -NoWait
