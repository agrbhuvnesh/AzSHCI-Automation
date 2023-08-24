$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$parametersFilePath = "path to asr parameters file" 

# USING CLI

 

az login --tenant $tenantID
az account set -s  $subscriptionId

 

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv

foreach ($currentCluster in $clusters) {
    Write-Host ("Installing ASR extension for cluster $currentCluster")
  
    az stack-hci extension create `
        --arc-setting-name "default" `
        --cluster-name $currentCluster `
        --extension-name "ASRExtension" `
        --resource-group $resourceGroup `
        --auto-upgrade true `
        --publisher "Microsoft.SiteRecovery.Dra" `
        --type "Windows" `
        --settings @$parametersFilePath `
    
}
 

# USING Powershell


Connect-AzAccount -Tenant $tenantID
set-AzContext -Subscription $subscriptionId

 $asrProperties = @{}
 (Get-Content $parametersFilePath -Raw| ConvertFrom-Json).psobject.properties | Foreach { $asrProperties[$_.Name] = $_.Value }

$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name
 
foreach ($cluster in $clusters) {
    Write-Host ("Installing ASR extension for cluster $cluster")
    New-AzStackHciExtension `
        -ClusterName $cluster `
        -ResourceGroupName $resourceGroup `
        -ArcSettingName "default" `
        -Name "ASRExtension" `
        -ExtensionParameterPublisher "Microsoft.SiteRecovery.Dra" `
        -ExtensionParameterType "Windows" `
        -ExtensionParameterSetting $asrProperties
        -NoWait
}