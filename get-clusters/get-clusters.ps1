$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

 

# Using AZ POWERSHELL

 

Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

 

# Get clusters with IMDS attestation enabled

 

Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object ReportedPropertyImdsAttestation -eq "Enabled" | Select-Object Name, Id, location

 

# Get clusters in location EastUS

 

Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object location -eq "eastus" | Select-Object Name, Id

 

# Using AZ CLI

 

$login = az login --tenant $tenantId
az account set -s  $subscriptionId

 

# get clusters in location EastUS 
az stack-hci cluster list --resource-group $resourceGroup --query "[?location=='eastus'].{Name:name, Id:id}" -o table

 

# get clusters with software assurance enabled 
az stack-hci cluster list --resource-group $resourceGroup --query "[?softwareAssuranceProperties.softwareAssuranceIntent=='Enable'].{Name:name, Id:id}" -o table