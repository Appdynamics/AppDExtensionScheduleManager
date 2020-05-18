 
[cmdletbinding()]
Param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("enable", "disable")]
    [string]$action,

    [Parameter(Mandatory = $true)]
    [ValidateSet("yes", "no")]
    [string]$restartMA

)

$action = $action.trim()
$restartMA = $restartMA.trim()

if ($action -eq "enable") {
    $actionValue = "true"
}
else {
    $actionValue = "false"
}

Write-Host "Action Value is $actionValue"

$ExtensionPath = "C:\Program Files\AppDynamics\MachineAgent\monitors\analytics-agent"

$monitorXML = "$ExtensionPath\monitor.xml"

$regex = "<enabled>(?:tru|fals)e.*>$"
$replace = "<enabled>$actionValue</enabled>"

(Get-Content $monitorXML) | ForEach-Object { $_ -replace "$regex" , "$replace" } | Set-Content $monitorXML

if ($restartMA -eq "yes") {

    $MAServiceName =  Get-Service -Name "Appdynamics Machine*"
    Write-Host "Restarting AppDynamics Machine Agent for this change to take effect"
    Restart-Service $MAServiceName -Force
    
    Write-Host "Current MA Status"
    Get-Service -Name "Appdynamics Machine*" 

    #Write-Host "MA Service Status"
    #Get-Service -Name "Appdynamics Machine*"
    
}
else {
    Write-Host "You must restart the MA before this change takes effects"

}


