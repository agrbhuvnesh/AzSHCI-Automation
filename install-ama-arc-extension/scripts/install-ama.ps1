$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$DCRFilePath = "path to DCRAssociation.json"
$AMATestRuleName = "AMATestRule"

#Using CLI 

az login --tenant $tenantID
az account set -s  $subscriptionId
az monitor data-collection rule create --name $AMATestRuleName --resource-group $resourceGroup --rule-file $DCRFilePath --description "Test DCR Rule for AMA" --location "East US"

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv
$clustersId = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    $currentClusterId = $clustersId[$i]
    Write-Host ("Installing AMA extension for cluster $using:currentCluster")
    Start-Job -ScriptBlock {
        az stack-hci extension create `
                            --arc-setting-name "default" `
                            --cluster-name $using:currentCluster `
                            --extension-name "AzureMonitorWindowsAgent" `
                            --resource-group $using:resourceGroup `
                            --auto-upgrade true `
                            --publisher "Microsoft.Azure.Monitor" `
                            --type "AzureMonitorWindowsAgent"

        Write-Host ("creating data association rule for $using:currentCluster")
        az monitor data-collection rule association create `
                                --name "AMATestName$using:currentCluster" `
                                --resource $using:currentClusterId `
                                --rule-id $using:dcrRuleId 
    } 
}

#Using Powershell

Connect-AzAccount -Tenant $tenantID  
set-AzContext -Subscription $subscriptionId

New-AzDataCollectionRule -RuleName $AMATestRuleName -ResourceGroupName $resourceGroup -RuleFile $DCRFilePath -Description "Test DCR Rule for AMA" -Location "East US"

$clusters = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name
$clusterIds = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Id

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    $currentClusterId = $clusterIds[$i]
    Write-Host ("Installing AMA extension for cluster $using:currentCluster")
    Start-Job -ScriptBlock {
        New-AzStackHciExtension `
                -ClusterName $using:currentCluster `
                -ResourceGroupName $using:resourceGroup `
                -ArcSettingName "default" `
                -ExtensionName "AzureMonitorWindowsAgent" `
                -AutoUpgrade $true `
                -Publisher "Microsoft.Azure.Monitor" `
                -Type "AzureMonitorWindowsAgent"

        Write-Host ("creating data association rule for $using:currentCluster")
        New-AzDataCollectionRuleAssociation `
                                    -Name "AMATestName$using:currentCluster" `
                                    -Resource $using:currentClusterId `
                                    -RuleId $using:dcrRuleId
    } 
}