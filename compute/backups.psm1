function Get-LinodeBackups{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label
    )
 
    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeid/backups"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

        try {
            $LinodeBackups = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $LinodeBackups
        }
        catch {
            $_.ErrorDetails.Message
        }

}

function Get-LinodeBackupInfo{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label,
        [Parameter(Mandatory=$true)]
        [string]$backupId
    )
 
    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/backups/$backupId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

        try {
            $LinodeBackupinfo = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $LinodeBackupinfo
        }
        catch {
            $_.ErrorDetails.Message
        }

}