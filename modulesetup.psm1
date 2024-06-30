function Connect-LinodeAccount{
    Write-host ""
    Write-host "--- Welcome to Linode Powershell Module configuration wizard! ---"
    Write-host ""
    Write-host -ForegroundColor Green "In order to proceed, you will need to create a Linode API token by going to this page:"
    Write-host ""
    Write-host -ForegroundColor Yellow "--- https://cloud.linode.com/profile/tokens ---"
    Write-host ""
    Write-host "Token needs to have 'Read/Write' permissions on the entire account in order to get full functionality of this module." 
    Write-host "You are however free to limit the token as it suits your security and usage needs."
    Write-host ""

    $body = @{}
    $configbody = @{}
    $usrprofile = Read-Host "Enter profile name. This is useful if you want to use multiple Linode accounts"
    while(!$usrprofile){
        echo "Profile name is mandatory"
        $usrprofile = Read-Host "Enter profile name. This is useful if you want to use multiple Linode accounts"
    }  
    $encrypted = Read-Host "Do you wish to encrypt the token which will be saved in the configuration file?
        This is the RECOMMENDED option, but the drawback is that you cannot manually edit the credentials file (Y/N)"
    
    while($encrypted -notmatch "Y|N"){
            $encrypted = Read-Host "Do you wish to encrypt the token which will be saved in the configuration file?
            This is the RECOMMENDED option, but the drawback is that you cannot manually edit the credentials file (Y/N)"
        }          
    if($encrypted -eq "Y"){
        $enclinodetoken = Read-Host "Enter Linode API Token" -AsSecureString | ConvertFrom-SecureString
        $body.Add("linodetoken","$enclinodetoken")
        $body.Add("encrypted", $true)
    }

    if($encrypted -eq "N"){
        $linodetoken = Read-Host "Enter Linode API Token"
        $body.Add("linodetoken","$linodetoken")
        $body.Add("encrypted", $false)

    }
    if($encrypted -notmatch "N|Y"){
        return "Only Y or N are allowed"
    }    

    $homepath = "$HOME\.LinodePSModule\"

    if(!$configurationpath){
        $configurationpath = $homepath
    }

    $configtest = Test-Path $configurationpath

    if(!$configtest){
        $makedir = New-item -ItemType Directory -path $configurationpath
    }

    $defaultregion = Read-Host "Default region (leave empty for none)"
    
    if($defaultregion){
        $body.Add("region","$defaultregion")
    }
    $body.Add("profile_id","$usrprofile")
    $body = $body | ConvertTo-Json
    $writeprofile = New-item -path $configurationpath\$usrprofile-profile.json -value $body -force
    $configbody.Add("profile_folder","$configurationpath")
    $configbody.Add("current_profile","$usrprofile")
    $configbody = $configbody | ConvertTo-Json
    $writeconfig = New-item -path $homepath\config.json -value $configbody -force
    $setprofile = $usrprofile
    Write-host -ForegroundColor Green "Profile added and stored in $configurationpath. Go get Akamaized!"
    Set-LinodeProviderProfile -profile $setprofile
}

function Set-LinodeProviderProfile {
    param (
    [Parameter(mandatory=$true)]                                           
    [string]$profile
    )
    $homepath = "$HOME\.LinodePSModule\"
    $rootconfig = gc $homepath\config.json | convertfrom-json 
    $profilefolder = $rootconfig | select -ExpandProperty profile_folder
    #$profile = $rootconfig | select -ExpandProperty current_profile
    $profiletest = test-path $profilefolder\$profile-profile.json
    if(!$profiletest){
        Write-host -ForegroundColor Red "Profile $profile not found!"
        Write-host ""
        Write-host "Currently configured profiles:"
        return Get-LinodeProviderProfiles
    }

    $profiledata = gc $homepath\$profile-profile.json | ConvertFrom-Json
    $encrypted = $profiledata | select -expand encrypted

    $token = $profiledata | select -expandproperty linodetoken
    if(!$token){
        return "Token not found for $profile profile. Please run Connect-LinodeAccount to fix the profile."
    }

    if($encrypted){
        $token = $profiledata | select -expandproperty linodetoken | ConvertTo-SecureString
        $global:linodetoken = (New-Object PSCredential 0, $token).GetNetworkCredential().Password
        $rootconfig.current_profile = "$profile"
        $rootconfig = $rootconfig | ConvertTo-Json
        $writeconfig = New-item -path $homepath\config.json -value $rootconfig -force
        return "Profile $profile loaded"
    }
    if(!$encrypted){
        $global:linodetoken = $profiledata | select -expandproperty linodetoken
        $rootconfig.current_profile = "$profile"
        $rootconfig = $rootconfig | ConvertTo-Json
        $writeconfig = New-item -path $homepath\config.json -value $rootconfig -force
        return "Profile $profile loaded"
        }
}

function Get-LinodeProviderProfiles {
    $homepath = "$HOME\.LinodePSModule\"
    $lprofiles = dir $homepath\*-profile.json | select -ExpandProperty Name
    foreach($entry in $lprofiles){
        $split = $entry -split '-profile.json'
        $lprofilelist = $split[0]
        echo $lprofilelist
    }
}

function Remove-LinodeProviderProfile {
    param (    
    [Parameter(mandatory=$false)]                                           
    [switch]$confirm,
    [Parameter(mandatory=$true)]                                           
    [string]$profile
    )
    $homepath = "$HOME\.LinodePSModule\"
    $rootconfig = gc $homepath\config.json | convertfrom-json 
    $profilefolder = $rootconfig | select -ExpandProperty profile_folder
    
    $profiletest = test-path $profilefolder\$profile-profile.json
    if(!$profiletest){
        return "Profile $profile not found"
    }
    if(!$confirm){
        return "Please use -confirm flag in order to delete a Linode Provider profile"
    }
    if($confirm){
        Remove-item $profilefolder\$profile-profile.json -Force
        return "Profile $profile deleted"
    }
}


function Get-LinodeProviderCurrentProfile {
    $homepath = "$HOME\.LinodePSModule\"
    $rootconfig = gc $homepath\config.json | convertfrom-json 
    $currentprofile = $rootconfig | select -ExpandProperty current_profile
    return $currentprofile
}