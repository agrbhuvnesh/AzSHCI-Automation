$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$desiredProperties = "{diagnosticLevel:Basic,windowsServerSubscription:Disabled}"
$resourceType = "Microsoft.AzureStackHCI/clusters"
$desiredPropertyDiagLevel = "Enhanced"
$desiredPropertyWSS = "Disabled"

# Using Powershell

# Login using Azure Actuve Directory
Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for multiple clusters with tags
"Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for all clusters"

foreach($currentCluster in $clusters) {
		"Updating cluster $currentCluster"
		Update-AzStackHciCluster -Name $currentCluster `
								-ResourceGroupName $resourceGroup `
								-DesiredPropertyDiagnosticLevel $desiredPropertyDiagLevel `
								-DesiredPropertyWindowsServerSubscription $desiredPropertyWSS `
								-Tag @{"tag1"="tag1";"tag2"="tag2"}
}

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for a particular cluster with tags
$clusterName = ""
"Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for $clusterName"
Update-AzStackHciCluster -Name $clusterName `
						-ResourceGroupName $resourceGroup `
						-DesiredPropertyDiagnosticLevel $desiredPropertyDiagLevel `
						-DesiredPropertyWindowsServerSubscription $desiredPropertyWSS `
						-Tag @{"tag1"="tag1";"tag2"="tag2"}
