$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in the resource group"
$clusterIds = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

# Delete all clusters in a resource group
"Deleting all clusters in the resource group"
az stack-hci cluster delete --ids $clusterIds --resource-group $resourceGroup

# Delete a particular cluster in a resource group
$clusterName = ""
"Deleting cluster $clusterName"
az stack-hci cluster delete --name $clusterName --resource-group $resourceGroup

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
$clusterName = ""
"Deleting cluster $clusterName"
Remove-AzStackHciCluster -Name $clusterName -ResourceGroupName $resourceGroup