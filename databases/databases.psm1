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

function Get-LinodeMySQLDatabases {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )

    $uri = "https://api.linode.com/v4/databases/mysql/instances"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabases = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedMySQLDatabases.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMySQLDatabase {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label        
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    



    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabase = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedMySQLDatabase
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeManagedMySQLDatabase {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [switch]$confirm         
    )

    if(!$instanceid -and !$label){
        return "Please provide a Database ID or Database label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Database label and Database ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please add -confirm flag in order to delete a managed database"
        }
        
        if($confirm){ 
        $LinodeManagedMySQLDatabase = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Managed Database (ID: $instanceID) deleted"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMySQLDatabaseBackups {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [int]$page = 1,
        [int]$pagesize = 100        
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/backups?page=$page&page_size=$pagesize"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabaseBackups = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedMySQLDatabaseBackups.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMySQLDatabaseBackup {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [Parameter(mandatory=$true)]
        [string]$backupId       
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/backups/$backupId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedMySQLDatabaseBackup
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeMySQLDatabaseBackup {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [Parameter(mandatory=$true)]
        [string]$backupId, 
        [switch]$confirm              
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/backups/$backupId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a MySQL Backup"
        }
        if($confirm){
        $RemoveLinodeMySQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "MySQL Backup (ID: $backupID) deleted."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function New-LinodeMySQLDatabaseBackupSnapshot {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [Parameter(mandatory=$true)]
        [string]$backuplabel,        
        [Parameter(mandatory=$false)]
        [string]$target = "primary"          
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceid/backups"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
    }
    
    $body = @{}
    $bodydata = $PSBoundParameters.keys
   
    if($backuplabel){ 
        $body.Add("label", $backuplabel)
        $body.Add("target", $target)
        }
       
    $body = $body | ConvertTo-Json
    try {
        $CreateLinodeMySQLDatabaseBackupSnapshot = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        return "MySQL Backup snapshot created."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMySQLDatabaseCredentials {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label  
    )

    if(!$instanceid -and !$label){
        return "Please provide a Database ID or Database label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/credentials"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabaseCreds = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedMySQLDatabaseCreds
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeMySQLDatabaseCredentials {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label  
    )

    if(!$instanceid -and !$label){
        return "Please provide a Database ID or Database label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/credentials/reset"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabaseCredsreset = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Reset done."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Restore-LinodeMySQLDatabaseBackup {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [Parameter(mandatory=$true)]
        [string]$backupId,
        [switch]$confirm               
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/backups/$backupId/restore"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to restore a MySQL Backup"
        }
        if($confirm){
        $RestoreLinodeMySQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "MySQL Backup (ID: $backupID) restored."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeMySQLDatabaseCertificate {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label        
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    



    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/ssl"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeManagedMySQLDatabasecert = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedMySQLDatabasecert
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Update-LinodeMySQLDatabase {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$instanceid,
        [string]$label,
        [switch]$confirm               
    )

    if(!$instanceid -and !$label){
        return "Please provide a Linode ID or instance label"
    }

    if($instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label

        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }

    if(!$instanceid -and $label){
        $instancedata = Get-LinodeMySQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/databases/mysql/instances/$instanceId/patch"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to patch a MySQL instance"
        }
        if($confirm){
        $RestoreLinodeMySQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "MySQL patching (ID: $backupID) initiated."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}