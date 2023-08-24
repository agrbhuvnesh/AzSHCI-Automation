# AzSHCI-Automation
Run powershell script to install Azure Windows Monitoring Agent Arc Extension for Azure Stack HCI Clusters and configure insights. 
Pre-requisites:
	1. Create Workspace 'microsoft.operationalinsights/workspaces' manually before running script.
	2. Install-module az stack-cli using link https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows

Update Variables in Scripts:
	1. Update DCRAssociation.json for below properties:
		"name": "",
		"workspaceId": "",
		"workspaceResourceId": "" 
		destinations: ""  <use the same workspace name as given as step1>

	2. update 4 variables in install_ama_extn
		$subscriptionId = "test-subscription"
		$resourceGroup = "test-rg"
		$DCRFilePath = "DCRAssociation.json" #File Path to DCR json file
		$tenantId = ""