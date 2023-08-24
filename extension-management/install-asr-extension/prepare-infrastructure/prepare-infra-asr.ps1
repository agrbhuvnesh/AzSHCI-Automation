
##[Work in Progress: Not to be published]
$vault = New-AzRecoveryServicesVault -Name "a2aDemoRecoveryVault" -ResourceGroupName "a2ademorecoveryrg" -Location "West US 2"

Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$sitename = "MySite"                #Specify site friendly name
New-AzRecoveryServicesAsrFabric -Type HyperVSite -Name $sitename

# verify that above job gets completed successfully before moving forward 

$ReplicationFrequencyInSeconds = "300";        #options are 30,300,900
$PolicyName = “replicapolicy”
$Recoverypoints = 6                    #specify the number of recovery points
$storageaccountID = Get-AzStorageAccount -Name "mystorea" -ResourceGroupName "MyRG" | Select-Object -ExpandProperty Id

$PolicyResult = New-AzRecoveryServicesAsrPolicy -Name $PolicyName -ReplicationProvider “HyperVReplicaAzure” -ReplicationFrequencyInSeconds $ReplicationFrequencyInSeconds -NumberOfRecoveryPointsToRetain $Recoverypoints -ApplicationConsistentSnapshotFrequencyInHours 1 -RecoveryAzureStorageAccountId $storageaccountID