# Things to know
Thanks to the folks over at linuxserver.io for all these awesome images
https://docs.linuxserver.io/

## Networking and VPN
This cluster setup uses PIA VPN as its vpn provider and it only links to the torrent image. Currently the VPN sidecar is disabled until [#20](https://github.com/Xander-Rudolph/mediakube-redux/issues/20) is resolved.

The networking and routing for this cluster is managed via Traefik and the various *arr services are exposed. 

## Exposed paths
`/dashboard`
`/dashboard/`
`/downloads`
`/downloads/`
`/transmission`
`/ombi`
`/sonarr`
`/radarr`
`/lidarr`
`/readarr`
`/prowlarr`
`/requestrr`

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

`postgresUser: "postgres"`
this is the default user for the postgres pod

`postgresPassword: "YOUR_POSTGRES_PASSWORD"`
this needs to be update unless you want YOUR_POSTGRES_PASSWORD as a password

`radarrMainDb: radarrmain`
`radarrLogDb: radarrlog`
These two the names of the postgres dbs for radarr.. changing this might break stuff so search for the strings radarrmain, radarrlog before modifying it.