$EventLogNames = @()
$EventLogNames += 'microsoft-windows-sddc-management/operational'
$EventLogNames += 'microsoft-windows-health/operational'
$ResourceGroupName   = ""
$WorkspaceName       = ""

$Count = 0
foreach ($EventLogName in $EventLogNames) {
    $Count++
    $null = New-AzOperationalInsightsWindowsEventDataSource `
        -ResourceGroupName $ResourceGroupName `
        -WorkspaceName $WorkspaceName `
        -Name "Windows-event-$($Count)" `
        -EventLogName $EventLogName `
        -CollectErrors `
        -CollectWarnings `
        -CollectInformation
}

New-AzOperationalInsightsWindowsPerformanceCounterDataSource `
    -ResourceGroupName $ResourceGroupName `
    -WorkspaceName $WorkspaceName `
    -Name performance1 `
    -ObjectName "Memory" `
    -CounterName "Available Bytes" `
    -InstanceName "*"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource `
    -ResourceGroupName $ResourceGroupName `
    -WorkspaceName $WorkspaceName `
    -Name performance2 `
    -ObjectName "Network Interface" `
    -CounterName "Bytes Total/sec" `
    -InstanceName "*"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource `
    -ResourceGroupName $ResourceGroupName `
    -WorkspaceName $WorkspaceName `
    -Name performance3 `
    -ObjectName "Processor" `
    -CounterName "% Processor Time" `
    -InstanceName "_Total"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource `
    -ResourceGroupName $ResourceGroupName `
    -WorkspaceName $WorkspaceName `
    -Name performance4 `
    -ObjectName "RDMA Activity" `
    -CounterName "RDMA Inbound Bytes/sec" `
    -InstanceName "*"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource `
    -ResourceGroupName $ResourceGroupName `
    -WorkspaceName $WorkspaceName `
    -Name performance5 `
    -ObjectName "RDMA Activity" `
    -CounterName "RDMA Outbound Bytes/sec" `
    -InstanceName "*"