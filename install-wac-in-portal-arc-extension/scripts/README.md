# AzSHCI-Automation
Run powershell script to install Windows Admin Center Arc Extension for Azure Stack HCI Clusters.
The script does the below two things: 
1. Enables connectivity on the arc setting for the clusters 
2. Install the extensions 

To use the extension, user also needs "Windows Admin Center Administrator Login" Role on the HCI cluster resource 
You need to pass below params:
$subscriptionId = ""
$resourceGroup =  ""
$tenantId = ""
$settingsConfig = "config parameters for setting "
$connectivityConfig = "config parameters for connectivity"
