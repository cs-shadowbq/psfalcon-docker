# Proxy

Proxy Configurations - Explicit Proxy configurations are difficult to get PSM modules to abide by historically in *Server.Core* or *Linux Powershell*. Running PowerShell from base linux container images lack the *Windows Registry Hive*, `netsh`, and *IE system proxy* capabilities. Many PowerShell modules ignore the `[System.Net.WebRequest]::DefaultWebProxy` directive.

***You must use the directive:  `[System.Net.Http.HttpClient]::DefaultProxy`.***

* Reference: <https://stackoverflow.com/a/67588302>

## MITM Proxy

Running `mitmproxy` using the official Docker image is as simple as executing the following command :

`docker run --rm -it -name mitmproxy -v $PWD/.mitmproxy:/home/mitmproxy/.mitmproxy -p 8080:8080 mitmproxy/mitmproxy:7.0.2`

### Enabling the MITMProxy WebUI

This makes `*:8081` accessible to the local machine running docker:

`docker run --rm -it -name mitmproxy -v $PWD/.mitmproxy:/home/mitmproxy/.mitmproxy -p 8080:8080 -p 127.0.0.1:8081:8081 mitmproxy/mitmproxy mitmweb --web-host 0.0.0.0`

![MITM-PROXY](mitm-in-action.png)

### Optional: Key logging is enabled by setting the environment variable SSLKEYLOGFILE so that it points to a writable text file:

Ref: <https://wiki.wireshark.org/TLS?action=show&redirect=SSL#Using_the_.28Pre.29-Master-Secret>

`SSLKEYLOGFILE="$PWD/.mitmproxy/sslkeylogfile.txt" mitmproxy`

## Creating the *PSFalcon Proxy Variant*

The mitmproxy should be running prior to building the PSFalcon Proxy variant.

* You need the CERT file in the Proxy PSFalcon Variant that is created by mitmproxy for the SSL Trust.
* You need the IP Address for the Proxy in the `Powershell_profile.ps1`.

### Get the IP Address of the Running MITM-Proxy

Use `docker inspect` to fetch the IP-Address.

```bash
$> docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS              PORTS                                                                 NAMES
cf6ed97ef80e   mitmproxy/mitmproxy        "docker-entrypoint.s…"   1 hour ago           Up 1 hour         0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 127.0.0.1:8081->8081/tcp   mitmproxy
e1f3b4269096   shadowbq/psfalcon:proxy    "pwsh -i"                19 hours ago         Up 19 hours                                                                             psfalcon

$> docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mitmproxy
172.17.0.2
$> docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' psfalcon
172.17.0.3
```

### Configure the PowerShell Profile

The environment variables used for DefaultProxy initialization on Windows and Unix-based platforms are:

`HTTP_PROXY`: the proxy server used on HTTP requests.
`HTTPS_PROXY`: the proxy server used on HTTPS requests.
`ALL_PROXY`: the proxy server used on HTTP and/or HTTPS requests in case HTTP_PROXY and/or HTTPS_PROXY are not defined.
`NO_PROXY`: a comma-separated list of hostnames that should be excluded from proxying.

Change the `proxy\Microsoft.PowerShell_profile.ps1.template` to reflect the correct IP Address of the Proxy.

### Build the *PSFalcon Proxy Variant* 

`docker build . --file "./Dockerfile.proxy" -t shadowbq/psfalcon:proxy`

### Run the Container

`$> ./interactive proxy`

## General Proxy Information: Using PowerShell Behind a Proxy Server

```powershell
$ALL_PROXY = "http://username:password@proxy.thing.com:8080"
[System.Net.Http.HttpClient]::DefaultProxy = New-Object System.Net.WebProxy($ALL_PROXY)
```

```powershell
update-help -verbose -force psfalcon
```

### Legacy PowerShell (with WebRequest)

These examples of `WebClient`, `Invoke-WebRequest` do work with explicit settings, but `udpate-help`, `save-help`, and other Modules `PSFalcon` are *not using any of these settings*.
`[System.Net.WebRequest]::DefaultWebProxy` directive is required. This is an example of setting up a `System.Net.WebProxy` with Credentials if needed.

Method 1:

```powershell
[system.net.webrequest]::defaultwebproxy = new-object system.net.webproxy('http://x.x.x.x:80')
[system.net.webrequest]::defaultwebproxy.credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
[system.net.webrequest]::defaultwebproxy.BypassProxyOnLocal = $true
```

Method 2:

```powershell
$proxy = New-Object System.Net.WebProxy
$proxy.Address = [uri]"http://yourproxy:3128"
$password="xxxxx"
# $Creds=Get-Credential
$proxy.Credentials = New-Object System.Net.NetworkCredential("Username",$password)
[System.Net.WebRequest]::DefaultWebProxy = $proxy
```

Invoke WCL Command:

Method 1:

```powershell
Invoke-WebRequest -Uri "https://crowdstrike.com" | Select RawContent
```

Method 2:

```powershell
$url = "https://www.crowdstrike.com/"
$Wcl = new-object System.Net.WebClient
$Wcl.Headers.Add(“user-agent”, “PowerShell Script”)
$Wcl.proxy
$Wcl.Downloadstring($url) | Select RawContent
```
