function Get-LinodePaymentMethods {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1, 
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/$apiVersion/account/payment-methods?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodePaymentMethods = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodePaymentMethods.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodePaymentMethod {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]   
        [int]$id 
    )

    $uri = "https://api.linode.com/$apiVersion/account/payment-methods/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodePaymentMethod = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodePaymentMethod
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function Set-LinodeDefaultPaymentMethod {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]   
        [int]$id 
    )

    $uri = "https://api.linode.com/$apiVersion/account/payment-methods/$id/make-default"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodedefaultPaymentMethod = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Default payment method set."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodePaymentMethod {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]   
        [int]$id,
        [switch]$confirm  
    )

    $uri = "https://api.linode.com/$apiVersion/account/payment-methods/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    if(!$confirm){
        return "Please use -confirm flag in order to remove a payment method"
    }

    try {
        $removeLinodePaymentMethod = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Payment method (ID: $id) removed."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodePayments {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1, 
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/$apiVersion/account/payments?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodePayments = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodePayments.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodePayment {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [int]$id = 1
    )

    $uri = "https://api.linode.com/v4/account/payments/$id"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodePayment = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodePayment
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function New-LinodePayment {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [int]$id,
        [Parameter(mandatory=$true)] 
        [string]$amount,
        [Parameter(mandatory=$true)] 
        [switch]$confirm
    )

    $uri = "https://api.linode.com/v4/account/payments"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"   
        "content-type"  = "application/json"       
    }

    $body = @{}
    $body.Add("payment_method_id",$id)
    $body.Add("usd","$amount")

    $body = $body | ConvertTo-Json
  
    try {
        $MakeLinodePayment = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        return $MakeLinodePayment
    }
    catch {
        $_.ErrorDetails.Message
    }
}