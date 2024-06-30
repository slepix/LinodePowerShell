$homepath = "$HOME\.LinodePSModule\"
$configcheck = Test-path $homepath\config.json
if(!$configcheck){
    Write-host -ForegroundColor Red "There are no configured profiles. Please run 'Connect-LinodeAccount' command to get started."
}
if($configcheck){
    $defaultproviderprofile = (gc $homepath\config.json | ConvertFrom-Json).current_profile
    $profileload = Set-LinodeProviderProfile -profile $defaultproviderprofile
    # Write-host -ForegroundColor Green "Profile '$defaultproviderprofile' loaded." 
    Write-host $profileload
    Write-host -ForegroundColor Yellow "You can switch profiles using 'Set-LinodeProviderProfile -profile ProfileName' command"
}