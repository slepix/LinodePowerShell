function New-RandomPassword{
    param (
        [Parameter(mandatory=$false)]
        $passwordlength = "16"
    )
    $output =  -join ((65..90) + (97..122) + (48..100) | Get-Random -Count $passwordlength | ForEach-Object {[char]$_})
    return $output
      

}

function New-LinodeInstance {
    param (
        [string]$apiVersion,
        [string]$authorized_keys,    
        [string]$booted,                      
        [string]$metadata, 
        [string]$stackscript_data, 
        [string]$stackscript_id,    
        [string]$backupid,  
        [string]$backupsenabled, 
        [string]$firewallid,   
        [string]$interfaces,     
        [string]$ipam_address, 
        [string]$subnet_id, 
        [string]$placement_group, 
        [int]$passwordlength,        
        [string]$private_ip, 
        [string]$swap_size,   
        [string]$tags,                        
        [string]$label,         
        [string]$ipv4,  
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]
        [string]$region,
        [Parameter(mandatory=$true)]
        [string]$type,
        [Parameter(mandatory=$true)]
        [string]$image,
        [Parameter(Mandatory=$false)][switch]$generatepassword,      
        [Parameter(Mandatory=$false)][string]$RootPass  
    )

    $uri = "https://api.linode.com/v4/linode/instances"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
    }

    if($generatepassword -and $RootPass){
        return "Please specify ONLY RootPass or -generatepassword flag"
    }
    if(!$generatepassword -and !$RootPass){
        return "Please specify password in RootPass parameter OR use -generatepassword flag"
    }    

    if($generatepassword){
        $RootPass = New-RandomPassword
        $generated = $true 
    }

    if($generatepassword -and $passwordlength){
        $RootPass = New-RandomPassword -passwordlength $passwordlength
        $generated = $true 
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys
    $body.Add("root_pass","$RootPass")

   foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "generatepassword|token"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
        $response | Add-Member -MemberType NoteProperty -Name "root_password" -Value "$rootpass"
         return $response
    }
    catch {
        $_.ErrorDetails.Message
    }


    

}

#New-LinodeInstance -Region $region -Type $type -Image $image -RootPass $rootPass

function Get-LinodeInstances{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]
        [string]$label,
        [Parameter(mandatory=$false)]
        [string]$region = "all",        
        [Parameter(mandatory=$false)]
        [string]$id,
        [Parameter(mandatory=$false)]
        [string]$pagesize = 500,   
        [Parameter(mandatory=$false)]
        [string]$page = 1,              
        [Parameter(mandatory=$false)]
        [string]$ip4v
    )
    $uri = "https://api.linode.com/v4/linode/instances?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    $body =@{}
    $body.Add("region","$region")
    $body = $body | ConvertTo-Json

    $linodes = (Invoke-RestMethod -Uri $uri -Method GET -Headers $headers).data
    $linodes
    
}

function Get-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]
        [string]$label,
        [Parameter(mandatory=$false)]
        [string]$region = "all",        
        [Parameter(mandatory=$false)]
        [string]$id,
        [Parameter(mandatory=$false)]
        [string]$pagesize = 500,   
        [Parameter(mandatory=$false)]
        [string]$page = 1,              
        [Parameter(mandatory=$false)]
        [string]$ip4v
    )

    if(!$id -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($id -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    $linode = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
    $linode
}

function Remove-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label, 
        [Parameter(mandatory=$false)]
        [switch]$confirm,
        [Parameter(mandatory=$false)]
        [switch]$dryrun    
    )
    if(!$confirm -and $dryun){
        continue
    }

    if(!$confirm -and !$dryun){
        return "Please add -confirm flag if you REALLY want to delete an instance"
    }

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            Write-host -ForegroundColor Red "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstances -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId"

    if($dryrun){
        Write-host "Deleting instance with the ID $linodeid"
        $instancedata = get-linodeinstances -region "all" | where {$_.id -match $linodeid} | Select Label, Id, Region, type,image, tags, ipv4, ipv6
        Write-host "Instance info:"
        return $instancedata
    }

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $linodes = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        Write-host "Instance $linodeid deleted"
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Restart-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label,
        [Parameter(Mandatory=$false)][int]$configID
    )
 
    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/reboot"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    $body =@{}
    $body.Add("config_id","$configID")
    $body = $body | ConvertTo-Json

    if(!$configID){
       try {
        $bootlinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Instance $linodeid started with default boot configuration"
       }
       catch {
        $_.ErrorDetails.Message
       }
    }
    if($configID){ 
        try {
            $bootlinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
            Write-host "Instance $linodeid started with custom boot configuration. Boot configuration ID: $configID"
        }
        catch {
            $_.ErrorDetails.Message
        }
    }
}


function Start-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label,
        [Parameter(Mandatory=$false)][int]$configID
    )
 
    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/boot"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    $body =@{}
    $body.Add("config_id","$configID")
    $body = $body | ConvertTo-Json

    if(!$configID){
       try {
        $bootlinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Instance $linodeid started with default boot configuration"
       }
       catch {
        $_.ErrorDetails.Message
       }
    }
    if($configID){ 
        try {
            $bootlinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
            Write-host "Instance $linodeid started with custom boot configuration. Boot configuration ID: $configID"
        }
        catch {
            $_.ErrorDetails.Message
        }
    }
}

function Stop-LinodeInstance{
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
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/shutdown"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
  try {
        $bootlinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        Write-host "Instance $linodeid shut down"
       }
       catch {
        $_.ErrorDetails.Message
       }
}


