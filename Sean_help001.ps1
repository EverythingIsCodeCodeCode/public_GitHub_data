<#
2023-10-04 Wed. 9:28a.
This is some stuff Sean has shown me.
#>


# This is probably the simplest use of the .IndexOf method that I've used.  Basically it shows me which number in a series my loop is on when processing a list.
$ports="2181","2888","3182"
foreach ($port in $ports) { $i = $ports.IndexOf($port) ; $i}


#End of file.

