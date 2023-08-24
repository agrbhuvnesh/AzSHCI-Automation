# AzSHCI-Automation
This repository will have automation scripts that help implement configuration, compliance and governance of Azure Stack HCI Resources at-scale.

To run async commands parallely add -NoWait to Powershell Command and --no-wait to cli cmdlets. 

1. Extension Management 

- Consent for Mandatory Extensions: Done with Az CLI, Az Powershell and Invoke-Az Rest Method. Not supported for ARM Template, Bicep.
- Extension Installation 
    - MMA: supported with scripts, templates. Retired, migrate to AMA. 
    - AMA: enabling insights along with installing extension. Supported. 
    - WAC: Supported. Facing some issues with CLI. 
    - ASR: Extension Installation supported. Support for preparing infrastructure (Vault, Site etc) will be coming soon. 
- Delete: Supported 
- Upgrade: Supported through Invoke-AzRestMethod. Support will be updated soon. 


2. Cluster Management 
- Get/Delete clusters: supported 
- Updating WSS, Diagnostic, Hybrid Benefits: Supported 
