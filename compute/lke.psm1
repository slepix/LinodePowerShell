function Get-LinodeLKEClusters {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/lke/clusters"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEClusters = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEClusters.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKECluster {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a Key ID or Key label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterid"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKECluster = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKECluster
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeLKECluster {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or Key label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterid"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please add -confirm flag in order to delete an LKE cluster"
        }
        if($confirm){
            $removeLinodeLKECluster = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
            return "LKE cluster $clusterID deleted"
        }

    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeLKEClusterNodes {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or Key label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/$apiversion/lke/clusters/$clusterid/recycle"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please add -confirm flag in order to recycle nodes in your LKE cluster"
        }
        if($confirm){
            $recycleLinodeLKECluster = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
            return "LKE cluster (ID: $clusterID) nodes recycled."
        }

    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeLKECluster {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,
        [Parameter(mandatory=$false)]                                           
        [switch]$kubeconfig,
        [Parameter(mandatory=$false)]                                           
        [switch]$servicetoken                             
    )

    

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    if(!$id -and !$label){
        return "Please provide a LKE ID or Key label."
    }

    if(!$servicetoken -and !$kubeconfig){
        return "Please specify what you want to rebuild. Flags: -kubeconfig or -servicetoken"
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/regenerate"

    $body = @{}
    $bodydata = $PSBoundParameters.keys

    if($servicetoken){ 
        $body.Add("servicetoken", $true)
        }
    if($kubeconfig){ 
            $body.Add("kubeconfig", $true)
        }        

        $body = $body | ConvertTo-Json
    try {
        if(!$confirm){
            return "Please add -confirm flag in order to proceed."
        }
        if($confirm){
        $rebuildlinodelke = Invoke-RestMethod -Uri $uri -Method POST -ContentType 'application/json' -Headers $headers -Body $body
        return "Regeneration for LKE cluster with ID $clusterID done"
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Update-LinodeLKECluster {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [string]$newlabel,        
        [string]$k8sversion,
        [string]$tags,
        [Parameter(mandatory=$false)]                                           
        [switch]$confirm,
        [switch]$hacontrolplane                           
    )

    $headers = @{
        "accept"  = "application/json"     
        "content-type"  = "application/json"             
        "Authorization" = "Bearer $Token"
    }

    if(!$id -and !$label){
        return "Please provide a LKE ID or Key label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }    

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterid"

    $body = @{}
    $control_plane = @{}

    if($tags){ 
        $split = $tags.split(",")
        foreach($tag in $split){
        $body['tags']+=@([string]$tag)
        }
    }

    if ($hacontrolplane) { 
        $control_plane['high_availability'] = [bool]$hacontrolplane
    }
    $body['control_plane'] = $control_plane

    if($newlabel){ 
    $body.Add("label","$newlabel")
    }

    if($k8sversion){ 
        $body.Add("k8s_version","$k8sversion")
    }

    $bodydata = $PSBoundParameters.keys

    foreach($_ in $bodydata){
        $varname = $_
        $value = $PSBoundParameters."$varname"
        if($varname -match "hacontrolplane|k8sversion|tags|token|newlabel|label"){
            continue
        }
        Remove-Variable -name $varname -Force
        New-Variable -Name "$varname" -Value "$value"
        $body.Add("$varname","$value")
        }
     

        $body = $body | ConvertTo-Json
        echo $body

        try {
        if(!$confirm){
            return "Please add -confirm flag in order to proceed."
        }
        if($confirm){
        $updatelinodelke = Invoke-RestMethod -Uri $uri -Method PUT -ContentType 'application/json' -Headers $headers -Body $body
        return $updatelinodelke
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}


function Get-LinodeLKEAPIEndpoint {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/api-endpoints"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEClusterAPIendpoint = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEClusterAPIendpoint.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKEDashboardURL {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/dashboard"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEClusterdashboard = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEClusterdashboard
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKEKubeconfig {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/kubeconfig"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEClusterkubeconfig = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEClusterkubeconfig
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeLKEKubeconfig {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/kubeconfig"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEClusterkubeconfig = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "Kubeconfig for LKE Cluster $clusterID deleted and regenerated."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKENodePools {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/pools"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKENodePools = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKENodePools.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKENodePool {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$poolid,
        [string]$id,
        [string]$label        
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/pools/$poolId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKENodePool = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKENodePool
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeLKENodePool {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$poolid,
        [string]$id,
        [string]$label,
        [switch]$confirm                 
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/pools/$poolId"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKENodePool = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "LKE Cluster(ID: $clusterID) node pool (ID: $poolid) deleted."
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeLKENodePool {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$poolid,
        [string]$id,
        [string]$label,
        [switch]$confirm                 
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/pools/$poolId/recycle"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please provide -confirm flag"
        }
        if($confirm){
        $LinodeLKENodePool = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "LKE Cluster(ID: $clusterID) node pool (ID: $poolid) recycled."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeLKEServiceToken {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [switch]$confirm                 
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterId/servicetoken"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please provide -confirm flag"
        }
        if($confirm){
        $LinodeLKEsvctoken = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "LKE Cluster (ID: $clusterID) service token regenerated."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKEKubernetesVersions {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/lke/versions"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEk8sversions = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEk8sversions.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKEKubernetesVersion {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$version
    )

    $uri = "https://api.linode.com/v4/lke/versions/$version"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEk8sversion = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEk8sversion
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Remove-LinodeLKENode {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$true)]  
        [string]$nodeid,        
        [switch]$confirm                 
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterid/nodes/$nodeid"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please provide -confirm flag"
        }
        if($confirm){
        $LinodeLKEremovenode = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
        return "LKE Cluster (ID: $clusterID) node (ID: $nodeid) deleted."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeLKENode {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$true)]  
        [string]$nodeid,        
        [switch]$confirm                 
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterid/nodes/$nodeid"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        $LinodeLKEnode = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $LinodeLKEnode
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Reset-LinodeLKENode {
    param (
        [string]$apiVersion = "v4",
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$id,
        [string]$label,
        [Parameter(mandatory=$true)]  
        [string]$nodeid,        
        [switch]$confirm                 
    )


    if(!$id -and !$label){
        return "Please provide a LKE ID or LKE label."
    }

    if($id -and $label){
        $clusterdata = Get-LinodeLKEClusters 
        $clusterid = $clusterdata | where {$_.label -eq "$label"} | select -ExpandProperty ID
        $clusterlabel = $clusterdata | where {$_.id -eq "$id"} | select -ExpandProperty label
        if($id -ne $clusterid -and $label -ne $clusterlabel){
            return "LKE label and LKE ID specified do not match!"
        }
    }

    if(!$id -and $label){
        $iddata = Get-LinodeLKEClusters 
        $clusterid = $iddata | where {$_.label -eq "$label"} | select -ExpandProperty ID        
    }

    $uri = "https://api.linode.com/v4/lke/clusters/$clusterid/nodes/$nodeid/recycle"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"        
    }
   
    try {
        if(!$confirm){
            return "Please provide -confirm flag"
        }
        if($confirm){
        $LinodeLKErecycle = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers
        return "LKE Cluster (ID: $clusterID) node (ID: $nodeid) recycled."
        }
    }
    catch {
        $_.ErrorDetails.Message
    }
}