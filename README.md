# README

This is an ubuntu 20.04 based container using microsoft powershell wrapper for the Crowdstrike Powershell SDK PSFalcon.

Container Build of PS Module:

* https://github.com/CrowdStrike/psfalcon

## Quick Start

Non-interactive usage:
`docker run --rm -v $PWD/data:/data --workdir=/data shadowbq/psfalcon <script or powershell command to run>`

Interactive Powershell prompt (./interactive):
`docker run --rm -it -v $PWD/data:/data --workdir=/data shadowbq/psfalcon '-i'`

## Usage of PSFalcon Container

```bash
./interactive
PS /data> ./example.ps1
```

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

### Authenticating using Microsoft.PowerShell.SecretStore

This docker image has the new `Microsoft.PowerShell.SecretStore` embedded into the image for secure storage/retrieval of passwords.

Additionally you can extend `Microsoft.PowerShell.SecretStore` to support:

* [KeePass](https://www.powershellgallery.com/packages/SecretManagement.KeePass)
* [LastPass](https://www.powershellgallery.com/packages/SecretManagement.LastPass)
* [Hashicorp Vault](https://www.powershellgallery.com/packages/SecretManagement.Hashicorp.Vault.KV)
* [KeyChain](https://www.powershellgallery.com/packages/SecretManagement.KeyChain)
* [CredMan](https://www.powershellgallery.com/packages/SecretManagement.JustinGrote.CredMan)
* [Azure KeyVault](https://www.powershellgallery.com/packages/Az.KeyVault)

```powershell
PS /data> Set-Secret -Name ClientId -Secret "xxxxxxxxxxxxxxxxxxx"
Creating a new CrowdStrikeStore vault. A password is required by the current store configuration.
Enter password:
***********
Enter password again for verification:
***********

PS /data> Set-Secret -Name ClientSecret -Secret "aaaaaaaaaaaaaaaaaaaaaaaaa"

PS /data> Get-SecretVault

Name             ModuleName                       IsDefaultVault
----             ----------                       --------------
CrowdStrikeStore Microsoft.PowerShell.SecretStore True

PS /data> Get-SecretInfo

Name         Type   VaultName
----         ----   ---------
ClientId     String CrowdStrikeStore
ClientSecret String CrowdStrikeStore

PS /data> Request-FalconToken -ClientId (Get-Secret -Name ClientId -AsPlainText) -ClientSecret  (Get-Secret -Name ClientSecret -AsPlainText) -Cloud us-1
Vault CrowdStrikeStore requires a password.
Enter password: *********
PS /data> Test-FalconToken

Token Hostname                    ClientId                         MemberCid
----- --------                    --------                         ---------
 True https://api.crowdstrike.com ddddddddddddddddddddddddddddd

```

## Building & Publishing

There a few files included in repo to assist with building and publishing the docker container.

* `image.config` - simple file with configurations for building/publishing the image.
* `test.sh` - Ensure your environment is ready to build/publish the docker image.
* `build.sh` - Build the `latest` image based on `image.config`
* `release.sh` - Build the `version` based on the `image.config` and publish the image to docker.hub.
* `VERSION` - Current version of this container wrapper. (i.e. 0.0.2) The published container on docker.hub will have a paired version with psfalcon like (v1.0.8-0.0.2).
