$tenant = ""
$subscription = ""
$resourceGroup = ""

# Connect-AzAccount
Set-AzContext -Subscription $subscription
$clusters = (Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters").Name

Foreach ($cluster in $Clusters) {
 Invoke-AzRestMethod -Method POST -SubscriptionId $subscription -ResourceGroupName $resourceGroup -ResourceProviderName "Microsoft.AzureStackHCI" -ResourceType "clusters" -Name ($cluster + "/extendSoftwareAssuranceBenefit") -ApiVersion "2023-02-01" -Payload '{"properties": { "softwareAssuranceIntent": "Enable" }}' 
 }
