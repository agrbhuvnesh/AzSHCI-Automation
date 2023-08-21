$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$parametersFilePath = ""
$parametersFile = Get-Content $parametersFilePath -Raw | ConvertFrom-Json
$extensionParameters = $parametersFile.properties.extensionParameters

 

# USING CLI

 

az login --tenant $tenantID
az account set -s  $subscriptionId

 

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv

 

 

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    Write-Host ("Installing ASR extension for cluster $currentCluster")
  
       az stack-hci extension create --arc-setting-name "default" --cluster-name $currentCluster --extension-name "AzureSiteRecovery" --resource-group $resourceGroup --auto-upgrade true --publisher "Microsoft.SiteRecovery.Dra" --type "Windows" --settings-file $parametersFile
    
}

 

# USING POwershell

 

Connect-AzAccount -Tenant $tenantID
set-AzContext -Subscription $subscriptionId

 

$clusters = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

 

foreach($cluster in $clusters) {
    Write-Host ("Installing ASR extension for cluster $cluster")
    Start-Job -ScriptBlock {
        New-AzStackHciExtension -ClusterName $cluster -ResourceGroupName $resourceGroup -ArcSettingName "default" -Name "AzureSiteRecovery" -ExtensionParameterPublisher "Microsoft.SiteRecovery.Dra" -ExtensionParameterType "Windows" -ExtensionParameterSetting $extensionParameters.protectedSettings
    }
}