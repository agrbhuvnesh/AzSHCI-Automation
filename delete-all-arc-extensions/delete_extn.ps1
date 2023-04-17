
$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv

foreach ($currentCluster in $clusters) {
    Start-Job -ScriptBlock {
        "Deleting Arc Extensions for cluster $using:currentCluster"
		az resource delete  --ids (az stack-hci extension list  --arc-setting-name "default" --cluster-name $using:currentCluster --resource-group $using:resourceGroup --subscription $using:subscriptionId --query "[].id" -o tsv) 
	}
}