$tenant = ""
$subscription = ""
$resourceGroup = ""


#Powershell
Connect-AzAccount
Set-AzContext -Subscription $subscription
$clusters = (Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters").Name

Foreach ($cluster in $Clusters) {
 Invoke-AzRestMethod -Method POST -SubscriptionId $subscription -ResourceGroupName $resourceGroup -ResourceProviderName "Microsoft.AzureStackHCI" -ResourceType "clusters" -Name ($cluster + "/extendSoftwareAssuranceBenefit") -ApiVersion "2023-02-01" -Payload '{"properties": { "softwareAssuranceIntent": "Disable" }}' 
 }

 #CLI

az login --tenant $tenant
az account set --subscription $subscription

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv

foreach ($cluster in $clusters)
{
    az stack-hci cluster extend-software-assurance-benefit --cluster-name $cluster -g $resourceGroup --software-assurance-intent disable
}