$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscription = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenant = $variables.tenantId
$resourceType = "Microsoft.AzureStackHCI/clusters"

# Using Powershell

# Login using Azure Actuve Directory
Connect-AzAccount -Subscription $subscription

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name

# Disable Azure Hybrid Benefit for each cluster
Foreach ($cluster in $Clusters) {
        "Disabling Azure Hybrid Benefit for cluster $cluster"
        Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit -ClusterName $cluster -ResourceGroupName $resourceGroup -SoftwareAssuranceIntent "Disable"
}
