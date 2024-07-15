function Get-LinodeRegions{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken
    )

    $uri = "https://api.linode.com/v4/regions"

    $headers = @{
        "Authorization" = "Bearer $token"
        "accept"  = "application/json"
    }
    try {
        $getlinoderegions = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
        return $getlinoderegions.data
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeRegionAvailability{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [string]$page = "1"
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    if($page -eq "all"){
        $pagesuri = "https://api.linode.com/v4/regions/availability"
        $LinodeRegionPages = (Invoke-RestMethod -Uri $pagesuri -Method GET -Headers $headers).pages
        echo "Pages: $LinodeRegionPages"
        $pagecount = 1
        $alldata = @()

        while($pagecount -le $LinodeRegionPages){
            $datauri = "https://api.linode.com/v4/regions/availability?page=$pagecount"
            try {
            $data = (Invoke-RestMethod -Uri $datauri -Method GET -Headers $headers).data
            #$alldata.add("$data")
            return $data
            }
            catch {
                $_.ErrorDetails.Message
            }
            $pagecount++
        }
    }

    if($page -ne "all"){ 
        Echo "Checking page $page"
        $uri = "https://api.linode.com/v4/regions/availability?page=$page"
        try {
            $LinodeRegionsAvailability = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $LinodeRegionsAvailability.data
        }
        catch {
            $_.ErrorDetails.Message
        }
    }
 }

 function Get-LinodeRegion{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$linodetoken,
        [Parameter(mandatory=$true)]                                           
        [string]$region
    )

    $uri = "https://api.linode.com/v4/regions/$region"
    #echo $uri
    $headers = @{
        "Authorization" = "Bearer $linodetoken"
        "accept"  = "application/json"
    }
    try {
        $getlinoderegion = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
        return $getlinoderegion 
    }
    catch {
        $_.ErrorDetails.Message
    }
}

function Get-LinodeRegionAvailability{
    param (
        [Parameter(mandatory=$false)]                                           
        [string]$token = $linodetoken,
        [Parameter(mandatory=$true)] 
        [string]$region,
        [string]$page = 1
    )

    $headers = @{
        "Authorization" = "Bearer $Token"
        "accept"  = "application/json"
    }

    $uri = "https://api.linode.com/v4/regions/$region/availability?page=$page"
        try {
            $LinodeRegionAvailability = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers # -body $body
            return $LinodeRegionAvailability
        }
        catch {
            $_.ErrorDetails.Message
        }
}
