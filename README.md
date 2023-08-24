# AzSHCI-Automation
This repository will have automation scripts that help implement configuration, compliance and governance of Azure Stack HCI Resources at-scale.

To run async commands parallely add -NoWait to Powershell Command and --no-wait to cli cmdlets. 

1. Extension Management 

- Consent for Mandatory Extensions: Done with Az CLI, Az Powershell and Invoke-Az Rest Method. Not supported for ARM Template, Bicep.
