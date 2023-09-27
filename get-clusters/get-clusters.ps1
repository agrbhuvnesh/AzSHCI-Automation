$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$location = "eastus" 
$IMDSStatus = "Enabled"
$softwareStatus = "Enabled"

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

# Get clusters with IMDS attestation specified
"Get clusters with IMDS attestation $IMDSStatus"
Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object ReportedPropertyImdsAttestation -eq $IMDSStatus | Select-Object Name, Id, location

# Get clusters in location specified
"Get clusters in location $location"
Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object location -eq $location | Select-Object Name, Id
