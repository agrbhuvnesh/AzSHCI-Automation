$subscription = ""
$resourceGroup = ""
$tenant = ""
$resourceType = ""

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

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
az login --tenant $tenant
az account set --subscription $subscription

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = az resource list --resource-group $resourceGroup --resource-type $resourceType --query "[].name" -o tsv

# Disable Azure Hybrid benefit for each cluster
foreach ($cluster in $clusters)
{
    "Disabling Azure Hybrid Benefit for cluster $cluster"
    az stack-hci cluster extend-software-assurance-benefit --cluster-name $cluster -g $resourceGroup --software-assurance-intent disable
}
