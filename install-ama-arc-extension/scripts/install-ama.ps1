$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$DCRFilePath = "path to DCRAssociation.json"
$AMATestRuleName = "AMATestRule"

 

 

# Using CLI

 

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

 

 

# Using Powershell

 

# Connect to Azure
Connect-AzAccount -Tenant $tenantID
Set-AzContext -Subscription $subscriptionId

 

 

# Get the list of clusters
$clusters = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup)

 


# Create the Data Collection Rule

 

$rule = New-AzDataCollectionRule -RuleName $AMATestRuleName -ResourceGroupName $resourceGroup -RuleFile $DCRFilePath -Description "Test DCR Rule for AMA" -Location "East US"
$dcrRuleId = $rule.Id

 

 

# Loop through each cluster
foreach ($cluster in $clusters) {
    $currentCluster = $cluster.Name
    $currentClusterId = $cluster.Id

 

 

    
    $scriptBlock = {
        param (
            $clusterName,
            $clusterId,
            $resourceGroup,
            $dcrId
        )
        Write-Host ("Installing AMA extension for cluster $clusterName")
        # Install the AMA extension
        New-AzStackHciExtension `
            -ClusterName $clusterName `
            -ResourceGroupName $resourceGroup `
            -ArcSettingName "default" `
            -Name "AzureMonitorWindowsAgent" `
            -ExtensionParameterPublisher "Microsoft.Azure.Monitor" `
            -ExtensionParameterType "AzureMonitorWindowsAgent"

 

 

        Write-Host ("creating data association rule for $clusterName")
        New-AzDataCollectionRuleAssociation `
            -AssociationName "AMATestName$clusterName" `
            -TargetResourceId $clusterId `
            -RuleId $dcrId
    }

 

 

    Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $currentCluster, $currentClusterId, $resourceGroup, $dcrRuleId
}