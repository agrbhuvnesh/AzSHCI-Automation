$subscriptionId = "test-subscription"
$resourceGroup = "test-rg"
$tenantId = ""
$settings= "path to workspace_mma.json"
$protectedSetting = "path to workspacekey_mma.json"


#Using CLI 

$_ = az login --tenant $tenantId
$_ = az account set -s  $subscriptionId

$clusters = @(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    Start-Job -ScriptBlock {
        Write-Host ("Installing MMA extension for cluster $using:currentCluster")
		az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "MicrosoftMonitoringAgent" --resource-group $using:resourceGroup --auto-upgrade true --publisher "Microsoft.EnterpriseCloud.Monitoring" --type "MicrosoftMonitoringAgent" --settings @$using:settings  --protected-settings @$using:protectedSetting --type-handler-version "1.10" 
		
    } 
}

#Using Powershell 

Connect-AzAccount -Tenant $tenantId
set-AzContext -Subscription $subscriptionId

$clusters = @(Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

foreach($cluster in $clusters) {
    Start-Job -ScriptBlock {
        Write-Host ("Installing MMA extension for cluster $using:cluster")
        New-AzStackHciExtension -ClusterName $using:cluster -ResourceGroupName $using:resourceGroup -ArcSettingName "default" -ExtensionName "MicrosoftMonitoringAgent" -AutoUpgrade $true -Publisher "Microsoft.EnterpriseCloud.Monitoring" -Type "MicrosoftMonitoringAgent" -SettingsFile $using:settings -ProtectedSettingsFile $using:protectedSetting -TypeHandlerVersion "1.10"
    }
}