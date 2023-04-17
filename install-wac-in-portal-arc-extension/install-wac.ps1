$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
az login --tenant $tenantId
az account set -s  $subscriptionId
$settingsPath = "path to port-wac.json"

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv

foreach ($currentCluster in $clusters) {
    Start-Job -ScriptBlock {
        "Installing WAC extension for cluster $using:currentCluster"
        az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "AdminCenter" --resource-group $using:resourceGroup --publisher "Microsoft.AdminCenter" --type "AdminCenter" --settings $settingsPath
    }
}