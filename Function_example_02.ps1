<#
2024-08-29 Thu. 2:01p.
I'm trying to learn how to write functions in PowerShell.  Using one of the many great posts from Ed Wilson, Microsoft Scripting Guy, Doctor Scripto!
https://devblogs.microsoft.com/scripting/convert-a-script-to-a-powershell-function/
To see some of the additional content from the web page, please open "Function_example_01.ps1".
#>

Function Convert-AsciiEncoding {
	  <#
	   .Synopsis
	    This function reads an ascii text string, and coverts it to ascii
	    numbers. 
	
	   .Description
	    This function reads an ascii text string, and converts it to ascii
	    numeric values. I accepts input from a text file, and outputs a
	    text file as well.
	
	   .Example
	    Convert-AsciiEncoding -path C:\fso\Simple.txt -filepath c:\fso\encodeSimple.txt -encode
	    Reads a text file, and encodes the output into an ASCII values
	
	   .Example
	    Convert-AsciiEncoding -path C:\fso\encodeSimple.txt -filepath c:\fso\decodeSimple.txt -decode
	    Reads a text file containing ascii numeric values, and converts
	    them to text. Writes the output to a text file
	
	   .Parameter Path
	    The path to the source file - either a text file to encode, or an
	    ascii value encoded file.
	
	   .Parameter FilePath
	    The path to the output file
	
	   .Parameter Encode
	    Causes the function to read the input file and encode the output file
	
	   .Parameter Decode
	    Causes the function to read the encoded input file and output a decoded
	    text file
	
	   .Inputs
	    [System.String]
	
	   .Outputs
	    [System.IO.FileInfo]
	
	   .Notes
	    NAME:  Convert-AsciiEncoding
	    AUTHOR: ed wilson, msft
	    LASTEDIT: 10/01/2014 14:21:22
	    KEYWORDS: Function, Scripting Techniques, Text Files, Hash Tables
	    HSG: HSG-10-9-2014
	
	   .Link
	    https://www.ScriptingGuys.com
	
	 #Requires -Version 3.0
	 #>

	[cmdletbinding()]
	Param(
		[string]$path,
		[string]$filepath,
		[switch]$encode,
		[switch]$decode)

#region CreateHashTables
Write-Verbose "Creating Hash Tables"
$asciiFirst = New-Object System.Collections.Hashtable
$ltrFirst = New-Object System.Collections.Hashtable
0..255 | Foreach-Object {
    $asciiFirst.Add($_,([char]$_).ToString())
}
ForEach ($k in $asciiFirst.Keys) {
    $ltrFirst.add($asciiFirst[$k],$k)
}
Write-Verbose "Hash tables complete"
#endregion

#region getcontent
Write-Verbose "Reading input file from $path"
if (Test-path $path) {
    $txtIN = Get-Content $path -Encoding Ascii
} else {
    "Unable to find $path"
    return
}
#endregion

#region encode
If ($encode) {
    Write-Verbose "Encoding input file"
    $coded = $txtIN.ToCharArray() |
        ForEach-Object { $ltrFirst["$_"] }
    Write-Verbose "Encoding complete: `r`n $coded"
    Write-Verbose "Writing to $filepath"
    Out-file -FilePath $filepath -inputobject $coded -Encoding ascii
}
#endregion

#region decode
If($decode) {
	Write-Verbose "Decoding $path"
	$decoded = $txtIN |
		ForEach-Object { $asciiFirst[[int32]$_] }
	$decoded = $decoded -join ''
	Write-Verbose "Decoding complete: `r`n $decoded"
	Write-Verbose "Writing to $filepath"
	$decoded | Out-file -FilePath $filepath -Encoding ascii
}
#endregion

} #end function Convert-AsciiEncoding

