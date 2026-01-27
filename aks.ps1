Param (
    [Parameter(Mandatory = $true)]
    [String] $rgName,

    [Parameter(Mandatory = $true)]
    [String] $aksClusterName

)

$logonAttempt = 0
$connectionResult = $null

while (-not $connectionResult -and $logonAttempt -le 10) {
    $logonAttempt++
    try {
        $connectionResult = Connect-AzAccount -Identity -ErrorAction Stop
    }
    catch {
        Start-Sleep -Seconds 30
    }
}

Set-AzContext -SubscriptionId ""

Get-AzAksCluster -Name $aksClusterName -ResourceGroupName $rgName

Stop-AzAksCluster -Name $aksClusterName -ResourceGroupName $rgName
