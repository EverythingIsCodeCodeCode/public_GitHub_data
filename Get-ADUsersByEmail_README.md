Get-ADUsersByEmail.ps1
======================

What it does
------------

This PowerShell script accepts a list of email addresses (from pipeline, a file, or the -Emails parameter), queries Active Directory for matching user accounts, and outputs a CSV containing Name, UserPrincipalName, SamAccountName and Enabled (account active state). Missing users are still listed with a NotFound flag.

Requirements
------------

- A domain-joined machine or network access to your domain controllers.
- The ActiveDirectory PowerShell module (part of RSAT). Import succeeds automatically if installed.

Usage examples
--------------

1) From a text file (one email per line):

```powershell
Get-Content .\sample_emails.txt | .\Get-ADUsersByEmail.ps1 -OutFile users.csv
```

2) Passing emails as parameters:

```powershell
.\Get-ADUsersByEmail.ps1 -Emails "alice@example.com","bob@example.com" -OutFile users.csv
```

3) Read from file using -InputFile parameter:

```powershell
.\Get-ADUsersByEmail.ps1 -InputFile .\sample_emails.txt -OutFile users.csv
```

Notes
-----

- The script will attempt to find users by the AD 'mail' attribute first, then fall back to UserPrincipalName.
- If no output file is specified, results are written to the pipeline as objects.
- When running remotely or without RSAT, install the RSAT/Active Directory module appropriate for your Windows version.
