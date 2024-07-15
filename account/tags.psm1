function New-LinodeTag {
    param (
        [string]$linodes,
        [string]$apiVersion,
        [Parameter(mandatory=$true)]        
        [string]$label,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$nodebalancers,  
        [string]$volumes   
    )

    $uri = "https://api.linode.com/v4/tags"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
        "accept"  = "application/json"        
    }

    if(!$label){
        return "Please provide tag label."
    }
    
    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($nodebalancers){
        $split = $nodebalancers.split(",")
        $count = $split.count
        foreach($_ in $split){
        $body['nodebalancers']+=@([int]$_)
        }
    }

    if($volumes){
        $split = $volumes.split(",")
        $count = $split.count
        foreach($_ in $split){
        $body['volumes']+=@([int]$_)
        }
    }

    if($linodes){
        $split = $linodes.split(",")
        $count = $split.count
        foreach($_ in $split){
        $body['linodes']+=@([int]$_)
        }
    }

    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "token|nodebalancers|volumes|linodes"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    echo $body
    try {
        $newlinodetag = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
        return $newlinodetag
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeTag {
    param (
        [int]$linodes,
        [string]$apiVersion,
        [Parameter(mandatory=$true)]        
        [string]$label,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/tags/$label"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
        "accept"  = "application/json"        
    }

    if(!$label){
        Write-host -ForegroundColor Red "Please provide tag label."
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "token|nodebalancers|volumes|linodes"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    try {
        $removelinodetag = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers -Body $body
        Write-host "Label $label removed"
        return $removelinodetag
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeTags {
    param (
        [string]$apiVersion = "v4",
        [int]$page = 1, 
        [int]$pagesize = 100,                  
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/$apiversion/tags?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodetag = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        $pages = $getlinodetag.pages
        if($pages -gt 1){
            return "pages:$pages"
        }
        return $getlinodetag.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeTaggedObjects {
    param (
        [string]$apiVersion = "v4",
        [string]$label,
        [int]$page = 1, 
        [int]$pagesize = 100,                  
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    if(!$label){
        return "Please provide tag label"
    }

    $uri = "https://api.linode.com/v4/tags/$label" + "?page=$page&page_size=$pagesize"
 
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeTaggedObjects = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        $pages = $LinodeTaggedObjects.pages
        if($pages -gt 1){
            return "pages:$pages"
        }
        return $LinodeTaggedObjects.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}