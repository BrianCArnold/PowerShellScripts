
function Get-Item-Recursively {
	#	$myParams = $args
	gci -R @args | Where-Object {$_.Mode[0] -ne 'd'} |  foreach { $_.FullName }
}
Set-Alias ffind Get-Item-Recursively

function Get-Directory-Of {
	$location = Get-Item @args
	if ($location.Mode.StartsWith("d")) {
		Write-Output -InputObject $location
	}
	else {
		Write-Output -InputObject $location.Directory
	}

}
Set-Alias dirof Get-Directory-Of

function Set-Location-Trench {
	if ($args.Count -eq 0) {
		$mArgs = '~'
	}
	else {
		$mArgs = $args
	}
	$location = Get-Directory-Of @mArgs
	Set-Location $location
}
Set-Alias j Set-Location-Trench
Export-ModuleMember -Function Set-Location-Trench, Get-Directory-Of, Get-Item-Recursively
Export-ModuleMember -Alias ffind, dirof, j

