$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

 

 

# Using CLI

 

$login = az login --tenant $tenantId
az account set -s  $subscriptionId

 

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].id" -o tsv

 

## Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for multiple clusters with tags
az stack-hci cluster update `
				--desired-properties "{diagnosticLevel:Basic,windowsServerSubscription:Enabled}" `
				--tags tag1="tag1" tag2="tag2" `
				--ids $clusters

 

## Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for a particular cluster with tags 
$clusterName = ""
az stack-hci cluster update `
				--desired-properties "{diagnosticLevel:Basic,windowsServerSubscription:Enabled}" `
				--tags tag1="tag1" tag2="tag2" `
				--name $clusterName `
				--resource-group $resourceGroup

 

# Using Powershell

 

Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

 

$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

 

## Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for multiple clusters with tags

 

foreach($currentCluster in $clusters) {
	
		"Updating cluster $currentCluster"
		Update-AzStackHciCluster -Name $currentCluster `
								-ResourceGroupName $resourceGroup `
								-DesiredPropertyDiagnosticLevel "Enhanced" `
								-DesiredPropertyWindowsServerSubscription "Enabled" `
								-Tag @{"tag1"="tag1";"tag2"="tag2"}
	
}

 

# Update Diagnostic Level as "Enhanced" and setting WSS as "Enabled" for a particular cluster with tags

 

$clusterName = ""
Update-AzStackHciCluster -Name $clusterName `
						-ResourceGroupName $resourceGroup `
						-DesiredPropertyDiagnosticLevel "Enhanced" `
						-DesiredPropertyWindowsServerSubscription "Enabled" `
						-Tag @{"tag1"="tag1";"tag2"="tag2"}