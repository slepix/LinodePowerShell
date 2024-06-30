function Get-LinodeInstanceStatistics{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list volumes from."
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      
        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/stats"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodestatistics = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodestatistics.data
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMonthlyStatistics{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,
        [Parameter(Mandatory=$true)][int]$year, 
        [Parameter(Mandatory=$true)][int]$month,                     
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list volumes from."
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      
        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeid/stats/$year/$month"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodestatistics = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodestatistics.data
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function Get-LinodeInstanceTransferUsage{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list volumes from."
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      
        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/transfer"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodetransferusage = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodetransferusage        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeInstanceMonthlyTransferUsage{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,
        [Parameter(Mandatory=$true)][int]$year, 
        [Parameter(Mandatory=$true)][int]$month,                     
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list volumes from."
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      
        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -token $token -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeid/transfer/$year/$month"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodemonthlytransferusage = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodemonthlytransferusage
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNodeBalancerStatistics{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$id,
        [string]$label
    )

    if($label){
        $id = Get-NodeBalancers -token $token | where {$_.label -eq "$label"} | select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/nodebalancers/$id/stats"



    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listnodebalancerstats = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listnodebalancerstats.data   
    }
    catch {
        $_.ErrorDetails.Message
    }
}