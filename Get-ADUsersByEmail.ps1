<#
.SYNOPSIS
    Query Active Directory users by email address and export selected attributes to CSV.

.DESCRIPTION
    Accepts a list of email addresses via pipeline, file path, or -Emails parameter. For each
    email, the script searches AD for matching user(s) and outputs Name, UserPrincipalName,
    SamAccountName and Email to a CSV file (or to stdout).

.NOTES
    Requires the ActiveDirectory PowerShell module (RSAT). Run on a domain-joined machine or
    a machine that can query your Domain Controllers.

.EXAMPLE
    Get-Content .\sample_emails.txt | .\Get-ADUsersByEmail.ps1 -OutFile users.csv

.EXAMPLE
    .\Get-ADUsersByEmail.ps1 -Emails "alice@example.com","bob@example.com" -OutFile users.csv
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    [string[]] $Emails,

    [Parameter(Mandatory=$false)]
    [string] $InputFile,

    [Parameter(Mandatory=$false)]
    [string] $OutFile = "UsersByEmail.csv",

    [Parameter(Mandatory=$false)]
    [switch] $Append
)

begin {
    # Ensure AD module is available
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Error "ActiveDirectory module not found. Install RSAT / Active Directory module and try again."
        return
    }

    Import-Module ActiveDirectory -ErrorAction Stop

    $collected = @()

    if ($InputFile) {
        if (Test-Path $InputFile) {
            try {
                $fileEmails = Get-Content -Path $InputFile -ErrorAction Stop | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }
                if ($fileEmails) { $Emails = @($Emails + $fileEmails) }
            } catch {
                Write-Error "Failed to read input file '$InputFile': $_"
                return
            }
        } else {
            Write-Error "Input file '$InputFile' not found."
            return
        }
    }

}

process {
    if (-not $Emails) { return }

    foreach ($email in $Emails) {
        if (-not $email) { continue }

        # Search for user by mail or userPrincipalName
        try {
            #$filter = "(mail=$email)"
            $users = Get-ADUser -Filter {mail -eq $email} -Properties mail,UserPrincipalName,SamAccountName,Name,Enabled -ErrorAction SilentlyContinue

            if (-not $users) {
                # fallback: search userPrincipalName
                $users = Get-ADUser -Filter {UserPrincipalName -eq $email} -Properties mail,UserPrincipalName,SamAccountName,Name,Enabled -ErrorAction SilentlyContinue
            }

            if ($users) {
                foreach ($u in $users) {
                    $collected += [PSCustomObject]@{
                        Name = $u.Name
                        UserPrincipalName = $u.UserPrincipalName
                        SamAccountName = $u.SamAccountName
                        Enabled = $u.Enabled
                    }
                }
            } else {
                # No user found — include a record noting the missing user
                $collected += [PSCustomObject]@{
                    Name = $null
                    UserPrincipalName = $null
                    SamAccountName = $null
                    Enabled = $null
                    NotFound = $true
                }
            }
        } catch {
            Write-Warning "Error querying AD for '$email': $_"
            $collected += [PSCustomObject]@{
                Name = $null
                UserPrincipalName = $null
                SamAccountName = $null
                Enabled = $null
                Error = $_.Exception.Message
            }
        }
    }
}

end {
    if ($collected.Count -eq 0) {
        Write-Output "No results to export."
        return
    }

    # Choose export behavior
    $exportObjects = $collected | Select-Object Name,UserPrincipalName,SamAccountName,Enabled,NotFound,Error

    if ($PSBoundParameters.ContainsKey('OutFile')) {
        if ($Append -and (Test-Path $OutFile)) {
            $exportObjects | Export-Csv -Path $OutFile -NoTypeInformation -Append
        } else {
            $exportObjects | Export-Csv -Path $OutFile -NoTypeInformation -Force
        }
        Write-Output "Exported $($exportObjects.Count) record(s) to $OutFile"
    } else {
        $exportObjects
    }
}
