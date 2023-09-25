$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$resourceType = "Microsoft.AzureStackHCI/clusters"
$desiredProperties = "{diagnosticLevel:Basic,windowsServerSubscription:Disabled}"


# Using Command Line Interface (CLI)

# Login using Azure Active Directory
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

# Get all clusters in a resource group
"Getting all clusters in a resource group"
$clusters = az resource list --resource-group $resourceGroup --resource-type $resourceType --query "[].id" -o tsv

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for multiple clusters with tags
az stack-hci cluster update `
				--desired-properties $desiredProperties `
				--tags tag1="tag1" tag2="tag2" `
				--ids $clusters

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for a particular cluster with tags 
"Updating Diagnostic Level as Enhanced and and setting WSS as Enaabled for $clusterName with tags"
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

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for multiple clusters with tags
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

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for a particular cluster with tags
"Updating Diagnostic Level as Enhanced and and setting WSS as Enabled for $clusterName"
$clusterName = ""
Update-AzStackHciCluster -Name $clusterName `
						-ResourceGroupName $resourceGroup `
						-DesiredPropertyDiagnosticLevel $desiredPropertyDiagLevel `
						-DesiredPropertyWindowsServerSubscription $desiredPropertyWSS `
						-Tag @{"tag1"="tag1";"tag2"="tag2"}
						