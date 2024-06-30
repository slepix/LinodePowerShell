# Linode PowerShell Module

![Linode](https://assets.linode.com/akamai-logo.svg)

## Important: This module is still under active development and not all features are YET available.

Unofficial PowerShell module for managing Linode resources using the Linode API.<br>
This module will work on both Windows and Linux operating systems. 

### Development status:

Percent complete: **44.56%**<br>
Total commands: 368<br>
Implemented commands: 164


### Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Commands](#commands)
- [Contributing](#contributing)
- [Cool stuff / Quality of life improvements :)](#coolstuff)
- [Development](#development)


### Installation

To install the Linode PowerShell module, you need to clone this repository, position yourself into the module folder and import the module:

```powershell
git clone git clone https://github.com/slepix/LinodePowerShell.git
cd LinodePowershell
```
### Usage

Before you can use the module, you need to import it using the following command:

```powershell
Import-Module -Name LinodePSModule
```
After the module has been imported, you need to configure it and add your Linode account. 

### Configuration

Configuration is really simple, all you need to do is run **'Connect-LinodeAccount'** command and follow the configuration wizard. <br><br>
You can run this command for each Linode account you want to add.<br>
Check in the examples how you can switch between different Linode accounts. 


```powershell
Connect-LinodeAccount
```
>***NOTE:***<br>
>You will need Linode API token with the READ/WRITE permissions for all resources in order to get the full functionality of this module. <br>
However, you are free to limit the scope of the API token to suit your security and usage requirements.


### Commands

List of currently available commands can be viewed by running this command

```powershell
(Get-Module LinodePSModule).ExportedCommands
```
### Example commands
List all currently configured profiles
```powershell
PS C:\> Get-LinodeProviderProfiles # returns a list of all currently configured profiles
development
test
```
Switch to a profile named "test"
```powershell
PS C:\> Set-LinodeProviderProfile -profile test
Profile test loaded
```
Get a list of all regions, but only return label, id and status of each region
```powershell
PS C:\> Get-LinodeRegions | Select label, id, status

label           id           status
-----           --           ------
Mumbai, IN      ap-west      ok
Toronto, CA     ca-central   ok
Sydney, AU      ap-southeast ok
Washington, DC  us-iad       ok
Chicago, IL     us-ord       ok
Paris, FR       fr-par       ok
Seattle, WA     us-sea       ok
Sao Paulo, BR   br-gru       ok
Amsterdam, NL   nl-ams       ok
Stockholm, SE   se-sto       ok
Madrid, ES      es-mad       ok
Chennai, IN     in-maa       ok
Osaka, JP       jp-osa       ok
Milan, IT       it-mil       ok
Miami, FL       us-mia       ok
Jakarta, ID     id-cgk       ok
Los Angeles, CA us-lax       ok
Dallas, TX      us-central   ok
Fremont, CA     us-west      ok
Atlanta, GA     us-southeast ok
Newark, NJ      us-east      ok
London, UK      eu-west      ok
Singapore, SG   ap-south     ok
Frankfurt, DE   eu-central   ok
Tokyo, JP       ap-northeast ok
```
Returns all properties of a single region
```powershell
PS C:\> Get-LinodeRegion -region nl-ams # list only nl-ams region

id                     : nl-ams
label                  : Amsterdam, NL
country                : nl
capabilities           : {Linodes, Backups, NodeBalancers, Block Storage...}
status                 : ok
resolvers              : @{ipv4=172.233.33.36, 172.233.33.38, 172.233.33.35, 172.233.33.39, 172.233.33.34, 172.233.33.33, 172.233.33.31, 172.233.33.30, 172.233.33.37, 172.233.33.32;
                         ipv6=2600:3c0e::f03c:93ff:fe9d:2d10, 2600:3c0e::f03c:93ff:fe9d:2d89, 2600:3c0e::f03c:93ff:fe9d:2d79, 2600:3c0e::f03c:93ff:fe9d:2d96, 2600:3c0e::f03c:93ff:fe9d:2da5,     
                         2600:3c0e::f03c:93ff:fe9d:2d34, 2600:3c0e::f03c:93ff:fe9d:2d68, 2600:3c0e::f03c:93ff:fe9d:2d17, 2600:3c0e::f03c:93ff:fe9d:2d45, 2600:3c0e::f03c:93ff:fe9d:2d5c}
placement_group_limits : @{maximum_pgs_per_customer=100; maximum_linodes_per_pg=5}
site_type              : core
```
Create a new Linode named "myInstance" with the instance type of "g6-nanode-1" in nl-ams region and a randomly generated password 25 characters long running Debian 11
```powershell
PS C:\> New-LinodeInstance -label myInstance -region nl-ams -type g6-nanode-1 -image linode/debian11 -generatepassword -passwordlength 25 # creates a Nanode instance in nl-ams region with randomly generated root password


id               : 60827598
label            : myInstance
group            :
status           : provisioning
created          : 2024-06-30T01:23:46
updated          : 2024-06-30T01:23:46
type             : g6-nanode-1
ipv4             : {172.233.40.46}
ipv6             : 2600:3c0e::f03c:94ff:fe85:29cf/128
image            : linode/debian11
region           : nl-ams
specs            : @{disk=25600; memory=1024; vcpus=1; gpus=0; transfer=1000}
alerts           : @{cpu=90; network_in=10; network_out=10; transfer_quota=80; io=10000}
backups          : @{enabled=False; available=False; schedule=; last_successful=}
hypervisor       : kvm
watchdog_enabled : True
tags             : {}
host_uuid        : 5f337dda11805445fc391c91e6dcbf45c2a38a21
has_user_data    : False
placement_group  :
lke_cluster_id   :
root_password    : eJbd\OQC9ypSagfvTSG@XREV4
```
Delete a Linode instance
```powershell
PS C:\> Remove-LinodeInstance -label myInstance -confirm # Deletes a Linode instance
Instance 60827598 deleted
```
Even though the commandlet will ask you for parameters, you can also use ***'Get-Help'*** commandlet in order to find out which parametes each command requires.

Example:

```powershell
PS /> Get-Help New-LinodeVPC

NAME
    New-LinodeVPC

SYNTAX
    New-LinodeVPC [[-description] <string>] [[-apiVersion] <string>] [[-label] <string>] [[-token] <string>] [[-region] <string>] [[-subnetlabel] <string>] [[-iprange] <string>] [<CommonParameters>]

ALIASES
    None

REMARKS
    None
```

### Contributing

To report a bug or request a feature in Linode Powershell Module, please open a [GitHub Issue](https://github.com/slepix/LinodePowerShell/issues).

### Cool stuff & Quality of life improvements

Compared to Linode's existing CLI, this module will allow you to specify a label for most of the resources you're working with. In the background the module will convert the label to the ID of the resource for you. 

Example of retrieving an instance details using [linode-cli](https://www.linode.com/docs/products/tools/cli/guides/install/):

```bash
user@pc:/home$ linode-cli linodes list # get a list of Linodes in order to find the instance ID
┌──────────┬───────────────────────────────┬──────────────┬───────────────┬──────────────────────────────┬─────────┬─────────────────────────────────┐
│ id       │ label                         │ region       │ type          │ image                        │ status  │ ipv4                            │
├──────────┼───────────────────────────────┼──────────────┼───────────────┼──────────────────────────────┼─────────┼─────────────────────────────────┤
│ 12300123 │ smokeping-nl-ams              │ nl-ams       │ g6-nanode-1   │ linode/ubuntu22.04           │ running │ 172.123.123.123                 │
├──────────┼───────────────────────────────┼──────────────┼───────────────┼──────────────────────────────┼─────────┼─────────────────────────────────┤
│ 12366123 │ smokeping-us-mia              │ us-mia       │ g6-nanode-1   │ linode/ubuntu22.04           │ running │ 172.123.123.123                 │
├──────────┼───────────────────────────────┼──────────────┼───────────────┼──────────────────────────────┼─────────┼─────────────────────────────────┤
│ 12367123 │ smokeping-jp-osa              │ jp-osa       │ g6-nanode-1   │ linode/ubuntu22.04           │ running │ 172.123.123.123                 │
├──────────┼───────────────────────────────┼──────────────┼───────────────┼──────────────────────────────┼─────────┼─────────────────────────────────┤
│ 12374123 │ blog.dummyserver.net          │ nl-ams       │ g6-standard-2 │ linode/ubuntu22.04           │ running │ 172.123.123.123                 │
└──────────┴───────────────────────────────┴──────────────┴───────────────┴──────────────────────────────┴─────────┴─────────────────────────────────┘

user@pc:/home$ linode-cli linodes view 12374123
┌──────────┬───────────────────────────────┬────────┬───────────────┬──────────────────────────────┬─────────┬─────────────────────────────────┐
│ id       │ label                         │ region │ type          │ image                        │ status  │ ipv4                            │
├──────────┼───────────────────────────────┼────────┼───────────────┼──────────────────────────────┼─────────┼─────────────────────────────────┤
│ 12374123 │ blog.dummyserver.net          │ nl-ams │ g6-standard-2 │ linode/ubuntu22.04           │ running │ 172.123.123.123                 │
└──────────┴───────────────────────────────┴────────┴───────────────┴──────────────────────────────┴─────────┴─────────────────────────────────┘
```
Example retrieving an instance details using Linode Powershell module:

```powershell
Get-Linodeinstance -label blog.dummyserver.net

id               : 12374123
label            : blog.dummyserver.net
group            :
status           : running
created          : 2024-02-29T17:53:49
updated          : 2024-06-29T00:35:47
type             : g6-standard-2
ipv4             : {172.123.123.123}
ipv6             : 2600:4c0e::f04c:95ff:fe48:cda4/128
image            : linode/ubuntu22.04
region           : nl-ams
specs            : @{disk=81920; memory=4096; vcpus=2; gpus=0; transfer=4000}
alerts           : @{cpu=180; network_in=10; network_out=10; transfer_quota=80; io=10000}
backups          : @{enabled=True; available=True; schedule=; last_successful=2024-06-29T00:29:24}
hypervisor       : kvm
watchdog_enabled : True
tags             : {prod}
host_uuid        : 123f8e495e9d51c53df4fa074e5844bce944a068
has_user_data    : True
placement_group  :
lke_cluster_id   :
```
### Development

Status of implementation is as follows:

| Area    | Status  | Notes 
| ----------- | ----------- |-----------
| **Account**     | Done       |All functionalities besides billing available.
| **Beta programs**| Done       |All functionalities available
| **Account availability**| Done       |All functionalities available
| **Child accounts**| Not started       |None
| **Payments**| Not started       |None
| **Entity transfers**| Not started       |None
| **Events**| WIP       |Mark as read and seen not implemented yet
| **Invoices**| Done       |All functionalities available
| **Logins**| Done       |All functionalities available
| **Maintenances**| Done       |All functionalities available
| **Notifications**| Done       |All functionalities available
| **Oauth Clients**| Not started       |None
| **Client thumbnails**| Not started       |None
| **Payment methods**| Not started       |None
| **Promo credits**| Not started       |None
| **Service transfers**| Not started       |None
| **Account settings**| Not started       |None
| **Settings**| Not started       |None
| **Account transfer**| Done       |All functionalities available.
| **Users**| Done       |Everything besides "Update user's grant" command is implemented.
| **Beta programs**| Done       |All functionalities available.
| **Databases**| WIP       |MySQL 95% done, PostgreSQL 0%.
| **Domains**| WIP       |All GET commands done, 80% of write commands done.
| **Images**| Done       |None
| **Instances**| WIP       |60% done. Most important features are already available
| **StackScripts**| WIP       |80% done
| **LKE**| WIP       |95% done
| **Longview**| WIP       |0% done
| **Managed**| WIP       |0% done
| **Networking**| WIP       |80% done
| **NodeBalancers**| WIP       |80% done
| **Object storage**| Done       |100% done
| **Placement groups**| WIP       |0% done
| **Profile**| WIP       |0% done
| **Regions**| Done       |All functionalities available.
| **Support**| WIP       |0% done
| **Tags**| Done       |All functionalities available.
| **Volumes**| WIP       |50% done
| **VPC**| Done       |All functionalities available.


      

