# This scripts configures insights for a cluster by creating DCR, installing AMA and associating DCR.

$subscriptionId = ""
$resourceGroup = ""
$tenantID = ""
$DCRFilePath = ""
$AMATestRuleName = "AMATestRule"
$description = "Test DCR Rule for AMA"
$location = "East US"
$arcsettingname = "default"
$extensionname = "AzureMonitorWindowsAgent"
$publisherName = "Microsoft.Azure.Monitor"
$extensionType = "AzureMonitorWindowsAgent"

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantID
Set-AzContext -Subscription $subscriptionId

# Get the list of clusters
"Getting the list of all clusters"
$resourceType = "Microsoft.AzureStackHCI/clusters" 
$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType $resourceType

# Create the Data Collection Rule
"Creating the Data Collection Rule"
$rule = New-AzDataCollectionRule -RuleName $AMATestRuleName -ResourceGroupName $resourceGroup -RuleFile $DCRFilePath -Description $description -Location $location
$dcrRuleId = $rule.Id

# Install AMA extension for each cluster
"Installing AMA extension for each cluster"
foreach ($cluster in $clusters) {
    $currentCluster = $cluster.Name
    $currentClusterId = $cluster.Id

        Write-Host ("Installing AMA extension for cluster $currentCluster")
        # Install the AMA extension
        New-AzStackHciExtension `
            -ClusterName $currentCluster `
            -ResourceGroupName $resourceGroup `
            -ArcSettingName $arcsettingname `
            -Name $extensionname `
            -ExtensionParameterPublisher $publisherName `
            -ExtensionParameterType $extensionType

    # Associating Data Collection Rule with
        Write-Host ("creating data association rule for $currentCluster")
        New-AzDataCollectionRuleAssociation `
            -AssociationName "AMATestName$currentCluster" `
            -TargetResourceId $currentClusterId `
            -RuleId $dcrRuleId
}
