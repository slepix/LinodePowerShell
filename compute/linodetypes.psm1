function Get-LinodeTypes{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/linode/types"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $linodetypes = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
        return $linodetypes    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeType{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$typeid
    )

    $uri = "https://api.linode.com/v4/linode/types/$typeid"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $linodetypes = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
        return $linodetypes    
    }
    catch {
        $_.ErrorDetails.Message
    }
}