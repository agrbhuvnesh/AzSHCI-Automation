$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

 

# Using CLI

 

$login = az login --tenant $tenantId
az account set -s  $subscriptionId

 

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

 

## Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for multiple clusters with tags

 

az stack-hci cluster update `
				--desired-properties "{diagnosticLevel:Basic,windowsServerSubscription:Disabled}" `
				--tags tag1="tag1" tag2="tag2" `
				--ids $clusters

 

 

## Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for a particular cluster with tags

 

$clusterName = ""
az stack-hci cluster update `
				--desired-properties "{diagnosticLevel:Basic,windowsServerSubscription:Disabled}" `
				--tags tag1="tag1" tag2="tag2" `
				--name $clusterName `
				--resource-group $resourceGroup

 

 

# Using Powershell

 

Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

 

$clusters = (Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

 

## Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for multiple clusters with tags

 

foreach($currentCluster in $clusters) {
	
		"Updating cluster $using:currentCluster"
		Update-AzStackHciCluster -Name $currentCluster `
								-ResourceGroupName $resourceGroup `
								-DesiredPropertyDiagnosticLevel "Enhanced" `
								-DesiredPropertyWindowsServerSubscription "Disabled" `
								-Tag @{"tag1"="tag1";"tag2"="tag2"}
}

 

 

# Update Diagnostic Level as "Enhanced" and setting WSS as "Disabled" for a particular cluster with tags

 

$clusterName = ""
Update-AzStackHciCluster -Name $clusterName `
						-ResourceGroupName $resourceGroup `
						-DesiredPropertyDiagnosticLevel "Enhanced" `
						-DesiredPropertyWindowsServerSubscription "Disabled" `
						-Tag @{"tag1"="tag1";"tag2"="tag2"}
