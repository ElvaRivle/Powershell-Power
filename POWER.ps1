if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

[int]$nastaviti = 1

DO {
    [int]$opcija = Read-Host "0-Balanced, 1-Baterija Full performanse"

    if ($opcija -eq 0) {
        $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'Balanced'"      
        powercfg /setactive ([string]$p.InstanceID).Replace("Microsoft:PowerPlan\{","").Replace("}","") 
    }
    else {
        $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'Baterija Full performanse'"      
        powercfg /setactive ([string]$p.InstanceID).Replace("Microsoft:PowerPlan\{","").Replace("}","") 
    
    }

    $opcija = Read-Host "0-nista, 1-sleep, 2-hibernacija, 3-shutdown"

    powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 $opcija
    powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 $opcija

    powercfg -SetActive SCHEME_CURRENT

    $nastaviti = Read-Host "Nastaviti? [0,1]"

} While($nastaviti -eq 1)