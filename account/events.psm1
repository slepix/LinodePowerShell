function Get-LinodeEvents {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1, 
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/account/events?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeEvents = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeEvents.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeEvent {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$id
    )

    $uri = "https://api.linode.com/v4/account/events/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeEvents = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeEvents
    }
    catch {
        $_.ErrorDetails.Message
    }
}