function Get-LinodeFirewalls {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/networking/firewalls?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $Linodefirewalls = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $Linodefirewalls.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeFirewall {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label               
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEfirewall = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEfirewall
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeFirewallRules {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label               
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId/rules"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEfirewallrules = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEfirewallrules
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeFirewall {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a firewall"
        }
        if($confirm){
            $LinodeLKEfirewalldelete = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "Linode Firewall (ID: $firewallId) deleted"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeFirewallDevices {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [int]$page = 1,
        [int]$pagesize = 100,        
        [string]$label
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId/devices?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $Linodefirewalls = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $Linodefirewalls.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeFirewallDevice {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$deviceid,        
        [string]$label
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId/devices/$deviceId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $Linodefirewalldevice = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $Linodefirewalldevice
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeFirewallDevice {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$deviceid,        
        [string]$label,
        [switch]$confirm
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId/devices/$deviceId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a firewall device"
        }
        if($confirm){
            $LinodeLKEfirewalldevicedelete = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "Linode Firewall device (ID: $deviceid) deleted"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function New-LinodeFirewallDevice {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$deviceid,        
        [string]$label
    )


    if(!$id -and !$label){
        return "Please provide a Firewall ID or Firewall label."
    }

    if($id -and $label){
        $fwdata = Get-LinodeFirewalls
        $fwid = $fwdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $fwlabel = $fwdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $fwid -and $label -ne $fwlabel){
            return "Firewall label and Firewall ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeFirewalls 
        $firewallId = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/networking/firewalls/$firewallId/devices"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
            $LinodeLKEfirewalldevicecreate = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
            return $LinodeLKEfirewalldevicecreate
    }
    catch {
        $_.ErrorDetails.Message
    }
}