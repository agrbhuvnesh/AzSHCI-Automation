$subscription = ""
$resourceGroup = ""
$tenantId = ""

# $login = az login --tenant $tenantId
# az account set -s  $subscriptionId

# $clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].id" -o tsv
# for ($i = 0; $i -lt $clusters.Count; ) {
	# $currentCluster = $clusters[$i..($i+10)]
	# Write-Host ("Update cluster $currentCluster")
	# $i = $i+10
	# Start-Job -ScriptBlock {
		# az stack-hci cluster update --desired-properties diagnostic-level="Basic" windows-server-subscription="Disabled" --tags atscale="false" demo="false" --ids $using:currentCluster
	# }
# }


# #powershell 
# $clusters = (Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters")
# ##Set-AzsHCIStackCluster can't set Tags
# Foreach ($cluster in $clusters) {
# Set-AzStackHCI -ResourceId $cluster.Id -DiagnosticLevel Basic -EnableWSSubscription $true -Force
# Set-AzResource -ResourceId $cluster.Id -Tag $tag -Force
# }


# Connect-AzAccount
Set-AzContext -Subscription $subscription
$clusters = (Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters")
Foreach ($cluster in $clusters) {
 Invoke-AzRestMethod -Method PUT -SubscriptionId $subscription -ResourceGroupName $resourceGroup -ResourceProviderName "Microsoft.AzureStackHCI" -ResourceType "clusters" -Name $cluster.Name -ApiVersion "2023-02-01" -Payload '{
	"properties": {
		"desiredProperties": {
			"windowsServerSubscription": "Enabled",
			"diagnosticLevel": "Basic"
		}
	},
	"tags": {
		"DoNotDelete": "true"
	},
	 "location": "eastus2euap",
}'  
 }

			 
