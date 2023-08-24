# AzSHCI-Automation
Run powershell script to install Azure Windows Azure Site Recovery Extension for Azure Stack HCI Clusters.
Pre-requisites:
	1. Check the pre-requisites from install-asr Readme.md 

## Update Variables in Scripts

1. Update following variables in install-asr.ps1:
$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$parametersFilePath = "" 

2. Update parameters in asr-parameters.json 
