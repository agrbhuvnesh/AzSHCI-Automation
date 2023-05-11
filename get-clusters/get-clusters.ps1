$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""


#Using AZ POWERSHELL

Connect-AzAccount -Tenant $tenantId
Set-AzContext

# get clusters with IMDS attestation enabled
Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object ReportedPropertyImdsAttestation -eq "Enabled" | Select-Object Name, Id, location

# get clusters in location EastUS 
Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object location -eq "eastus" | Select-Object Name, Id

#USING AZ CLI 

$login = az login --tenant $tenantId
az account set -s  $subscriptionId
