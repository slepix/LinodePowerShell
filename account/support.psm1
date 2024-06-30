function Get-LinodeSupportTickets {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/support/tickets?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodeaccountsupporttickets = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $getlinodeaccountsupporttickets.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeSupportTicket {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [int]$ticketid

    )

    $uri = "https://api.linode.com/v4/support/tickets/$ticketId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodeaccountsupportticket = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $getlinodeaccountsupportticket 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Close-LinodeSupportTicket {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [int]$ticketid

    )

    $uri = "https://api.linode.com/v4/support/tickets/$ticketId/close"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $closelinodeaccountsupportticket = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Ticket $ticketID closed" 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeSupportTicketReplies {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$false)]                                           
        [string]$ticketid,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/support/tickets/$ticketId/replies?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $getlinodeaccountsupportticketsr = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $getlinodeaccountsupportticketsr.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}