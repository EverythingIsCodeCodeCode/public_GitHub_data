<#
2024-08-29 Thu. 2:01p.
I'm trying to learn how to write functions in PowerShell.  Using one of the many great posts from Ed Wilson, Microsoft Scripting Guy, Doctor Scripto!
https://devblogs.microsoft.com/scripting/convert-a-script-to-a-powershell-function/
To see less of the additional content from the web page, please open "Function_example_02.ps1".
#>

<#
Convert a Script to a PowerShell Function
Doctor Scripto
October 9th, 2014 Thu.
0
Summary: Microsoft Scripting Guy, Ed Wilson, talks about converting a script to a Windows PowerShell function.

Microsoft Scripting Guy, Ed Wilson, is here. When I have a script that I think I will use more than once or twice, it often makes sense for me to convert it to a function. If it is something I will use on a regular basis, I might add that function to my Windows PowerShell profile, or I might put it into a module so that it is easily accessible.

In fact, one of my major challenges (having written nearly 1,500 Windows PowerShell scripts) is finding and reusing scripts I wrote several years ago. Functions and modules make script reuse much more practical. For example, I think I might enjoy playing around with my ASCII encode/decode script, so it makes sense to turn it into a function.

     Note  This post is an extension of my previous posts on the subject. You should read the following posts before you read today’s:

    Automatically Create Hash Tables and Reverse Values
	https://devblogs.microsoft.com/scripting/automatically-create-hash-tables-and-reverse-values/
    Converting Words to ASCII Numbers and Back with 
	https://devblogs.microsoft.com/scripting/converting-words-to-ascii-numbers-and-back-with-powershell/
    Extend the Encode/Decode PowerShell Script
	https://devblogs.microsoft.com/b/heyscriptingguy/archive/2014/10/08/extend-the-encode-decode-powershell-script.aspx

Add the function stuff…
The first thing to do is to add the function stuff. This includes:
        The function keyword
        The script block
        Parameters
    Help

After using the Function keyword and assigning a name to my function, I added comment-based Help. There are three ways to do this:
    Use the Cmdlet Advanced Function or Cmdlet Advanced Function (Complete) snippet from the Windows PowerShell ISE
    Hand code it
    Use the Add-Help function from my Windows PowerShell ISE profile

I used the last option because I have it pretty well customized for my needs. Here is that portion of the script:
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

<#
The next thing I do is add the [cmdletbinding()] attribute. This goes after the comment-based Help, but before the Parameters section. This gives me easy access to things like common parameters. Here is the [cmdletbinding()] attribute and the Parameter section of the script:
#>

	[cmdletbinding()]
	Param(
		[string]$path,
		[string]$filepath,
		[switch]$encode,
		[switch]$decode)

<#
A note about regions in the ISE
One of the things I like about the Windows PowerShell ISE as it exists in Windows PowerShell 4.0 is that it supports regions. (Actually, I think this was added in Windows PowerShell 3.0.) This means I can add my own regions by using tags like:
#region getcontent
#endregion
It is smart enough to create regions from common sections, such as the comment-based Help and the Parameter section. All I need to do is click the minus sign in the little square box on the left side of the code section, and it collapses the region. To open, I click the plus sign. This makes it easier to work with longer scripts. Here is what my script looks like with the Help and Parameter sections collapsed and the CreateHashTables region open:

The CreateHashTables region
The CreateHashTables portion of my script is basically the same code that I worked out earlier in the week. The only change I made is to add a couple of Write-Verbose commands. These do not display anything unless I run the function with the –Verbose parameter. –Verbose is one of the common parameters, and it is supported when I add in the [cmdletbinding()] attribute tag in my script. Because there are a lot of moving parts to this script now, I decided to add several Write-Verbose commands. Here is that section now, along with the collapsible region:
#>

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

