$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$DCRFilePath = "path to DCRAssociation.json"

# Connect-AzAccount -Subscription $subscriptionId
# New-AzDataCollectionRule -Location "East US" -ResourceGroupName bkumar-test-rg -RuleName "AMATestRule" -RuleFile "C:\bhuvi\azurestack\HCI\tryout\POC\DCRAssociation.json" -Description "Test DCR Rule for AMA"  -verbose



# for ($i = 0; $i -lt 2; $i++)
# {
# $currentCluster = $clusters[$i]
# Write-Host ($currentCluster)
# New-AzStackHciExtension  -ArcSettingName "default" -ClusterName $currentCluster -Name AzureMonitorWindowsAgent  -ResourceGroupName $resourceGroup -ExtensionParameterPublisher Microsoft.Azure.Monitor -ExtensionParameterType "AzureMonitorWindowsAgent"
    
# New-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/$using:subscriptionId/resourceGroups/bkumar-test-rg/providers/Microsoft.AzureStackHCI/clusters/$using:currentCluster" -AssociationName "AMATestNAme$i" -RuleId /subscriptions/$using:subscriptionId/resourceGroups/$using:resourceGroup/providers/Microsoft.Insights/dataCollectionRules/AMATestRule
# }



az login --tenant $tenantID
az account set -s  $subscriptionId
az monitor data-collection rule create --name "AMATestRule" --resource-group $resourceGroup --rule-file $DCRFilePath --description "Test DCR Rule for AMA" --location "East US"

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv
$clustersId = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].id" -o tsv

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    $currentClusterId = $clustersId[$i]
    Write-Host ("Installing AMA extension for cluster $using:currentCluster")
    Start-Job -ScriptBlock {
       az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "AzureMonitorWindowsAgent" --resource-group $using:resourceGroup --auto-upgrade true --publisher "Microsoft.Azure.Monitor" --type "AzureMonitorWindowsAgent"
        Write-Host ("creating data association rule for $using:currentCluster")
        az monitor data-collection rule association create --name "AMATestName$using:currentCluster" --resource $using:currentClusterId --rule-id $using:dcrRuleId 
    } 
}
