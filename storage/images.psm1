function Get-LinodeImages {
    param (
        [string]$apiVersion = "v4",
        [int]$page = 1, 
        [int]$pagesize = 100,                  
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/$apiversion/images?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodeimages = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        $pages = $getlinodeimages.pages
        if($pages -gt 1){
            return "pages:$pages"
        }
        return $getlinodeimages.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeImage {
    param (
        [string]$apiVersion = "v4",
        [string]$id,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/$apiversion/images/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodeimage = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $getlinodeimage.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Push-LinodeImage {
    param (
        [string]$apiVersion = "v4",
        [string]$description,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$label,
        [Parameter(mandatory=$true)]                                           
        [string]$imagepath,
        [Parameter(mandatory=$true)]                                           
        [string]$region,
        [Parameter(mandatory=$false)]                                           
        [switch]$cloudinit,
        [Parameter(mandatory=$false)]                                           
        [switch]$progressbar 
    )

    $uri = "https://api.linode.com/v4/images/upload"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys
    if($cloudinit){ 
    $body.Add("cloud_init", $true)
    }

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "cloudinit|token"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }

    $body = $body | ConvertTo-Json
  
    try {
        if(!$progressbar){
            $ProgressPreference = 'SilentlyContinue'
        }
        $uploadheaders = @{
            "Content-Type" = "application/octet-stream"
        }
        $uploadtourl = Invoke-WebRequest -Uri $uri -Method POST -Headers $headers -Body $body
        $uploadto = ($uploadtourl.Content) | convertfrom-json | Select -ExpandProperty upload_to
        $upload = Invoke-WebRequest -Uri $uploadto -Method PUT -Headers $uploadheaders -infile $imagepath
        $upload.StatusDescription
        #return $uploadfile
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function Update-LinodeImage {
    param (
        [string]$apiVersion = "v4",
        [string]$description,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [Parameter(mandatory=$true)]                                           
        [string]$id       
    )

    $uri = "https://api.linode.com/v4/images/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys
    if($cloudinit){ 
    $body.Add("cloud_init", $true)
    }

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "token"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }

    $body = $body | ConvertTo-Json
  
    try {
        $updatelinodeimage = Invoke-webRequest -Uri $uri -Method PUT -Headers $headers -Body $body
        return ($updatelinodeimage.Content) | convertfrom-json
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeImage {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$id,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm               
    )

    $uri = "https://api.linode.com/v4/images/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"     
    }
    
    if(!$confirm){
        return "Please add -confirm flag in order to delete an image"
    }

    if($confirm){ 
    
        try {
            $removelinodeimage = Invoke-webRequest -Uri $uri -Method DELETE -Headers $headers
            return "Deleted"
        }
        catch {
            $_.ErrorDetails.Message
        }
    }
}

function New-LinodeImage {
    param (
        [string]$apiVersion = "v4",
        [string]$description,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$label,
        [Parameter(mandatory=$true)]                                           
        [int]$sourcedisk,        
        [Parameter(mandatory=$false)]                                           
        [switch]$cloudinit
    )

    $uri = "https://api.linode.com/v4/images"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($cloudinit){ 
        $body.Add("cloud_init", $true)
        }

    if($sourcedisk){ 
        $body.Add("disk_id", $sourcedisk)
        }

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "cloudinit|token|sourcedisk"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }

    $body = $body | ConvertTo-Json
  
    try {
        $createlinodeimage = Invoke-WebRequest -Uri $uri -Method POST -Headers $headers -Body $body
        return $createlinodeimage
    }
    catch {
        $_.ErrorDetails.Message
    }
}

