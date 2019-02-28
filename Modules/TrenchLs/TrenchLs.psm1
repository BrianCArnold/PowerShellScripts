
function Get-ItemRecursively {
	gci -R @args | Where-Object {$_.Mode[0] -ne 'd'} |  foreach { $_.FullName }
}


function Get-ItemRecursivelyOut {
	param (
		[parameter(position = 0)]
		$dirName
	)
	$dirs = gci | Where-Object {$_.Mode[0] -eq 'd' -and $_.Name.ToLower() -eq $dirName.ToLower()}
	foreach ($item in $dirs) {
		return $item
	}
	$dirs = gci | Where-Object {$_.Mode[0] -eq 'd' -and $_.Name.ToLower() -ne $dirName.ToLower()}

	foreach ($item in $dirs) {
		return $item
	}
}; Get-ItemRecursivelyOut ProductSupply

function Get-DirectoryOf {
	$location = Get-Item @args
	if ($location.Mode.StartsWith("d")) {
		Write-Output -InputObject $location
	}
	else {
		Write-Output -InputObject $location.Directory
	}

}

function Set-LocationTrench {
	param (
		[parameter(position = 0)]
		$location
	)
	if (!$location) {
		Pop-Location
	}
	else {
		Push-Location $location
	}
}
Set-Alias ffind Get-ItemRecursively
Set-Alias fffind Get-ItemRecursivelyOut
Set-Alias dirof Get-DirectoryOf
Set-Alias j Set-LocationTrench
Export-ModuleMember -Function Set-LocationTrench, Get-DirectoryOf, Get-ItemRecursively, Get-ItemRecursivelyOut -Alias ffind, fffind, dirof, j
