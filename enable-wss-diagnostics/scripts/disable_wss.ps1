$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$desiredProperties = "{diagnosticLevel:Basic,windowsServerSubscription:Disabled}"


# Using Command Line Interface (CLI)

# Login using Azure Active Directory
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for multiple clusters with tags
"Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for multiple clusters with tags"
az stack-hci cluster update `
				--desired-properties $desiredProperties `
				--tags tag1="tag1" tag2="tag2" `
				--ids $clusters

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for a particular cluster with tags
"Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for $clusterName with tags"
$clusterName = ""
az stack-hci cluster update `
				--desired-properties $desiredProperties `
				--tags tag1="tag1" tag2="tag2" `
				--name $clusterName `
				--resource-group $resourceGroup

# Using Powershell

# Login using Azure Actuve Directory
Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$resourceType = "Microsoft.AzureStackHCI/clusters"
$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for multiple clusters with tags
"Updating Diagnostic Level as Enhanced and and setting WSS as Disabled for all clusters"
$desiredPropertyDiagLevel = "Enhanced"
$desiredPropertyWSS = "Disabled"
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
