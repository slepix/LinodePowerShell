function Get-LinodeDomains{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/domains?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $LinodeDomains = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeDomains.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDomain{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id
    )

    

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if(!$id -and !$label){
        return "Please provide a Domain ID or Domain label"
    }

    if($id -and $label){
        $domaindata = Get-LinodeDomains
        $domainid = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID
        $domainlabel = $domaindata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($domainid -ne $id -and $domainlabel -ne $label){
            return "Domain label and Domain ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $domaindata = Get-LinodeDomains
        $id = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID    
    } 

    $uri = "https://api.linode.com/v4/domains/" + "$id"

    try {
        $LinodeDomain = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeDomain
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDomainDNSRecords {
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if(!$id -and !$label){
        return "Please provide a Domain ID or Domain label"
    }

    if($id -and $label){
        $domaindata = Get-LinodeDomains
        $domainid = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID
        $domainlabel = $domaindata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($domainid -ne $id -and $domainlabel -ne $label){
            return "Domain label and Domain ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $domaindata = Get-LinodeDomains
        $id = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID    
    } 

    $uri = "https://api.linode.com/v4/domains/$Id/records?page=$page&page_size=$pagesize"

    try {
        $LinodeDomaindnsrecords = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeDomaindnsrecords.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDomainDNSRecord {
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [Parameter(mandatory=$true)] 
        [string]$recordid,        
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if(!$id -and !$label){
        return "Please provide a Domain ID or Domain label"
    }

    if($id -and $label){
        $domaindata = Get-LinodeDomains
        $domainid = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID
        $domainlabel = $domaindata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($domainid -ne $id -and $domainlabel -ne $label){
            return "Domain label and Domain ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $domaindata = Get-LinodeDomains
        $id = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID    
    } 

    $uri = "https://api.linode.com/v4/domains/$Id/records/$recordId"

    try {
        $LinodeDomaindnsrecord = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeDomaindnsrecord
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeDomainDNSRecord {
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [Parameter(mandatory=$true)] 
        [string]$recordid,        
        [switch]$confirm
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if(!$id -and !$label){
        return "Please provide a Domain ID or Domain label"
    }

    if($id -and $label){
        $domaindata = Get-LinodeDomains
        $domainid = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID
        $domainlabel = $domaindata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($domainid -ne $id -and $domainlabel -ne $label){
            return "Domain label and Domain ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $domaindata = Get-LinodeDomains
        $id = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID    
    } 

    $uri = "https://api.linode.com/v4/domains/$Id/records/$recordId"

    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a DNS record"
        }

        if($confirm){ 
        $removeLinodeDomaindnsrecord = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "DNS Record (ID: $recordid) removed."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeDomain {
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [switch]$confirm
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if(!$id -and !$label){
        return "Please provide a Domain ID or Domain label"
    }

    if($id -and $label){
        $domaindata = Get-LinodeDomains
        $domainid = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID
        $domainlabel = $domaindata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($domainid -ne $id -and $domainlabel -ne $label){
            return "Domain label and Domain ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $domaindata = Get-LinodeDomains
        $id = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID    
    } 

    $uri = "https://api.linode.com/v4/domains/$Id"

    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a domain"
        }

        if($confirm){ 
        $removeLinodeDomain = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Domain (ID: $id) removed."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDomainDNSZoneFile {
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [string]$outfile
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if(!$id -and !$label){
        return "Please provide a Domain ID or Domain label"
    }

    if($id -and $label){
        $domaindata = Get-LinodeDomains
        $domainid = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID
        $domainlabel = $domaindata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($domainid -ne $id -and $domainlabel -ne $label){
            return "Domain label and Domain ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $domaindata = Get-LinodeDomains
        $id = $domaindata | where {$_.domain -eq "$label"} | select -ExpandProperty ID    
    } 

    $uri = "https://api.linode.com/v4/domains/$Id/zone-file"

    try {
        $LinodeDomaindnszonefile = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        if($outfile){
            $filedata = $LinodeDomaindnszonefile.zone_file
            (New-item -path $outfile -force) | select -ExpandProperty FullName
            Add-Content -Path $outfile -Value $filedata
        }
        if(!$outfile){
            return $LinodeDomaindnszonefile.zone_file
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Import-LinodeDomain {
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]        
        [string]$label,
        [Parameter(mandatory=$true)] 
        [string]$remotedns
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    $body = @{}
    $body.Add("domain","$label")
    $body.Add("remote_nameserver","$remotedns")
    $body = $body | ConvertTo-Json
    $uri = "https://api.linode.com/v4/domains/import"

    try {
        $LinodeDomainImport = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
        return $LinodeDomainImport
    }
    catch {
        $_.ErrorDetails.Message
    }
}