function New-LinodeVPC {
    param (
        [string]$description,
        [string]$apiVersion,
        [Parameter(mandatory=$false)]        
        [string]$label,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]
        [string]$region,        
        [Parameter(mandatory=$false)]                                           
        [string]$subnetlabel,
        [Parameter(mandatory=$false)]                                           
        [string]$iprange        
    )

    $uri = "https://api.linode.com/v4/vpcs"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
        "accept"  = "application/json"        
    }

    if(!$label){
        return "Please provide VPC label."
    }
    if(!$region){
        return "Please provide VPC region."
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($subnetlabel -and !$iprange){
        return "Please provide a IP range for the subnet in the format 10.0.0.0/24"
    }

    if($subnetlabel){
        $subnetinfo = @{
            "label" = $subnetlabel
            "ipv4" = $iprange
        }
        $body['subnets'] = @($subnetinfo)
    }

    foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "subnetlabel|token|iprange"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    try {
        $newvpc = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
        return "VPC $label created"
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVPCs{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/vpcs?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevpcs = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevpcs.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVPC{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$name
    )

    if($name -and !$id){
        $id = get-linodevpcs | where {$_.label -eq $name} | Select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/vpcs/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevpc = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevpc.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeVPC{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [switch]$confirm
    )

    if(!$confirm){
        echo "You will need to use -confirm flag in order to delete a VPC"
    }

    if(!$label -and !$id){
        return "You need to provide a VPC ID or VPC label"
    }

    if($label -and !$id){
        $id = get-linodevpcs | where {$_.label -eq $label} | Select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/vpcs/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    if($confirm){
    try {
        $removelinodevpc = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "VPC $label deleted"
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
}

function Update-LinodeVPC{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$description,
        [int]$id,
        [string]$label,
        [string]$newlabel
    )

    if(!$label){
        return "You need to provide a VPC ID or VPC label"
    }

    if($label -and !$id){
        $id = get-linodevpcs | where {$_.label -eq $label} | Select -ExpandProperty id
    }

    $body = @{}
    $body.Add("label","$newlabel")
    $updateuri = "https://api.linode.com/v4/vpcs/$id"
    $headers = @{
        'Authorization' = "Bearer $Token"
        'accept'  = 'application/json'
        'content-type'  = 'application/json'
    }
   
    try {
        $updatelinodevpc = Invoke-WebRequest -Uri $updateuri -Method PUT -Headers $headers -ContentType 'application/json' -Body "{`"description`":`"$description`",`"label`":`"$newlabel`"}" 
        return "VPC $label updated"
    }
    catch {
        $_.ErrorDetails.Message
    }

}

function Get-LinodeVLANS{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$page = 1,
        [string]$pagesize = 100
    )


    $uri = "https://api.linode.com/v4/networking/vlans?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevlan = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevlan.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVPCIPAddresses{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/vpcs/ips?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevpcips = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevpcips.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVPCsIPAddresses{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,        
        [int]$page = 1,
        [int]$pagesize = 100
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($id -and $label){
        $vpcdata = Get-LinodeVPC
        $vpcid = $vpcdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $vpclabel = $vpcdata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($vpcid -ne $id -and $vpclabel -ne $label){
            return "VPC label and VPC ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $vpcdata = Get-LinodeVPC
        $vpcid = $vpcdata | where {$_.label -eq "$label"} | select -ExpandProperty ID    
    }    

    $uri = "https://api.linode.com/v4/vpcs/$vpcId/ips" + "?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevpcsips = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevpcsips
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVPCSubnets{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,        
        [int]$page = 1,
        [int]$pagesize = 100
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($id -and $label){
        $vpcdata = Get-LinodeVPC
        $vpcid = $vpcdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $vpclabel = $vpcdata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($vpcid -ne $id -and $vpclabel -ne $label){
            return "VPC label and VPC ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $vpcdata = Get-LinodeVPC
        $vpcid = $vpcdata | where {$_.label -eq "$label"} | select -ExpandProperty ID    
    }  

    $uri = "https://api.linode.com/v4/vpcs/$vpcId/subnets?page=1&page_size=100"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevpcips = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevpcips.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeVPCSubnet{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id, 
        [Parameter(mandatory=$true)]  
        [string]$subnetid,       
        [string]$label,        
        [int]$page = 1,
        [int]$pagesize = 100
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($id -and $label){
        $vpcdata = Get-LinodeVPC
        $vpcid = $vpcdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $vpclabel = $vpcdata | where {$_.id -eq "$id"} | select -ExpandProperty label

        if($vpcid -ne $id -and $vpclabel -ne $label){
            return "VPC label and VPC ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $vpcdata = Get-LinodeVPC
        $vpcid = $vpcdata | where {$_.label -eq "$label"} | select -ExpandProperty ID    
    }  

    $uri = "https://api.linode.com/v4/vpcs/$vpcId/subnets/$SubnetId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevpcsubnet = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevpcsubnet
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function New-LinodeVPCSubnet{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$description,
        [int]$id,
        [string]$label,
        [Parameter(mandatory=$true)] 
        [string]$subnetlabel,
        [Parameter(mandatory=$true)] 
        [string]$ipv4range
    )

    if(!$label){
        return "You need to provide a VPC ID or VPC label"
    }

    if($label -and !$id){
        $vpcid = get-linodevpcs | where {$_.label -eq $label} | Select -ExpandProperty id
    }

    $body = @{}
    $body.Add("label","$subnetlabel")
    $body.Add("ipv4","$ipv4range")

    $updateuri = "https://api.linode.com/v4/vpcs/$vpcid/subnets"
    $headers = @{
        'Authorization' = "Bearer $Token"
        'accept'  = 'application/json'
        'content-type'  = 'application/json'
    }
    $body = $body | ConvertTo-Json
    try {
        $updatelinodevpc = Invoke-RestMethod -Uri $updateuri -Method POST -Headers $headers -body $body
        return "VPC subnet $subnetlabel with IP range $ipv4range created."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeVPCSubnet{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$description,
        [int]$id,
        [string]$label,
        [Parameter(mandatory=$true)] 
        [string]$subnetid,
        [Parameter(mandatory=$false)]
        [switch]$confirm
    )

    if(!$label){
        return "You need to provide a VPC ID or VPC label"
    }

    if($label -and !$id){
        $vpcid = get-linodevpcs | where {$_.label -eq $label} | Select -ExpandProperty id
    }
  
    $updateuri = "https://api.linode.com/v4/vpcs/$vpcId/subnets/$SubnetId"
    $headers = @{
        'Authorization' = "Bearer $Token"
        'accept'  = 'application/json'
        'content-type'  = 'application/json'
    }

    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a VPC subnet"
        }
        if($confirm){ 
            $updatelinodevpc = Invoke-RestMethod -Uri $updateuri -Method DELETE -Headers $headers
            return "VPC subnet $subnetid deleted."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }

}

function Update-LinodeVPCSubnet{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$description,
        [int]$id,
        [string]$label,
        [Parameter(mandatory=$true)] 
        [string]$subnetid,
        [Parameter(mandatory=$true)] 
        [string]$newsubnetlabel
    )

    if(!$label){
        return "You need to provide a VPC ID or VPC label"
    }

    if($label -and !$id){
        $vpcid = get-linodevpcs | where {$_.label -eq $label} | Select -ExpandProperty id
    }

    $body = @{}
    $body.Add("label","$newsubnetlabel")

    $updateuri = "https://api.linode.com/v4/vpcs/$vpcId/subnets/$SubnetId"
    $headers = @{
        'Authorization' = "Bearer $Token"
        'accept'  = 'application/json'
        'content-type'  = 'application/json'
    }
    $body = $body | ConvertTo-Json
    try {
        $updatelinodevpc = Invoke-RestMethod -Uri $updateuri -Method PUT -Headers $headers -body $body
        return "VPC subnet $subnetid updated."
    }
    catch {
        $_.ErrorDetails.Message
    }
}