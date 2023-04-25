# mediakube-redux
If you are using this repo, there are a few things to note. Other than the VPN image, all images are public so tickets/bugs should be raised accordingly

## Pre-requisites
- Some flavor of kubernetes (microk8s, rancher desktop, docker desktop, etc)
- Appropriate configuration of ~/.kube/config to hit the cluster
- Kubectl and helm commands should be mapped appropriately (EX alias `microk8s kubectl` to `kubectl`)
- (optional) 2 NFS share paths
    - media
    - config

## How to use this repo
Depending on the platform, either a bash or powershell script is recommended. The default values files does not have real values but instead a list of variables that need to be subbed in. This is an example in powershell but something simliar will work in bash:

```
pushd $PSScriptRoot # this should be the charts/mediakube directory so make sure to put this script there
$filename="./values.yaml"
# update these values to set the helm chart values file
# nfs
$server= ""
$config= ""
$localPath= ""
$media= ""

# postgres root
$pg_password= ""

# duckdns
$subdomains= ""
$token= ""

# transmission
$username= ""
$password= ""

# transmission.vpn
$vpn_username= ""
$vpn_password= ""

# requestrr
$discordAppId= ""
$discordBotToken= ""

(Get-Content $filename).Replace('YOUR_NFS_SERVER',$server) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_CONFIG_PATH',$config) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_LOCAL_STORAGE',$localPath) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_MEDIA_PATH',$media) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_SUBDOMAINS',$subdomains) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_DNS_TOKEN',$token) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_USERNAME',$username) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_PASSWORD',$password) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_PIA_USERNAME',$vpn_username) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_PIA_PASSWORD',$vpn_password) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_POSTGRES_PASSWORD',$pg_password) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_DISCORD_APPID',$discordAppId) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_DISCORD_BOTTOKEN',$discordBotToken) | Set-Content $filename
if(-not (test-path Chart.lock))
{
    helm dependency build
}
helm upgrade -i mediakube .
popd
```

Also... powershell is really easy to install.
Mac:

`brew install powershell`

Linux:

`snap install powershell`

Then run the command `pwsh` to start a powershell session.


## How to test the VPN
After spooling the VPN you can use to confirm net routing on each container using the following:

`curl checkip.amazonaws.com`