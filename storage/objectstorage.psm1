function Get-LinodeObjectStorageBuckets{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4"        
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/$api/object-storage/buckets"
        try {
            $Linodeobjectstoragebuckets = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstoragebuckets.data
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function Get-LinodeObjectStorageBucket{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4",
        [Parameter(mandatory=$true)]         
        [string]$bucket,
        [Parameter(mandatory=$true)]         
        [string]$region
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/$api/object-storage/buckets/$region/$bucket"
        try {
            $Linodeobjectstoragebucket = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstoragebucket
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function Get-LinodeObjectStorageBucketsPerRegion{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4",
        [Parameter(mandatory=$true)]         
        [string]$region
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/$api/object-storage/buckets/$region"
        try {
            $Linodeobjectstoragebucketperregion = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstoragebucketperregion.data
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function New-LinodeObjectStorageBucket {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$label,
        [Parameter(mandatory=$true)]
        [ValidateSet('private','public-read','authenticated-read','public-read-write')]                                           
        [string]$acl,        
        [Parameter(mandatory=$false)]                                           
        [switch]$corsenabled,
        [Parameter(mandatory=$true)]                                           
        [string]$region
    )

    $uri = "https://api.linode.com/$apiVersion/object-storage/buckets"

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($corsenabled){ 
        $body.Add("cors_enabled", $true)
        }

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "corsenabled|token"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }

    $body = $body | ConvertTo-Json
    try {
        $createlinodeobjectstoragebucket = Invoke-RestMethod -Uri $uri -Method POST -ContentType 'application/json' -Headers $headers -Body "$body"
        return $createlinodeobjectstoragebucket
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeObjectStorageBucket{
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,        
        [Parameter(mandatory=$true)]
        [string]$region,
        [Parameter(mandatory=$true)]
        [string]$bucket        
    )
    
    $uri = "https://api.linode.com/$apiVersion/object-storage/buckets/$region/$bucket"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a bucket"
        }
        if($confirm){
        $removeLinodeobjectstoragebucket = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "Bucket $bucket deleted"
        }
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function New-LinodeObjectStoragePreSignedURL {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [int]$expires,
        [Parameter(mandatory=$true)]
        [ValidateSet('get','put','delete')]                                           
        [string]$method,        
        [Parameter(mandatory=$true)]                                           
        [string]$region,
        [Parameter(mandatory=$true)]                                           
        [string]$bucket,
        [Parameter(mandatory=$true)]                                           
        [string]$file,
        [Parameter(mandatory=$false)]                                           
        [string]$contenttype                            
    )

    $uri = "https://api.linode.com/$apiVersion/object-storage/buckets/$region/$bucket/object-url"

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($corsenabled){ 
        $body.Add("cors_enabled", $true)
        }                

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "corsenabled|token"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }

    $body = $body | ConvertTo-Json
    try {
        $linodeobjectstorageaccess = Invoke-RestMethod -Uri $uri -Method POST -ContentType 'application/json' -Headers $headers -Body "$body"
        return $linodeobjectstorageaccess
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Set-LinodeObjectStorageBucketAccess {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]                                           
        [switch]$corsenabled,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,             
        [Parameter(mandatory=$true)]                                           
        [string]$region,
        [Parameter(mandatory=$true)]                                           
        [string]$bucket,
        [Parameter(mandatory=$true)]
        [ValidateSet('private','public-read','authenticated-read','public-read-write')]                                           
        [string]$acl                                
    )

    $uri = "https://api.linode.com/$apiVersion/object-storage/buckets/$region/$bucket/access"

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($corsenabled){ 
        $body.Add("cors_enabled", $true)
        }
    
    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "bucket|region|token|corsenabled"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }

    $body = $body | ConvertTo-Json

    try {
        if(!$confirm){
            return "Please add -confirm flag in order to change access settings."
        }
        if($confirm){
        $linodeobjectstorageaccess = Invoke-RestMethod -Uri $uri -Method POST -ContentType 'application/json' -Headers $headers -Body "$body"
        return "Bucket $bucket settings changed."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeObjectStorageObjectACL{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4",
        [Parameter(mandatory=$true)]         
        [string]$region,
        [Parameter(mandatory=$true)]         
        [string]$bucket,
        [Parameter(mandatory=$true)]         
        [string]$file                
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/v4/object-storage/buckets/$region/$bucket/object-acl?name=$file"
        try {
            $Linodeobjectstorageobjectacl = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstorageobjectacl
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function Set-LinodeObjectStorageObjectACL {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,             
        [Parameter(mandatory=$true)]                                           
        [string]$region,
        [Parameter(mandatory=$true)]                                           
        [string]$bucket,
        [Parameter(mandatory=$true)]                                           
        [string]$file,        
        [Parameter(mandatory=$true)]
        [ValidateSet('private','public-read','authenticated-read','public-read-write')]                                           
        [string]$acl                                
    )

    $uri = "https://api.linode.com/$apiversion/object-storage/buckets/$region/$bucket/object-acl"

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($file){ 
        $body.Add("name", "$file")
        }
    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "bucket|region|token|file|confirm"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json

    try {
        if(!$confirm){
            return "Please add -confirm flag in order to change access settings."
        }
        if($confirm){
        $linodeobjectstorageobjectaccess = Invoke-RestMethod -Uri $uri -Method PUT -ContentType 'application/json' -Headers $headers -Body $body
        return "ACL for $file set to $acl"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeObjectStorageBucketContent{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4",
        [Parameter(mandatory=$true)]         
        [string]$region,
        [Parameter(mandatory=$true)]         
        [string]$bucket,
        [Parameter(mandatory=$false)]         
        [string]$delimiter,
        [Parameter(mandatory=$false)]         
        [string]$prefix,
        [Parameter(mandatory=$false)]         
        [string]$marker,                          
        [Parameter(mandatory=$false)]         
        [int]$pagesize = 100                
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/v4/object-storage/buckets/$region/$bucket/object-list?marker=$marker&delimiter=$delimiter&prefix=$prefix&page_size=$pagesize"
        try {
            $Linodeobjectstorageobjectstoragecontent = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstorageobjectstoragecontent
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function Get-LinodeObjectStorageClusters{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4"
              
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/$api/object-storage/clusters"
        try {
            $Linodeobjectstorageobjectstorageclusters = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstorageobjectstorageclusters.data
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function Get-LinodeObjectStorageCluster{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4",
        [Parameter(mandatory=$true)]  
        [string]$cluster        
              
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/$api/object-storage/clusters/$cluster"
        try {
            $Linodeobjectstorageobjectstorageclusters = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstorageobjectstorageclusters
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function New-LinodeObjectStorageAccessKey {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$label,
        [Parameter(mandatory=$true)]                                           
        [string]$bucket,        
        [Parameter(mandatory=$true)]
        [ValidateSet('read_write','read_only')]                                           
        [string]$permissions,        
        [Parameter(mandatory=$true)]                                           
        [string]$region,
        [Parameter(mandatory=$false)]                                           
        [string]$regions        
    )

    $uri = "https://api.linode.com/$apiVersion/object-storage/buckets"

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($regions){ 
        $split = $regions.split(",")
        foreach($region in $split){
       # $body.Add[regions].Add("$region")
        $body['regions']+=@([string]$region)
        }
    }
    #$body['bucket_access']+={"('bucket_name',$bucket)"}
    $body['bucket_access']+=@({"bucket_name","$bucket"})

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "permissions|bucket|token|region"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")

    }

    $body = $body | ConvertTo-Json
    echo $body
    try {
        #$createlinodeobjectstoragebucket = Invoke-RestMethod -Uri $uri -Method POST -ContentType 'application/json' -Headers $headers -Body "$body"
        return $createlinodeobjectstoragebucket
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeObjectStorageAccessKeys{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4"
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/v4/object-storage/keys"
        try {
            $Linodeobjectstorageobjectstorageaccesskeys = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstorageobjectstorageaccesskeys.data
        }
        catch {
            $_.ErrorDetails.Message
        }
}

function Get-LinodeObjectStorageAccessKey{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$api = "v4",
        [string]$id,
        [string]$label
    )

    if(!$id -and !$label){
        return "Please provide a Key ID or Key label."
    }

    if($id -and $label){
        $keydata = Get-LinodeObjectStorageAccessKey 
        $keyid = $keydata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $keylabel = $keydata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $keyid -and $label -ne $keylabel){
            return "Key label and Key ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeObjectStorageAccessKeys 
        $keyid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    } 


    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/v4/object-storage/keys/$keyid"

        try {
            $Linodeobjectstorageobjectstorageaccesskeys = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $Linodeobjectstorageobjectstorageaccesskeys
        }
        catch {
            $_.ErrorDetails.Message
        }
}


function Remove-LinodeObjectStorageAccessKey{
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,        
        [Parameter(mandatory=$false)]
        [string]$label,
        [Parameter(mandatory=$false)]
        [string]$id        
    )
    
    if(!$id -and !$label){
        return "Please provide a Key ID or Key label you want to delete."
    }

    if($id -and $label){
        $keydata = Get-LinodeObjectStorageAccessKey 
        $keyid = $keydata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $keylabel = $keydata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $keyid -and $label -ne $keylabel){
            return "Key label and Key ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeObjectStorageAccessKeys 
        $keyid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    } 

    $uri = "https://api.linode.com/v4/object-storage/keys/$keyid"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a key"
        }
        if($confirm){
        $removeLinodeobjectstoragebucket = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "Key with ID $keyid deleted."
        }
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}
