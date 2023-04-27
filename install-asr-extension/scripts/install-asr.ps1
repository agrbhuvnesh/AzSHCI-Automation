$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$parametersFile = ".\asr-settings.json"



az login --tenant $tenantID
az account set -s  $subscriptionId

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    Write-Host ("Installing ASR extension for cluster $currentCluster")
    Start-Job -ScriptBlock {
       az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "AzureSiteRecovery" --resource-group $using:resourceGroup --auto-upgrade true --publisher "Microsoft.SiteRecovery.Dra" --type "Windows" --settings @$using:parametersFile
    } 
}
