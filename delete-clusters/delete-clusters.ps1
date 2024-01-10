$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscriptionId = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenantId = $variables.tenantId
$clusterName = $variables.clusterName

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantId 
Set-AzContext -Subscription $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in the resource group"
$clusters = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

# Delete all clusters in a resource group
foreach ($cluster in $clusters) {  
        "Deleting cluster $cluster"
        Remove-AzStackHciCluster -Name $cluster -ResourceGroupName $resourceGroup  
}

# Delete a particular cluster in a resource group
"Deleting cluster $clusterName"
Remove-AzStackHciCluster -Name $clusterName -ResourceGroupName $resourceGroup