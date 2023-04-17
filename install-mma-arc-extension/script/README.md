# AzSHCI-Automation
Run powershell script to install Microsoft Monitoring Agent Arc Extension for Azure Stack HCI Clusters.
You need to pre-configure log analytics workspace before running this script.
You need to pass below params:
workspaceId in workspace_mma.json
workspaceKey in workspacekey_mma.json
$subscriptionId = ""
$resourceGroup =  ""
$tenantId = ""
$settings= "path to workspace_mma.json"
$protectedSetting = "path to workspacekey_mma.json"
