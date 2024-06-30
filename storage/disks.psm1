function Get-LinodeInstanceDisks{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,       
        [int]$page = 1, 
        [int]$pagesize = 100
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list disks from."
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

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/disks?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodedisks = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodedisks.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeInstanceDisk{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,      
        [string]$diskid
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list disks from."
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

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/disks/$diskId"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodedisk = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodedisk    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeInstanceDisk{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,      
        [string]$diskid,
        [switch]$confirm        
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you want to delete disk from."
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

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/disks/$diskId"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a disk."
        }
        if($confirm){ 
            $removelistlinodedisk = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "Disk (ID: $diskid) deleted"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}