<#
Get the content
One change I decided to make is that I basically support reading from and writing to a text file. The reason for this is that it was really impractical to paste in an array of ASCII numeric values. So I decided to use two text files. I used the same parameter names as other Windows PowerShell cmdlets use. So the input file is –Path, and the output file is –FilePath. This helps make the script easy to remember how to use.
I first use a Write-Verbose cmdlet to state that I am reading input, and I pass the $path variable so I know exactly where I am reading. I then use the Test-Path cmdlet to ensure the file exists. If it does not, I return. I know it is common to use Exit here, but when I am running this in the Windows PowerShell ISE, it closes the Windows PowerShell ISE—and that can be a real pain when writing and debugging a script. So I simply return, but do not return anything. Here is the script:
#>

#region getcontent
Write-Verbose "Reading input file from $path"
if (Test-path $path) {
    $txtIN = Get-Content $path -Encoding Ascii
} else {
    "Unable to find $path"
    return
}
#endregion

<#
Encode the content and write to file
Now I need to encode the content and write the ASCII numeric values to a text file if the script is called with the –Encode parameter. The first thing I do is check to see if the $encode variable exists. If it does, the function was called with the –Encode switched parameter.
Next, I use Write-Verbose to display a message that states I am beginning the encode. The rest of the script is basically the same as I previously wrote. I then use the Out-File cmdlet to create an ASCII encoded text file. This script is shown here:
#>

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

<#
Decode the file
The last thing to do is to decode the file. This region works the same as other portions of the script. One significant change I had to make was to cast the inputted value to an integer. This is because when the numbers are read from the text file via Get-Content, Windows PowerShell automatically cast the values to a string. So the lookups were not working. This actually took me nearly an hour to figure out (sometimes I am really slow like that). Here is the script:
#>

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

<#
Tests and limitations
I open the script file that contains the function in the Windows PowerShell ISE, and I click the green arrow to run the script. This loads the function into memory, but nothing is output to the output pane.
The comment-based Help works great. I can call Get-Help and pass the Convert-AsciiEncoding function name and get basic Help. I can use –Examples and get only examples, or –Full and get the complete Help information. This is shown here:

Now I create a simple text file with a single line in it. I do this in Notepad and save it in a location that I can easily find. I type the following string:
“This is a simple text file; It has (1) number!”
Here is the content of the file:

Now, I use the following command to encode the file:
Convert-AsciiEncoding -path C:\fso\Simple.txt -filepath c:\fso\encodedSimple.txt -encode
The encoded text file is shown here:

Now I decode the file. I run it with the –Verbose parameter. Here is my command:
Convert-AsciiEncoding -path C:\fso\encodedSimple.txt -filepath c:\fso\decodedSimple.txt -decode -Verbose
From the Windows PowerShell ISE output pane, I can see that my decode worked:

And here is the text file that I decoded:

There is one annoying limitation with this function. It does not handle multiple-line text that I type into Notepad. For some reason, when I read-in the text file, it does not pick up that there is a Carriage Return (CR) character (ACSII 10) or a New Line (LF) character (ASCII 13). As a result, when I put in the decode text, the values are not in the outputted text file. When I use Join to put the text back together, there is nothing between the punctuation at the end of one line to the first character of a new line, so it all runs together.
When I used a Here-String in my earlier blog posts, I was able to detect the CRLF sequence; and therefore, it worked. I suspect either something with Notepad, or something with the way Get-Content reads the file. But after messing around with for most of the afternoon, I decided to forgo it. If you figure it out, post a comment and share your wisdom.
That is all there is to converting my encoding/decoding script into a function. I hope you found this as much fun as I did. To save yourself a lot of typing, the complete script is available in the Script Center Repository.
Join me tomorrow when I will talk about adding an offset capability and the ability to write to files.
I invite you to follow me on Twitter and Facebook. If you have any questions, send email to me at scripter@microsoft.com, or post your questions on the Official Scripting Guys Forum. See you tomorrow. Until then, peace.
Ed Wilson, Microsoft Scripting Guy

Doctor Scripto Scripter, PowerShell, vbScript, BAT, CMD
#>

} #end function Convert-AsciiEncoding

