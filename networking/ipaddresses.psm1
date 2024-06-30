function Get-LinodeIPAddresses{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$page = 1,
        [string]$pagesize = 100
    )


    $uri = "https://api.linode.com/v4/networking/ips?skip_ipv6_rdns=false"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodeipaddr = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodeipaddr.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeIPAddress{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$ip
    )


    $uri = "https://api.linode.com/v4/networking/ips/$ip"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodeipaddress = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodeipaddress
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeIPv6Pools{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$page = 1,
        [string]$pagesize = 100
    )


    $uri = "https://api.linode.com/v4/networking/ipv6/pools?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodeipv6pool = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodeipv6pool.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeIPv6Ranges{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )


    $uri = "https://api.linode.com/v4/networking/ipv6/ranges?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodeipv6ranges = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodeipv6ranges.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeIPv6Range{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$range
    )


    $uri = "https://api.linode.com/v4/networking/ipv6/ranges/$range"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodeipv6range = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodeipv6range
    }
    catch {
        $_.ErrorDetails.Message
    }
}