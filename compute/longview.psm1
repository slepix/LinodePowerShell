function Get-LinodeLongViewClients {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )
    
    $uri = "https://api.linode.com/$apiVersion/longview/clients?page=$page&page_size=$pagesize"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeLongViewClients = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLongViewClients.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
    }    


function Get-LinodeLongviewClient {
        param (
            [string]$apiVersion = "v4",
            [Parameter(mandatory=$false)]                                           
            [string]$token = $linodetoken,
            [string]$id,
            [string]$label        
        )
        
        if(!$id -and !$label){
            return "Please provide a Linode Longview ID or label"
        }
        
        if($id -and $label){
            $instancedata = Get-LinodeLongviewClients
            $lid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
            $instancelabel = $instancedata | where {$_.id -eq "$id"} | select -ExpandProperty label
        
            if($lid -ne $id -and $instancelabel -ne $label){
                return "Linode LongView label and Linode LongView ID specified do not match!"
            }
        }
        
        if(!$id -and $label){
            $instancedata = Get-LinodeLongviewClients
            $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
        }    
        
        if(!$id){
            return "Client with label $label not found."
        }
        
        
        $uri = "https://api.linode.com/v4/longview/clients/$id"
        
        $headers = @{
            "Authorization" = "Bearer $Token"
            "accept"  = "application/json"        
        }
        
        try {
            $LinodeLongviewClient = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            return $LinodeLongviewClient
        }
        catch {
            $_.ErrorDetails.Message
        }
}    

function New-LinodeLongviewClient {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label        
    )
    
    if(!$label){
        return "Please provide a label for the new Longview client"
    }
    
    $uri = "https://api.linode.com/$apiVersion/longview/clients/"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"   
        "content-type"  = "application/json"        
    }

    $body = @{}
    $body.Add("label","$label")
    $body = $body | ConvertTo-json      
   
    try {
        $newLinodeLongviewClient = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
        return $newLinodeLongviewClient
    }
    catch {
        $_.ErrorDetails.Message
    }
}    

function Remove-LinodeLongviewClient{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [switch]$confirm
    )

    if(!$confirm){
        echo "You will need to use -confirm flag in order to delete a Longview client"
    }

    if(!$label -and !$id){
        return "You need to provide a Longview Client ID or label"
    }

    if($label -and !$id){
        $id = Get-LinodeLongViewClients | where {$_.label -eq $label} | Select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/longview/clients/$Id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    if($confirm){
    try {
        $removelinodelongviewclient = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Longview client $label deleted"
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
}

function Get-LinodeLongViewPlan {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )
    
    $uri = "https://api.linode.com/$apiVersion/longview/plan"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeLongViewplan = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLongViewplan 
    }
    catch {
        $_.ErrorDetails.Message
    }
}   

function Get-LinodeLongViewSubscriptions {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )
    
    $uri = "https://api.linode.com/$apiVersion/longview/subscriptions?page=$page&page_size=$pagesize"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeLongViewsubscriptions = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLongViewsubscriptions.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}   

function Get-LinodeLongViewSubscription {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id
    )

    if(!$id){
        return "Please provide a subscription ID"
    }
    
    $uri = "https://api.linode.com/$apiVersion/longview/subscriptions/$id"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeLongViewsubscription = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLongViewsubscription
    }
    catch {
        $_.ErrorDetails.Message
    }
}  