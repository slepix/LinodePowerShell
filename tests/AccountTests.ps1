Describe 'Linode Account features' {
    It "Get Linode Account details" {
        $LinodeAccount = Get-LinodeAccount
        $email = $LinodeAccount.email
        $email | Should -Not -Be $null
    }

    It "Get Linode Account Services" {
        $LinodeAccountsvc = Get-LinodeAccountServices -region nl-ams
        $LinodeAccountsvc.available | Should -Not -Be $null
    }

    It "Get Linode Account Service Availability" {
        $LinodeAccountsvc = Get-LinodeServiceAvailability
        $LinodeAccountsvc.region | Should -Not -Be $null
    }

    It "Get Linode Maintenances" {
        $LinodeAccountmntnc = Get-LinodeMaintenances
        $LinodeAccountmntnc | Should -Not -Be $null
    }

    It "Get Linode Notifications" {
        $Linodenotifications = Get-LinodeNotifications
        if($Linodenotifications -eq "No notifications."){
            $data = $true
        }
        $check = $Linodenotifications.label
        if($check){
        $data = $true
        }
        $data | Should -Be $True
    }

    It "Get-LinodeAccountSettings" {
        $Linodenotifications = Get-LinodeAccountSettings
        $Linodenotifications.managed | Should -Not -Be $null
    }

    It "Get-LinodeTransferUsage" {
        $LinodeTransferUsage = Get-LinodeTransferUsage
        $LinodeTransferUsage.region_transfers | Should -Not -Be $null
    }

    It "Get-LinodeUserProfile" {
        $LinodeTransferUsage = Get-LinodeUserProfile
        $LinodeTransferUsage.uid | Should -Not -Be $null
    }

    It "Get-LinodeAccountUsers" {
        $LinodeAccountUsers = Get-LinodeAccountUsers
        $LinodeAccountUsers.username | Should -Not -Be $null
    }





}