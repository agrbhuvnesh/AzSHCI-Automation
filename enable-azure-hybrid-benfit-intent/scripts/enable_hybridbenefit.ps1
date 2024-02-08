$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscriptionId = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenant = $variables.tenantId
$clusterName = $variables.clusterName
$resourceType = "Microsoft.AzureStackHCI/clusters"

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenant
Set-AzContext -Subscription $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name

# Enable Hybrid benefit for all clusters in a resource group
Foreach ($cluster in $Clusters) {
        "Enabling Azure Hybrid Benefit for cluster $cluster"
        Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit `
                                    -ClusterName $cluster `
                                    -ResourceGroupName $resourceGroup `
                                    -SoftwareAssuranceIntent "Enable"
}

# Enable Hybrid benefit for a particular cluster in a resource group
"Enabling Azure Hybrid Benefit for cluster $clusterName"
Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit `
                                    -ClusterName $clusterName `
                                    -ResourceGroupName $resourceGroup `
                                    -SoftwareAssuranceIntent "Enable"
