function Get-LinodeVolumes{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(Mandatory=$false)][int]$linodeid,      
        [Parameter(Mandatory=$false)][string]$label
    )

    $body = @{}

    if(!$linodeid -and !$label){
        return "Please provide a Linode ID or instance label you list volumes from."
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

    $uri = "https://api.linode.com/v4/linode/instances/$linodeid/volumes?page=1&page_size=100"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }
    try {
        $listlinodevolumes = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
        return $listlinodevolumes.data    
    }
    catch {
        $_.ErrorDetails.Message
    }
}