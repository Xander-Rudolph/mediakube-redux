Thanks to the folks over at linuxserver.io for all these awesome images
https://docs.linuxserver.io/

# Things to know
## Networking and VPN
This cluster setup uses PIA VPN as its vpn provider and it only links to the torrent image. See the pia-vpn image for additional details about the vpn setup

The networking and routing for this cluster is managed via Traefik and the various *rr services are not exposed. The torrent agent and ombi are the only pieces that are routed at this time.

## Exposed paths
`/downloads`
`/downloads/`
`/transmission`
`/ombi/`

## Traefik Dashboard
The following block controls the traefik dashboard:
```
enableTraefikDashboard: true
creds:
  user: administrator
  password: Dashboard
```
If the dashboard is not enabled the credentials are not needed, however if the dashboard is enabled, the provided credentials will need to be passed when opening the dashboard 

## Default values
the following values are defaultsed and can be overwritten manually

`configCapacity: 10Gi`
each service will be allocated the same capacity. Divide the total config capacity by 6 (or the number of services that will be deployed)

`mediaCapacity: 15Ti`
the entire capacity for the media directory in NFS

`timezone: Etc/UTC`
Localization for specific timezones will automatically apply to all the linuxserver.io images but UTC is universal so... thats what it is ;)

`PGID: 0`
`PUID: 0`
this is the `root` user and `root` group in linux so if the NFS has security configurations, this should be set appropriately

# Example usage
The following sections will outline how to run the script

## linux/mac
NOTE: ensure that you are in the mediakube folder before execution
```
export filename=./values.yaml
# update these values to set the helm chart values file
export server=
export config=
export media=
export subdomains=
export token=
export username=
export password=
export vpn_username=
export vpn_password=

sed -i "s/YOUR_NFS_SERVER/$server/g" $filename
sed -i "s/YOUR_CONFIG_PATH/$config/g" $filename
sed -i "s/YOUR_MEDIA_PATH/$media/g" $filename
sed -i "s/YOUR_SUBDOMAINS/$subdomains/g" $filename
sed -i "s/YOUR_DNS_TOKEN/$token/g" $filename
sed -i "s/YOUR_USERNAME/$username/g" $filename
sed -i "s/YOUR_PASSWORD/$password/g" $filename
sed -i "s/YOUR_PIA_USERNAME/$vpn_username/g" $filename
sed -i "s/YOUR_PIA_PASSWORD/$vpn_password/g" $filename
helm upgrade -i mediakube .
```

## Windows (powershell)
NOTE: ensure that you are in the mediakube folder before execution
```
$filename=./values.yaml
# update these values to set the helm chart values file
$server=
$config=
$media=
$subdomains=
$token=
$username=
$password=
$vpn_username=
$vpn_password=

(Get-Content $filename).Replace('YOUR_NFS_SERVER',$server) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_CONFIG_PATH',$config) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_MEDIA_PATH',$media) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_SUBDOMAINS',$subdomains) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_DNS_TOKEN',$token) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_USERNAME',$username) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_PASSWORD',$password) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_PIA_USERNAME',$vpn_username) | Set-Content $filename
(Get-Content $filename).Replace('YOUR_PIA_PASSWORD',$vpn_password) | Set-Content $filename
helm upgrade -i mediakube .
```