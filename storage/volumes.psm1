function Get-LinodeVolumes{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1, 
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/volumes?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevolumes = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevolumes.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$id
    )

    if(!$id){
        return "Please provide a Volume ID."
    }

    $uri = "https://api.linode.com/v4/volumes/$Id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevolume = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevolume   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Copy-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$id,
        [Parameter(Mandatory=$false)][string]$label
    )

    if(!$id -or !$label){
        return "Please provide a Volume ID and a destination volume label."
    }

    $body = @{}
    $body.Add("label","$label")
    $body = $body | convertto-json

    $uri = "https://api.linode.com/v4/volumes/$id/clone"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"
    }
    try {
        $clonelinodevolume = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
        return $clonelinodevolume   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$id,
        [Parameter(Mandatory=$false)][switch]$confirm
    )

    if(!$id){
        return "Please provide a Volume ID"
    }
    if(!$confirm){
        return "Please use -confirm flag in order to delete a volume."
    }

    $uri = "https://api.linode.com/v4/volumes/$id"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $removelinodevolume = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Volume (ID: $id) deleted."   
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function New-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$id,
        [Parameter(Mandatory=$true)][int]$size,        
        [Parameter(Mandatory=$false)][string]$label,
        [Parameter(Mandatory=$true)][string]$region,
        [Parameter(Mandatory=$false)][string]$tags,
        [Parameter(Mandatory=$false)][int]$configid
    )

    $body = @{}
    $body.Add("label","$label")
    $body.Add("region","$region")
    $body.Add("size", $size)

    if($id){
        $body.Add("linode_id",$id)
    }
    if($configid){
        $body.Add("config_id",$configid)
    }

    if($tags){
        $split = $tags.split(",")
        $count = $split.count
        foreach($_ in $split){
        $body['tags']+=@([string]$_)
        }
    }

    $body = $body | convertto-json

    $uri = "https://api.linode.com/v4/volumes"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"
    }
    try {
        $newlinodevolume = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
        return $newlinodevolume   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Disconnect-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$id,
        [Parameter(Mandatory=$false)][switch]$confirm
    )

    if(!$id){
        return "Please provide a Volume ID"
    }
    if(!$confirm){
        return "Please use -confirm flag in order to disconnect/detach a volume."
    }

    $uri = "https://api.linode.com/v4/volumes/$id/detach"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $detachlinodevolume = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Volume (ID: $id) detached."   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Connect-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$id,
        [Parameter(Mandatory=$true)][int]$volumeid,        
        [Parameter(Mandatory=$false)][string]$label,
        [Parameter(Mandatory=$false)][switch]$nopersist,
        [Parameter(Mandatory=$false)][int]$configid
    )

    if(!$id -or !$volumeid){
        return "Please provide a Volume ID and a Linode ID where you wish to attach it to"
    }

    $body = @{}
    $body.Add("linode_id",$id)
    
    if($configid){
        $body.Add("config_id", $configid)
    }

    if($nopersist){
        $body.Add("persist_across_boots", $false)
    }

    $body = $body | convertto-json

    $uri = "https://api.linode.com/v4/volumes/$volumeid/attach"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"
    }
    try {
        $attachlinodevolume = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
        return $attachlinodevolume   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Resize-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$true)][int]$id,        
        [Parameter(Mandatory=$true)][int]$size
    )

    $body = @{}
    $body.Add("size", $size)
    $body = $body | convertto-json

    $uri = "https://api.linode.com/v4/volumes/$id/resize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"
    }
    try {
        $resizelinodevolume = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
        return $resizelinodevolume   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Update-LinodeVolume{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$true)][int]$id,        
        [Parameter(Mandatory=$false)][string]$label,
        [Parameter(Mandatory=$false)][string]$tags
    )

    $body = @{}
    $body.Add("label","$label")

    if($tags){
        $split = $tags.split(",")
        $count = $split.count
        foreach($_ in $split){
        $body['tags']+=@([string]$_)
        }
    }

    $body = $body | convertto-json

    $uri = "https://api.linode.com/v4/volumes/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"
    }
    try {
        $updatelinodevolume = Invoke-RestMethod -Uri $uri -Method PUT -Headers $headers -Body $body
        return $updatelinodevolume   
    }
    catch {
        $_.ErrorDetails.Message
    }
}