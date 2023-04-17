$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

$login = az login --tenant $tenantId
az account set -s  $subscriptionId

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].id" -o tsv
for ($i = 0; $i -lt $clusters.Count; ) {
	$currentCluster = $clusters[$i..($i+10)]
	Write-Host ("Update cluster $currentCluster")
	$i = $i+10
	Start-Job -ScriptBlock {
		az stack-hci cluster update --desired-properties diagnostic-level="Enhanced" windows-server-subscription="Enabled" --tags DoNotDelete="true" demo="true" --ids $using:currentCluster
	}
}
	