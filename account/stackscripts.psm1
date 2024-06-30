function Get-LinodeStackScripts{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$page = 1, 
        [Parameter(Mandatory=$false)][int]$pagesize = 100                    
    )

    $uri = "https://api.linode.com/v4/linode/stackscripts?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodestackscripts = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodestackscripts.data
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeStackScript{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]
        [string]$id
    )

    $uri = "https://api.linode.com/v4/linode/stackscripts/$Id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodestackscript = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodestackscript
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeStackScript{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,        
        [Parameter(mandatory=$true)]
        [string]$id
    )
    
    $uri = "https://api.linode.com/v4/linode/stackscripts/$Id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a StackScript"
        }
        if($confirm){
        $removeLinodestackscript = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "Deleted"
        }
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}