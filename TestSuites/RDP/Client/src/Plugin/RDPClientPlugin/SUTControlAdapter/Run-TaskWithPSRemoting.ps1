# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# This script is used to run a scheduled job on remote machine
# Return Value: 0 indicates task is started successfully; -1 indicates failed to run the specified task

Param(
[string]$computer, # host name or ip address
[string]$taskName,
[string]$userName
)

# Run Task to start RDP connection remotely
$cmdOutput = Invoke-Command -HostName $computer -UserName $userName -ScriptBlock {param([string]$taskName) cmd /c schtasks /run /TN $taskName} -ArgumentList $taskName

$cmdOutput | out-file "./RunTask_$taskName.log"

if($cmdOutput -ne $null)
{
    if($cmdOutput.GetType().IsArray)
    {
        $cmdOutput = $cmdOutput[0]
    }
    if($cmdOutput.ToUpper().Contains("ERROR"))
    {
        return -1 # operation failed
    }
}

return 0  #operation succeed
