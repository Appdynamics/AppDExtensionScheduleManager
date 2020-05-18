# Start and stop AppDynamics extensions 

This script accepts to args: 

  *action* - which could be either `disable` or `enable`.  Disable will disable the extension and enable wiill, well, enable the extension. 

  *restartMA* - which can be either `yes` or `no`. The Machine Agent must be restarted before the changes take effect. 

  *Setup Instructions*

1. Define the extension path. Edit the script by specifying the path:  

  `$ExtensionPath = "C:\Program Files\AppDynamics\MachineAgent\monitors\analytics-agent"`

2. Run it Manually : 

  Enabled an extension and restart the Machine Agent 

  `.\AppDExtensionScheduleManager.ps1 -action disable -restartMA yes`

  Disable the extension and restart the Machiine Agent Service manaually. 

  `.\AppDExtensionScheduleManager.ps1 -action disable -restartMA no`

3. Confirm that it works by expecting the value <enable> flag in `$ExtensionPath\monitor.xml` and the last restart time of the Machine Agent Service

4. Run from Windows Task scheduler - for both enable and disable respectively. 
