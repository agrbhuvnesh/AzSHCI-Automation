$subscriptionId = "test-subscription"
$resourceGroup = "test-rg"
$tenantId = ""
$settings= "path to workspace_mma.json"
$protectedSetting = "path to workspacekey_mma.json"

$_ = az login --tenant $tenantId
$_ = az account set -s  $subscriptionId

$clusters = @(az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv)

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    Start-Job -ScriptBlock {
        Write-Host ("Installing MMA extension for cluster $using:currentCluster")
		az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "MicrosoftMonitoringAgent" --resource-group $using:resourceGroup --auto-upgrade true --publisher "Microsoft.EnterpriseCloud.Monitoring" --type "MicrosoftMonitoringAgent" --settings @$using:settings  --protected-settings @$using:protectedSetting --type-handler-version "1.10" 
		
    } 
}
