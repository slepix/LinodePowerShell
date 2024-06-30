function New-LinodeNodeBalancer {
    param (
        [int]$firewallid,
        [string]$apiVersion,
        [Parameter(mandatory=$true)]        
        [string]$label,         
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]
        [string]$region        
    )

    $uri = " https://api.linode.com/v4/nodebalancers"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
        "accept"  = "application/json"        
    }

    if(!$label){
        Write-host -ForegroundColor Red "Please provide Node Balancer label."
    }
    if(!$region){
        Write-host -ForegroundColor Red "Please provide Node Balancer region."
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($firewallid){
        $body.Add("firewall_id","$firewallid")
    }

    foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "firewallid|token"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    echo $body
    try {
        $newnodebalancer = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
        return $newnodebalancer.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNodeBalancers{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/nodebalancers?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listnodebalancers = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listnodebalancers.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNodeBalancer{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$id,
        [string]$label
    )

    if($label){
        $id = Get-LinodeNodeBalancers -token $token | where {$_.label -eq "$label"} | select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/nodebalancers/$id"



    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listnodebalancer = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listnodebalancer   
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeNodeBalancer{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$id,
        [switch]$confirm,
        [string]$label
    )

    if(!$confirm){
        Write-host "Please use -confirm flag to delete a NodeBlancer."
    }

    if(!$label -and !$id){
        return "Please provide NodeBalancer ID or Label"
    }

    if($label){
        $id = Get-LinodeNodeBalancers -token $token | where {$_.label -eq "$label"} | select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/nodebalancers/$id"



    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    if($confirm){ 
        try {
            $removenodebalancer = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            Write-host "NodeBalancer sucessfully deleted" 
            return $removenodebalancer
        }
        catch {
            $_.ErrorDetails.Message
        }
    }
}

function Get-LinodesNodeBalancer{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list Nodebalancers from."
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

    $uri = "https://api.linode.com/v4/linode/instances/$linodeid/nodebalancers"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $LinodeNodeBalancer = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        $data = $LinodeNodeBalancer.data
        if(!$data){
            return "None"
        }
        if($data){
            return $LinodeNodeBalancer
        }
         
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNodeBalancersConfigs{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    if(!$label -and !$id){
        return "Please provide NodeBalancer ID or Label"
    }

    if($label){
        $nodeBalancerId = Get-LinodeNodeBalancers -token $token | where {$_.label -eq "$label"} | select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/nodebalancers/$nodeBalancerId/configs?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listnodebalancersconfigs = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listnodebalancersconfigs.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNodeBalancerConfig{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id,
        [Parameter(mandatory=$true)]         
        [string]$configid,        
        [int]$page = 1,
        [int]$pagesize = 100
    )

    if(!$label -and !$id){
        return "Please provide NodeBalancer ID or Label"
    }

    if($label){
        $nodeBalancerId = Get-LinodeNodeBalancers -token $token | where {$_.label -eq "$label"} | select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/nodebalancers/$nodeBalancerId/configs/$configId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listnodebalancersconfig = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listnodebalancersconfig  
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNodeBalancerFirewall{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$label,
        [string]$id
    )

    if(!$label -and !$id){
        return "Please provide NodeBalancer ID or Label"
    }

    if($label){
        $nodeBalancerId = Get-LinodeNodeBalancers -token $token | where {$_.label -eq "$label"} | select -ExpandProperty id
    }

    $uri = "https://api.linode.com/v4/nodebalancers/$nodeBalancerId/firewalls"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listnodebalancersfw = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listnodebalancersfw.data  
    }
    catch {
        $_.ErrorDetails.Message
    }
}