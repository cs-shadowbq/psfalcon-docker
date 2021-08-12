# README

This is an ubuntu based microsoft powershell wrapper for the 

## Quick Start

Non-interactive usage:
`docker run --rm -v $PWD/data:/data --workdir=/data shadowbq/powershell-crowdstrike <script or powershell command to run>`

Interactive Powershell prompt:
`docker run --rm -it -v $PWD/data:/data --workdir=/data shadowbq/powershell-crowdstrike '-i'`

## Usage of PSFalcon

### Validation of loading / Importing the PSFalcon Module

```powershell
PS /> Get-Module -ListAvailable

    Directory: /root/.local/share/powershell/Modules

ModuleType Version    PreRelease Name                                PSEdition ExportedCommands
---------- -------    ---------- ----                                --------- ----------------
Script     2.0.8                 PSFalcon                            Core,Desk {Confirm-FalconDiscoverAwsAccess, Edit-FalconDiscoverAwsAccount, Get-FalconDiscoverAwsAccount, G…

    Directory: /opt/microsoft/powershell/7/Modules

ModuleType Version    PreRelease Name                                PSEdition ExportedCommands
---------- -------    ---------- ----                                --------- ----------------
Manifest   1.2.5                 Microsoft.PowerShell.Archive        Desk      {Compress-Archive, Expand-Archive}
Manifest   7.0.0.0               Microsoft.PowerShell.Host           Core      {Start-Transcript, Stop-Transcript}
Manifest   7.0.0.0               Microsoft.PowerShell.Management     Core      {Add-Content, Clear-Content, Clear-ItemProperty, Join-Path…}
Manifest   7.0.0.0               Microsoft.PowerShell.Security       Core      {Get-Credential, Get-ExecutionPolicy, Set-ExecutionPolicy, ConvertFrom-SecureString…}
Manifest   7.0.0.0               Microsoft.PowerShell.Utility        Core      {Export-Alias, Get-Alias, Import-Alias, New-Alias…}
Script     1.4.7                 PackageManagement                   Desk      {Find-Package, Get-Package, Get-PackageProvider, Get-PackageSource…}
Script     2.2.5                 PowerShellGet                       Desk      {Find-Command, Find-DSCResource, Find-Module, Find-RoleCapability…}
Script     2.0.5                 PSDesiredStateConfiguration         Core      {Configuration, New-DscChecksum, Get-DscResource, Invoke-DscResource}
Script     2.1.0                 PSReadLine                          Desk      {Get-PSReadLineKeyHandler, Set-PSReadLineKeyHandler, Remove-PSReadLineKeyHandler, Get-PSReadLine…
Binary     2.0.3                 ThreadJob                           Desk      Start-ThreadJob

PS /> Import-Module -Name PSFalcon

PS /> Get-Command -Module PSFalcon

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-FalconCIDGroupMember                           2.0.8      PSFalcon
Function        Add-FalconGroupRole                                2.0.8      PSFalcon
[...]

PS /> Test-FalconToken

Token Hostname ClientId MemberCid
----- -------- -------- ---------
False
```

### Authenticating and Connecting to the Falcon Platform.

```powershell
PS /> Request-FalconToken -ClientId bbbbbbbbbbbbbbbbbbb -ClientSecret cccccccccccccccccc -Cloud us-1

PS /> Test-FalconToken

Token Hostname                    ClientId                         MemberCid
----- --------                    --------                         ---------
 True https://api.crowdstrike.com bbbbbbbbbbbbbbbbbbb

PS /> Get-FalconCCID
AAAAAAAAAAAAAAAAAAAAAAAAAA-49
```