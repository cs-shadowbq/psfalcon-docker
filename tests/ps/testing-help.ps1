<#
PS /tmp> $TestModules = @("PSFalcon")
PS /tmp> Import-Module $TestModules
PS /tmp> $BorkedHelp = Get-Module $TestModules | select Name, Version, HelpInfoUri
PS /tmp> $BorkedHelp

Name     Version HelpInfoUri
----     ------- -----------
PSFalcon 2.1.1   https://bk-cs.github.io/help/psfalcon/en-US/

PS /tmp> foreach ($uri in $BorkedHelp.helpinfouri) {Invoke-WebRequest $uri}
StatusCode        : 200
StatusDescription : OK
Content           : <!doctype html>
                    <title>help/psfalcon/en-US/</title>

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Server: GitHub.com
                    permissions-policy: interest-cohort=()
                    Strict-Transport-Security: max-age=31556952
                    Access-Control-Allow-Origin: *
                    ETag: "61269e4e-34"
                    Cache-Co…
Headers           : {[Connection, System.String[]], [Server, System.String[]], [permissions-policy, System.String[]],
                    [Strict-Transport-Security, System.String[]]…}
Images            : {}
InputFields       : {}
Links             : {}
RawContentLength  : 52
RelationLink      : {}
#>

$TestModules = @("PSFalcon")
Import-Module $TestModules
$BorkedHelp = Get-Module $TestModules | select Name, Version, HelpInfoUri
$BorkedHelp
foreach ($uri in $BorkedHelp.helpinfouri) {Invoke-WebRequest $uri}