function Copy-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$clonelabel,
        [Parameter(Mandatory=$false)][string]$source, 
        [Parameter(Mandatory=$false)][switch]$privateip,  
        [Parameter(Mandatory=$false)][switch]$backupsenabled,
        [Parameter(Mandatory=$false)][string]$type,
        [Parameter(Mandatory=$false)][string]$region,        
        [Parameter(Mandatory=$false)][string]$disks,
        [Parameter(Mandatory=$false)][string]$configs
    )

    $body = @{}

    if(!$clonelabel){
        return "Please provide the label name for the cloned instance"
    }
 
    if(!$linodeid -and !$source){
        return "Please provide a Linode ID or instance label you want to clone"
    }

    if($linodeid -and $source){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$source"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label

        if($linodeid -ne $id -and $linodelabel -ne $source){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $source){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$source"} | select -ExpandProperty ID        
    }    

    if(!$type){
        $instancedata = get-linodeinstance -region "all" 
        $currentinstancetype = $instancedata | where {$_.label -eq "$source"} | select -ExpandProperty type
        $body.Add("type","$currentinstancetype")
    }

    if(!$region){
        $instancedata = get-linodeinstance -region "all" 
        $region = $instancedata | where {$_.label -eq "$source"} | select -ExpandProperty region 
        $body.Add("region","$region")
    }

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/clone"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

 
    $bodydata = $PSBoundParameters.keys

    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        echo "$varname : $value"
        if($varname -match "backupsenabled"){
            $body.Add("backups_enabled", $true)
        }

        if($varname -match "privateip"){
            $body.Add("private_ip", $true)
        }        

        if($varname -match "label|token|backupsenabled"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body.Add("label","$clonelabel")
    $body = $body | ConvertTo-Json
    try {
        $bootlinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        Write-host "Instance $linodeid cloned into $clonelabel."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Move-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label, 
        [Parameter(Mandatory=$false)][string]$type = "cold",
        [Parameter(Mandatory=$false)][switch]$upgrade,        
        [Parameter(Mandatory=$false)][string]$region       
    )

    $body = @{}

    if(!$type){
        $type = "cold"
    }
    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you want to migrate"
    }

    if(!$region){
        return "Please provide a region ID where you wish to migrate your Linode"
    }  

    if($region){
        $instancedata = get-linodeinstance -region "all" 
        $currentregion = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty region
        if($currentregion -eq $region){
            return -ForegroundColor Yellow "You cannot migrate to the same region where your instance is already hosted"
        }
    }  

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/migrate"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

 
    $bodydata = $PSBoundParameters.keys

    foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        if($varname -match "token"){
            continue
        }
        if($upgrade){
        $body.Add("upgrade",$true)
        }

        #$body.Add("type","$type")
        #echo "$varname : $value"
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    
    try {
        $migratelinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        Write-host "Migration of instance $linodeid to region $region initiated. You can check the progress in Cloud manager"
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Resize-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label, 
        [Parameter(Mandatory=$false)][string]$resizetype,
        [Parameter(Mandatory=$false)][switch]$resizedisk,        
        [Parameter(Mandatory=$false)][string]$type       
    )

    $body = @{}

    if(!$resizetype){
        $type = "warm"
    }
    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you want to resize."
    }

    if(!$type){
        return "Please provide a instance type you wish to upgrade to."
    }  

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/resize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    $bodydata = $PSBoundParameters.keys

    foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        if($varname -match "token|resizedisk|resizetype"){
            continue
        }
 

        #$body.Add("type","$type")
        #echo "$varname : $value"
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    if($resizedisk){
        $body.Add("allow_auto_disk_resize",$true)
    }
    if($resizetype){
        $body.Add("migration_type",$resizetype)
    }
    $body = $body | ConvertTo-Json
    echo $body
    try {
        $resizelinodes = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        Write-host "Resizing of instance $linodeid to $type succeeded. You can check the progress in Cloud manager"
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeInstancePassword{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label, 
        [Parameter(Mandatory=$false)][string]$password
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you want to resize."
    }

    if(!$password){
        return "Please provide a new password."
    }  

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/password"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    $body.Add("root_pass","$password")
    $body = $body | ConvertTo-Json
    echo $body
    try {
        $changeinstancepassword = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        Write-host "Changing root password for instance with ID $linodeid succeeded."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label, 
        [Parameter(Mandatory=$false)][string]$password
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you want to rebuild."
    }

    if(!$password){
        return "Please provide a new password."
    }  

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeId/password"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    $body.Add("root_pass","$password")
    $body = $body | ConvertTo-Json
    echo $body
    try {
        $changeinstancepassword = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        Write-host "Changing root password for instance with ID $linodeid succeeded."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Repair-LinodeInstance{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you want to boot to rescue mode."
    }

    if($linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $linodelabel = $instancedata | where {$_.id -eq "$linode"} | select -ExpandProperty label
      

        if($linodeid -ne $id -and $linodelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$linodeid -and $label){
        $instancedata = get-linodeinstance -region "all" 
        $linodeid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/linode/instances/$linodeid/rescue"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
        "content-type"  = "application/json"        
    }

    try {
        $rescuelinodeinstance = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        Write-host "Instance $linodeid booted into rescue mode."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeKernels{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$page = 1, 
        [Parameter(Mandatory=$false)][int]$pagesize = 100                    
    )

    $uri = "https://api.linode.com/v4/linode/kernels?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodekernels = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodekernels.data
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeKernel{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$true)][string]$id 
    )

    $uri = "https://api.linode.com/v4/linode/kernels/$Id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $Linodekernel = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $Linodekernel
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}