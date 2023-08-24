# AzSHCI-Automation

Run PowerShell scripts to manage deletion of  Arc Extensions for Azure Stack HCI Clusters.

The script allows you to delete Arc Extensions using either Azure CLI or PowerShell.

### Prerequisites

Make sure you have the following parameters ready:

- `$subscriptionId`: Your Azure subscription ID.
- `$resourceGroup`: Name of the Azure resource group.
- `$tenantId`: Azure AD tenant ID.

### Using Azure CLI

1. Log in to your Azure subscription.
2. Run the script.
3. Choose either to delete all extensions for a specific cluster or a particular extension across all clusters.
### Using PowerShell

1. Log in to your Azure subscription.
2. Run the script.
3. Choose either to delete all extensions for a specific cluster or a particular extension across all clusters.


Note: delete call will fail for mandatory extensions