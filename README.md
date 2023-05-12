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
pushd (Join-path $PSScriptRoot "/charts/mediakube/")
$filename="values.yaml"
# update these values to set the helm chart values file
# nfs
$server= "10.0.0.10" # IP/hostname for NFS server
$config= "/your/nfs/configpath"
# $localPath= "/mnt/host/c/kubestore" # docker desktop
$localPath= "/mnt/c/kubestore" # rancher desktop
$media= "/your/nfs/mediapath"

# postgres root
$pg_password= ""

# redos root
$redis_password= ""

# duckdns
$subdomains= ""
$token= ""

# swag
$url= ""

#authelia
$authdbuser="authelia"
$authdbname="authelia"
$authdbpass=""
$autheliaKey="" # random 20 digit string

# bazarr
$bazarrdbpass=""

# radarr
$radarrdbpass=""

# transmission
$username=""
$password=""
$vpn_username= ""
$vpn_password= ""
$vpn_LOC= "London" # EX https://serverlist.piaservers.net/vpninfo/servers/v6

$content = Get-Content $filename
$content.Replace('YOUR_NFS_SERVER',$server)
$content.Replace('YOUR_CONFIG_PATH',$config) 
$content.Replace('YOUR_LOCAL_STORAGE',$localPath) 
$content.Replace('YOUR_MEDIA_PATH',$media) 
$content.Replace('YOUR_SUBDOMAINS',$subdomains)
$content.Replace('YOUR_DNS_TOKEN',$token) 
$content.Replace('YOUR_USERNAME',$username) 
$content.Replace('YOUR_PASSWORD',$password)
$content.Replace('yourdomain.url',$url)
$content.Replace('YOUR_VPN_USERNAME',$vpn_username)
$content.Replace('YOUR_VPN_PASSWORD',$vpn_password)
$content.Replace('YOUR_VPN_REGION',$vpn_LOC)
$content.Replace('YOUR_POSTGRES_PASSWORD',$pg_password)
$content.Replace('YOUR_REDIS_PASSWORD',$redis_password)
$content.Replace('YOUR_SONARR_KEY',$sonarrKey)
$content.Replace('YOUR_RADARR_KEY',$radarrKey)
$content.Replace('YOUR_AUTHELIA_DBUSERNAME',$authdbuser)
$content.Replace('YOUR_AUTHELIA_DBNAME',$authdbname)
$content.Replace('YOUR_AUTHELIA_DBPASSWORD',$authdbpass)
$content.Replace('YOUR_ENCRYPTION_KEY',$autheliaKey)
$content.Replace('YOUR_BAZARR_DBPASS',$bazarrdbpass)
$content.Replace('YOUR_RADARR_DBPASS',$radarrdbpass)

$content | Set-Content $filename
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
After spooling the cluster, to test the VPN, use the following:

`kubectl exec -it service/transmission -- curl checkip.amazonaws.com`

Additionally you can check by going to `localhost/downloads/` and then use a magnet link from here:
https://ipleak.net/