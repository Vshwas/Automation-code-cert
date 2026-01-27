Param (
    [Parameter(Mandatory = $true)]
    [String] $rgName,

    [Parameter(Mandatory = $true)]
    [String] $aksClusterName,

    [Parameter(Mandatory = $true)]
    [String] $subscriptionId
)

# -------------------------------
# Login using Managed Identity
# -------------------------------
$logonAttempt = 0
while (!($connectionResult) -and ($logonAttempt -le 10)) {
    $logonAttempt++
    $connectionResult = Connect-AzAccount -Identity
    Start-Sleep -Seconds 30
}

Set-AzContext -SubscriptionId $subscriptionId

# -------------------------------
# Get current time in IST
# -------------------------------
$istZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("India Standard Time")
$currentIST = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $istZone)

$currentHour   = $currentIST.Hour
$currentMinute = $currentIST.Minute
$currentDay    = $currentIST.DayOfWeek

Write-Output "Current IST Time: $currentIST"
Write-Output "Day of Week (IST): $currentDay"

# -------------------------------
# Weekend skip logic
# -------------------------------
if ($currentDay -eq "Saturday" -or $currentDay -eq "Sunday") {
    Write-Output "Weekend detected (Saturday/Sunday). Skipping AKS start/stop."
    return
}

# -------------------------------
# Get AKS status
# -------------------------------
$aks = Get-AzAksCluster -ResourceGroupName $rgName -Name $aksClusterName
$powerState = $aks.PowerState.Code

Write-Output "Current AKS Power State: $powerState"

# -------------------------------
# START AKS at 09:00 AM IST
# -------------------------------
if ($currentHour -eq 9 -and $currentMinute -lt 15 -and $powerState -ne "Running") {
    Write-Output "Starting AKS cluster..."
    Start-AzAksCluster -ResourceGroupName $rgName -Name $aksClusterName
}

# -------------------------------
# STOP AKS at 07:00 PM IST
# -------------------------------
elseif ($currentHour -eq 19 -and $currentMinute -lt 15 -and $powerState -eq "Running") {
    Write-Output "Stopping AKS cluster..."
    Stop-AzAksCluster -ResourceGroupName $rgName -Name $aksClusterName
}
else {
    Write-Output "No action required at this time."
}
