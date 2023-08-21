# AzSHCI-Automation
This repository will have automation scripts that help implement configuration, compliance and governance of Azure Stack HCI Resources at-scale.

1. Extension Management 

- Consent for Mandatory Extensions: Done with Az CLI, Az Powershell and Invoke-Az Rest Method. Not supported for ARM Template, Bicep.
- Installation (AMA, MMA, WAC, ASR): Done with Az CLI, Az Powershell, ARM Template and Bicep, Terraform (AzAPI). Please note: AMA and ASR are only supportedfor clusters with managed identitiy enabled, validation will fail for other clusters. 