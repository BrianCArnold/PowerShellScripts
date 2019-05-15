
function Get-ItemRecursively {
	gci -R @args | Where-Object {$_.Mode[0] -ne 'd'} |  foreach { $_.FullName }
}


function Get-ItemRecursivelyOut {
	param (
		[parameter(Position = 0)]
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
		[parameter(Position = 0)]
		$location
	)
	if (!$location) {
		Pop-Location
	}
	else {
		Push-Location $location
	}
}

function Stop-ProcessTree {
	param(
		[Int32]
		$Id
	)
	Get-Process | Where-Object { $_.Parent.Id -eq $Id } | ForEach-Object { Stop-ProcessTree -Id $_.Id -Force }
	Stop-Process -Id $Id -Force
}

function Watch-Process {
	param (
		[Parameter(Position = 0)]
		[string]
		$Command,
		[Parameter(Position = 1)]
		[string]
		$Arguments,
		[Parameter(Position = 2)]
		[string]
		$WorkingDirectory
	)
	[console]::TreatControlCAsInput = $true
	Do {
		$relevantProc = Start-Process -FilePath $Command -ArgumentList $Arguments -WorkingDirectory $WorkingDirectory -NoNewWindow -PassThru
		Read-Host "Press enter to quit"
		Stop-ProcessTree $relevantProc.Id
	}
	While ((Read-Host -Prompt "Continue? [Y/n]").ToLower() -ne 'n')
}

Set-Alias ffind Get-ItemRecursively
Set-Alias fffind Get-ItemRecursivelyOut
Set-Alias dirof Get-DirectoryOf
Set-Alias j Set-LocationTrench
Export-ModuleMember -Function Watch-Process, Set-LocationTrench, Get-DirectoryOf, Get-ItemRecursively, Get-ItemRecursivelyOut -Alias ffind, fffind, dirof, j
