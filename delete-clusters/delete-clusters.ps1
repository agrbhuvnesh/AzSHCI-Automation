
$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

$clusterIds = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].id" -o tsv

az stack-hci cluster delete --ids $clusterIds --resource-group $resourceGroup

