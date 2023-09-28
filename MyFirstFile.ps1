<#
2023-09-27 Wednesday 1:56p.
This is my first file on a new folder on the local hard drive and on GitHub.

When setting up VS Code, Git, & GitHub on a new system, in your "public_GitHub_data" folder, make a ".gitignore" file & a "gitignore_data" folder.
Put things in the folder that you do not want to upload to GitHub since GitHub data is visible to the world!

In the .gitignore file, here's the four lines I initially put:
/gitignore_data
gitignore_data/ShouldNotSeeMe.ps1
.gitignore
.DS_Store

The first line tells Git to ignore that folder (& everything inside).  "gitignore_data/*" could also be used to just ignore all files inside.
The second one ignores a PowerShell script inside that folder although this can probably go away and Git would still ignore it based on the first line.
The third one ignores the ignore file so it doesn't upload.
Steven said you could go ahead and not ignore the ignore file so it uploads.  That way I'll pull down on new systems & your ignores will be consistent.
Credentials are secondary.  Ignore is primarily used to ignore environment for cross-platform code.
The fourth line ignores a hidden file on the Mac.
You can also make a file containing custom environment variables and tell Git to ignore it.  This way you can reference more sensitive data in public scripts w/o exposing it.

#>

# This is a comment.



#EndOfFile
