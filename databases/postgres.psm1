function Get-LinodePostgreSQLDatabases {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [int]$page = 1,
        [int]$pagesize = 100
    )
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances?page=$page&page_size=$pagesize"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabases = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedPostgreSQLDatabases.data 
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Get-LinodePostgreSQLDatabase {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabase = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedPostgreSQLDatabase
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Remove-LinodeManagedPostgreSQLDatabase {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Database label and Database ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        if(!$confirm){
            return "Please add -confirm flag in order to delete a managed database"
        }
        
        if($confirm){ 
        $LinodeManagedPostgreSQLDatabase = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Managed Database (ID: $instanceID) deleted"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Get-LinodePostgreSQLDatabaseBackups {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/backups?page=$page&page_size=$pagesize"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabaseBackups = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedPostgreSQLDatabaseBackups.data
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Get-LinodePostgreSQLDatabaseBackup {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/backups/$backupId"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedPostgreSQLDatabaseBackup
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Remove-LinodePostgreSQLDatabaseBackup {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/backups/$backupId"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to delete a PostgreSQL Backup"
        }
        if($confirm){
        $RemoveLinodePostgreSQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "PostgreSQL Backup (ID: $backupID) deleted."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function New-LinodePostgreSQLDatabaseBackupSnapshot {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceid = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceid/backups"
    
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
        $CreateLinodePostgreSQLDatabaseBackupSnapshot = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -body $body
        return "PostgreSQL Backup snapshot created."
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Get-LinodePostgreSQLDatabaseCredentials {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/credentials"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabaseCreds = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedPostgreSQLDatabaseCreds
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Reset-LinodePostgreSQLDatabaseCredentials {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/credentials/reset"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabaseCredsreset = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "Reset done."
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Restore-LinodePostgreSQLDatabaseBackup {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/backups/$backupId/restore"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to restore a PostgreSQL Backup"
        }
        if($confirm){
        $RestoreLinodePostgreSQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "PostgreSQL Backup (ID: $backupID) restored."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Get-LinodePostgreSQLDatabaseCertificate {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/ssl"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        $LinodeManagedPostgreSQLDatabasecert = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeManagedPostgreSQLDatabasecert
    }
    catch {
        $_.ErrorDetails.Message
    }
    }
    
    function Update-LinodePostgreSQLDatabase {
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
        $instancedata = Get-LinodePostgreSQLDatabases
        $id = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $instancelabel = $instancedata | where {$_.id -eq "$instanceid"} | select -ExpandProperty label
    
        if($instanceid -ne $id -and $instancelabel -ne $label){
            return "Linode label and Linode ID specified do not match!"
        }
    }
    
    if(!$instanceid -and $label){
        $instancedata = Get-LinodePostgreSQLDatabases
        $instanceId = $instancedata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    
    
    $uri = "https://api.linode.com/v4/databases/postgresql/instances/$instanceId/patch"
    
    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
    
    try {
        if(!$confirm){
            return "Please use -confirm flag in order to patch a PostgreSQL instance"
        }
        if($confirm){
        $UpdateLinodePostgreSQLDatabaseBackup = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "PostgreSQL patching initiated."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
    }