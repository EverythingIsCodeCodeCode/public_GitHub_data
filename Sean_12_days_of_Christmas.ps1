<#
2024-01-08 Monday 9:35a.
Sean defined how many birds there are in the 12 Days Of Christmas song :) .
#>
$Items = @([pscustomobject]@{name="Partridge";type="Bird"},
[pscustomobject]@{name="TurtleDoves";type="Bird"},
[pscustomobject]@{name="FrenchHens";Type="Bird"},
[pscustomobject]@{name="CallingBirds";Type="Bird"},
[pscustomobject]@{name="GoldenRings";Type="object"},
[pscustomobject]@{name="Geese";Type="Bird"},
[pscustomobject]@{name="Swans";Type="Bird"},
[pscustomobject]@{name="Maids";Type="person"},
[pscustomobject]@{name="Ladies";Type="person"},
[pscustomobject]@{name="Lords";Type="person"},
[pscustomobject]@{name="Pipers";Type="object"},
[Pscustomobject]@{name="Drummers";Type="person"}
)

$Count = 0

foreach ($Item in $Items) {
  if ($item.Type -eq 'Bird') {
    $itemIndex = $([array]::IndexOf($Items, $Item) + 1)
    $itemcount = $itemIndex * (12 - $itemIndex + 1)
    Write-Output "$($item.Name) - $itemcount"
    $Count += $itemcount
  }
}
Write-Output "Total Birds - $Count"
