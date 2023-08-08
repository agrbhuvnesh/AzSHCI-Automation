$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$parametersFile = ".\asr-settings.json"

#USING CLI 
az login --tenant $tenantID
az account set -s  $subscriptionId

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    Write-Host ("Installing ASR extension for cluster $currentCluster")
    Start-Job -ScriptBlock {
       az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "AzureSiteRecovery" --resource-group $using:resourceGroup --auto-upgrade true --publisher "Microsoft.SiteRecovery.Dra" --type "Windows" --settings @$using:parametersFile
    } 
}


#USING POwershell

Connect-AzAccount -Tenant $tenantID
set-AzContext -Subscription $subscriptionId

$clusters = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

foreach($cluster in $clusters) {
    Write-Host ("Installing ASR extension for cluster $cluster")
    Start-Job -ScriptBlock {
        New-AzStackHciExtension -ClusterName $using:cluster -ResourceGroupName $using:resourceGroup -ArcSettingName "default" -ExtensionName "AzureSiteRecovery" -AutoUpgrade $true -Publisher "Microsoft.SiteRecovery.Dra" -Type "Windows" -SettingsFile $using:parametersFile
    }
}