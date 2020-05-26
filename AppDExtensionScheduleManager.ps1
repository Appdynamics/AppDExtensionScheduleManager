 
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

$ExtensionPath = "C:\Program Files\AppDynamics\MachineAgent\monitors\LogMonitor"

$monitorXML = "$ExtensionPath\monitor.xml"
Write-Host "Monitor.XML Path: $monitorXML"
$regexMon = "<enabled>(?:tru|fals)e.*>$"
$replaceMon = "<enabled>$actionValue</enabled>"
(Get-Content $monitorXML) | ForEach-Object { $_ -replace "$regexMon" , "$replaceMon" } | Set-Content $monitorXML

##### This section is only specific to the modified LogEmailSnapshotMonitoring extension ###########
###### It will not work for other extensions. ###########

$configYAML = "$ExtensionPath\config.yml"
Write-Host "Config.YAML Path: $configYAML"
$regexConf = "LogSnapshots:.*(tru|fals)e$"
$replaceConf = "LogSnapshots: $actionValue"
(Get-Content $configYAML) | ForEach-Object { $_ -replace "$regexConf" , "$regexConf" } | Set-Content $configYAML

##########end LogEmailSnapshotMonitoring###########

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


