
$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId
Set-AzContext -Subscription $subscriptionId

# Delete all extensions for a cluster in the resource group
$clusterName = ""
"Delete all extensions for a cluster $clusterName in the resource group"
$extensions = (Get-AzStackHciExtension -ClusterName $clusterName -ResourceGroupName $resourceGroup -ArcSettingName "default").Name
foreach ($extension in $extensions) {
    {
        "Deleting Arc Extension $extensionName for cluster $clusterName"
        Remove-AzStackHciExtension -ClusterName $clusterName -ResourceGroupName $resourceGroup -ArcSettingName "default" -Name $extension -NoWait
    }
}

# Delete a particular extension for a cluster in the resource group
$extensionName = ""
"Delete a particular extension $extensionName for a cluster $clusterName in the resource group"
Remove-AzStackHciExtension -ClusterName $clusterName `
                            -ResourceGroupName $resourceGroup `
                            -ArcSettingName "default" `
                            -Name $extensionName `
                            -NoWait
