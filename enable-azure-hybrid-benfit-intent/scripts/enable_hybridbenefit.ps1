$subscriptionId = ""
$resourceGroup = ""
$tenant = ""
$resourceType = ""

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
$clusterName = ""
"Enabling Azure Hybrid Benefit for cluster $clusterName"
Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit `
                                    -ClusterName $clusterName `
                                    -ResourceGroupName $resourceGroup `
                                    -SoftwareAssuranceIntent "Enable"

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
az login --tenant $tenant
az account set --subscription $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

# Enable Hybrid benefit for all clusters in a resource group
"Enabling Azure Hybrid Benefit for all clusters"
az stack-hci cluster extend-software-assurance-benefit `
                                    --ids $clusters `
                                    --resource-group $resourceGroup `
                                    --software-assurance-intent "enable"

# Enable Hybrid benefit for a particular cluster in a resource group
$clusterName = ""
"Enabling Azure Hybrid Benefit for cluster $clusterName"
az stack-hci cluster extend-software-assurance-benefit `
                                    --cluster-name $clusterName `
                                    --resource-group $resourceGroup `
                                    --software-assurance-intent "enable"
    
 