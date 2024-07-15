function Get-LinodeDatabases {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/databases/instances?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedDatabases = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedDatabases.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDatabaseEngines {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/databases/engines"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedDatabaseEngines = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedDatabaseEngines.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDatabaseEngine {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$engineid,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/databases/engines/$engineId" + "?page=$page&page_size=$pagesize"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedDatabaseEngine = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedDatabaseEngine
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeDatabases {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/databases/instances?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedDatabases = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedDatabases.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}