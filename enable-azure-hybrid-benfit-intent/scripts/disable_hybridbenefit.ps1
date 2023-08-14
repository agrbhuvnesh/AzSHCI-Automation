$subscription = ""
$resourceGroup = ""
$tenant = ""


 

# Powershell

 

Connect-AzAccount

 

Set-AzContext -Subscription $subscription
$clusters = (Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters").Name

 

Foreach ($cluster in $Clusters) {
    Start-Job -ScriptBlock {
        "Disabling Azure Hybrid Benefit for cluster $using:cluster"
        Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit -ClusterName $using:cluster -ResourceGroupName $using:resourceGroup -SoftwareAssuranceIntent "Disable"
    }
}

 

 

# CLI

 

az login --tenant $tenant
az account set --subscription $subscription

 

$clusters = az resource list --resource-group $resourceGroup --resource-type "Microsoft.AzureStackHCI/clusters" --query "[].name" -o tsv

 

foreach ($cluster in $clusters)
{
    az stack-hci cluster extend-software-assurance-benefit --cluster-name $cluster -g $resourceGroup --software-assurance-intent disable
}