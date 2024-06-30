function Get-LinodeAccount {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodeaccount = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $getlinodeaccount 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Update-LinodeAccount {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$address1,
        [string]$address2,
        [string]$city,
        [string]$company,
        [string]$country,
        [string]$email,
        [string]$firstname,
        [string]$lastname,
        [string]$phone,
        [string]$state,
        [string]$taxid,
        [string]$zip
    )

    $uri = "https://api.linode.com/v4/account"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"  
        "content-type"  = "application/json"      
    }
   
    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($taxid){ 
        $body.Add("tax_id","$taxid")
    }
    if($firstname){ 
        $body.Add("first_name","$firstname")
    }  
    if($lastname){ 
        $body.Add("last_name","$lastname")
        }
    if($address1){ 
            $body.Add("address_1","$address1")
        } 
    if($address2){ 
        $body.Add("address_2","$address2")
        }   
        
        
    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "token|address1|address2|firstname|address2|lastname|taxid"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    echo $body
    try {
        $setlinodeaccount = Invoke-RestMethod -Uri $uri -Method PUT -Headers $headers
        return $setlinodeaccount 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountServices {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$region 
    )

    $uri = "https://api.linode.com/v4/account/availability/$region"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountServices = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountServices 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeServiceAvailability {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1, 
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/account/availability?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeServiceAvailability = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeServiceAvailability.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMaintenances {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account/maintenance"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeMaintenances = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        $data = $LinodeMaintenances.data
        if(!$data){
            return "No planned maintenances."
        }
        if($data){
            return $data
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeNotifications {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account/notifications"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeNotifications = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        $data = $LinodeNotifications.data
        if(!$data){
            return "No notifications."
        }
        if($data){
            return $data
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountSettings {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account/settings"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountSettings = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountSettings
        # if(!$data){
        #     return "No notifications."
        # }
        # if($data){
        #     return $data
        # }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeTransferUsage {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account/transfer"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeTransferUsage = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeTransferUsage
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeUserProfile {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/profile"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeUserProfile = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeUserProfile
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeEnrolledBetaPrograms {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account/betas"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeUserbetprograms = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeUserbetprograms.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeEnrolledBetaProgram {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$id
    )

    $uri = "https://api.linode.com/v4/account/betas/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeUserbetprogram = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeUserbetprogram
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Join-LinodeBetaProgram {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$id
    )

    $uri = "https://api.linode.com/v4/account/betas"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json" 
        "content-type"  = "application/json"       
    }
    $body = @{}
    $body.Add("id","$id")
    $body = $body | ConvertTo-Json
    try {
        $enrollLinodeUserbetprogram = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        return "Enrolled in $id"
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function Get-LinodeAccountUsers {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/account/users?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountUsers = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountUsers.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountUser {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$username
    )

    $uri = "https://api.linode.com/v4/account/users/$username"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountUser = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountUser
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function New-LinodeAccountUser {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]
        [switch]$restricted,        
        [Parameter(mandatory=$true)]                                           
        [string]$email,
        [Parameter(mandatory=$true)]                                           
        [string]$username        
    )

    $uri = "https://api.linode.com/v4/account/users"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
        "accept"  = "application/json"        
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys
    if($restricted){
        $body.Add("restricted", $true)
    }

    foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "restricted|token"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    try {
        $newlinodeaccountuser = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
        return $newlinodeaccountuser
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeAccountUser {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$username,
        [switch]$confirm
    )

    $uri = "https://api.linode.com/v4/account/users/$username"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please use -confirm switch in order to delete a user"
        }
        if($confirm){ 
        $RemoveLinodeAccountUser = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "User $username deleted"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Update-LinodeAccountUser {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]
        [switch]$restricted,        
        [Parameter(mandatory=$false)]                                           
        [string]$email,
        [Parameter(mandatory=$false)]                                           
        [string]$username,
        [Parameter(mandatory=$false)]                                           
        [string]$newusername                 
    )

    $uri = "https://api.linode.com/$apiVersion/account/users/$username"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/json"
        "accept"  = "application/json"        
    }

    $body = @{}
    $bodydata = $PSBoundParameters.keys
    if($restricted){
        $body.Add("restricted", $true)
    }

    if(!$restricted){
        $body.Add("restricted", $false)
    }

    if($newusername){
        $body.Add("username", $newusername)
    }

    foreach($_ in $bodydata){

        $varname = $_
        $value = $PSBoundParameters."$varname"
        #echo "$varname : $value"
        if($varname -match "username|restricted|token"){
            continue
        }

        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
    }
    $body = $body | ConvertTo-Json
    try {
        $newlinodeaccountuser = Invoke-RestMethod -Uri $uri -Method PUT -Headers $headers -Body $body
        return $newlinodeaccountuser
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountUserGrants {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$username
    )

    $uri = "https://api.linode.com/v4/account/users/$username/grants"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountUserGrants = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        if(!$LinodeAccountUserGrants){
            return "All grants are assigned to this account"
        }
        if($LinodeAccountUserGrants){
            return $LinodeAccountUserGrants
        }
        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountInvoices {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/account/invoices?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountInvoices = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountInvoices.data

        
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountInvoice {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]
        [string]$id

    )

    $uri = "https://api.linode.com/v4/account/invoices/$Id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountInvoice = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountInvoice
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountInvoiceItems {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]
        [string]$id,
        [int]$page = 1,
        [int]$pagesize = 100

    )

    $uri = "https://api.linode.com/v4/account/invoices/$Id/items?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountInvoiceitems = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountInvoiceitems.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeUserLogins {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/account/logins"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeUserLogins = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeUserLogins.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeAccountLogin {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]        
        [string]$id
    )

    $uri = "https://api.linode.com/v4/account/logins/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeAccountLogins = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeAccountLogins
    }
    catch {
        $_.ErrorDetails.Message
    }
}