# AzSHCI-Automation

Terraform module to install Azure Site Recovery Arc Extension for Azure Stack HCI Clusters.

Pre-requisites:
1. [Check requisites for Azure Site Recovery](https://learn.microsoft.com/en-us/azure-stack/hci/manage/azure-site-recovery#prerequisites-and-planning)
2. [Create a Site Recovery Vault and Site](https://learn.microsoft.com/en-us/azure/backup/backup-create-recovery-services-vault)
3. [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli#install)
4. [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


Configure the values in variables.tfvars:

1. clusterResourceIds: Array of the clusters to install ASR extension on
2. azStackHCIApiVersion: Azure Stack HCI Cluster api version to be used with azapi_resource
3. recoverySiteId: Site Id for the recovery vault 
4. recoverySiteName: Name of the site id for the recovery vault
5. recoveryServicesVaultName: Vault name for recovery services 
6. recoveryServicesVaultResourceGroup: Resource group where the recovery vault is present
7. recoveryServicesVaultLocation: Private endpoint state for site recovery. Allowed values: None, Pending, Approved, Rejected, Disconnected, Timeout, Ready, or Unknown.


To run the Terraform module use the following commands from the Terraform directory:

```
terraform init
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```