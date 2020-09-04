

$branchIcon = ([char]0xE0A0).ToString()
$toIcon = ([char]0xE0B0).ToString()
$toBlankIcon = ([char]0xE0B1).ToString()
$fromIcon = ([char]0xE0B2).ToString()
$fromBlankIcon = ([char]0xE0B3).ToString()

function TrenchPrompt {
	if ($ENV:TRENCHCOLOR -eq 2) {#Full
		
	}
	elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
		
	}
	else  {#None

	}
	$isAdmin = $false
	if (($PSVersionTable.PSVersion).Major -lt 6 -or $IsWindows) {
		If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
			$isAdmin = $true
		}
	}
 	else {
		If ($IsLinux) {
			$uid = id -u
			if ($uid -eq '0') {
				$isAdmin = $true
			}
		}
	}
	$result=""
	$location = $(Get-Location)[0].Path.ToString().Replace("\", "/")
	
	$simplePrompt = "PS" + ($PSVersionTable.PSVersion).Major.ToString() + " " + $location

	if ($isAdmin -eq $true) {
		if ($ENV:TRENCHCOLOR -eq 2) {#Full
			$result = (Color).WriteGradient(0xddffee, 0xffeedd, 0x406020, 0x802020, $simplePrompt)
			$result += (Color).WriteColor(0x802020, 0x0, $toIcon)
		}
		elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
			$result = (Color).Red().BlackB().Underline().Write($simplePrompt)
			$result += (Color).Red().BlackB().Write($toBlankIcon)			
		}
		else  {#None
			$result += ($simplePrompt)
			$result += ($toIcon)
		}
	}
 	else {
		if ($ENV:TRENCHCOLOR -eq 2) {#Full
			$result = (Color).WriteGradient(0xddffee, 0xffeedd, 0x204060, 0x406020, $simplePrompt)
			$result += (Color).WriteColor(0x406020, 0x0, $toIcon)
		}
		elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
			$result = (Color).Green().BlackB().Underline().Write($simplePrompt)
			$result += (Color).Green().BlackB().Write($toBlankIcon)			
		}
		else  {#None
			$result += ($simplePrompt)
			$result += ($toIcon)
		}
	}
	$gStatus = $(git status -sb 2> $null)
	if (($gStatus | Measure-Object).Count -eq 1) { $gStatus = @($gStatus) }
	if ($null -ne $gStatus) {

		$gitLocation = $(git rev-parse --show-toplevel)
		$repoLoc = $location.Replace($gitLocation, "")
		$result = ""

		$branch = $gStatus[0] -replace "## ([^.]+).*", '$1'
		$repoUrl = $(git config --get remote.origin.url)
		if ($null -ne $repoUrl) {
			$repoName = $repoUrl.Substring($repoUrl.LastIndexOf('/') + 1).Replace(".git", "")
		}
		else {
			$repoName = $gitLocation.Substring($gitLocation.LastIndexOf("/")+1)
		}
		if ($ENV:TRENCHCOLOR -eq 2) {#Full
			$result += (Color).WriteGradient(0xddffee, 0xffeedd, 0x602040, 0x608040, $repoName)
			$result += (Color).WriteGradient(0x000000, 0x000000, 0x608040, 0x608040, $branchIcon)
			$result += (Color).WriteGradient(0xffeedd, 0xeeddff, 0x608040, 0x402060, $branch)
		}
		elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
			$result += (Color).Green().BlackB().Write($repoName)
			$result += (Color).White().BlackB().Write($branchIcon)
			$result += (Color).Cyan().BlackB().Underline().Write($branch)
		}
		else  {#None
			$result += ($repoName)
			$result += ($branchIcon)
			$result += ($branch)
		}

		$ellipsis = ([char]0x2026).ToString()
		$locParts = $repoLoc.Split('/')
		$newLoc = ""
		$i = $locParts.Count - 1
		for (; ($i -gt 0) -and ($i -gt $locParts.Count - 4); $i--) {
			$newPart = $locParts[$i]
			if ($i -lt ($locParts.Length - 1)) {
				if ($newPart.Length -gt 5) {
					$newPart = $newPart.Substring(0, 4) + $ellipsis# + $newPart.Substring($newPart.Length-2, 2)
				}
			}
			$newLoc = $newPart + '/' + $newLoc
		}
		if ($i -gt 0) {
			$newLoc = $ellipsis + '/' + $newLoc
		}
		$newLoc = "/" + $newLoc

		#$newLoc = ""
		#$i = $locParts.Count - 1
		#for (; ($i -gt 0) -and ($i -gt $locParts.Count - 4); $i--) {
		#	$newPart = $locParts[$i]
		#	$newLoc = $newPart + '/' + $newLoc
		#}
		#if ($i -gt 0) {
		#	$newLoc = '…' + '/' + $newLoc
		#}
		
		if ($ENV:TRENCHCOLOR -eq 2) {#Full
			$result += (Color).WriteColor(0x402060, 0xddffdd, $toIcon)
		}
		elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
			$result += (Color).Black().GreenB().Write($toIcon)
		}
		else  {#None
			$result += ($toIcon)
		}

		$endColor = 0xddddff
		if ($isAdmin) {
			$endColor = 0xffdddd
		}

		
		if ($ENV:TRENCHCOLOR -eq 2) {#Full
			$result += (Color).WriteGradient(0x302010, 0x301020, 0xddffdd, $endColor, $newLoc)
		}
		elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
			$result += (Color).Black().GreenB().Write($newLoc)
		}
		else  {#None
			$result += ($newLoc)
		}


		$files = $gStatus[1..($gStatus.Length - 1)]
		# M odified
		# A dded
		# D eleted
		# R enamed
		# C opied
		# U pdated
		$unTrackedMod = ($files | Where-Object {$_[1] -eq 'M'}).Count # *
		$unTrackedDel = ($files | Where-Object {$_[1] -eq 'D'}).Count # -
		$unTrackedUnk = ($files | Where-Object {$_[1] -eq '?'}).Count # +


		$TrackedMod = ($files | Where-Object {$_[0] -eq 'M'}).Count # *
		$TrackedAdd = ($files | Where-Object {$_[0] -eq 'A'}).Count # â†‘
		$TrackedDel = ($files | Where-Object {$_[0] -eq 'D'}).Count # â†“
		$TrackedRen = ($files | Where-Object {$_[0] -eq 'R'}).Count # â†’
		$TrackedCop = ($files | Where-Object {$_[0] -eq 'C'}).Count # â†•
		$TrackedUpd = ($files | Where-Object {$_[0] -eq 'U'}).Count # *


		$statusData = ""
		$TrackedUpd += $TrackedMod
		$trackedHit = $false
		$untrackedHit = $false
		if ($gStatus[0] -match "\[.*behind ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				#Behind/To Pull
				#Orange/Black
				if ($ENV:TRENCHCOLOR -eq 2) {#Full
					$statusData += (Color).WriteColor(0xFFD722, 0x0, [char]0x2193)
					$statusData += (Color).WriteColor(0xFF8C22, 0x0, $Matches[1])
				}
				elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
					$statusData += (Color).Red().Bold().BlackB().Write([char]0x2193)
					$statusData += (Color).Red().Bold().BlackB().Write($Matches[1])
				}
				else  {#None
					$statusData += ([char]0x2193)
					$statusData += ($Matches[1])
				}
				$trackedHit = $true
			}
		}
		if ($TrackedUpd -gt 0)
		{#Blue/Black
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0x2040b0, 0x0, $TrackedUpd.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Blue().BlackB().Write($TrackedUpd.ToString())
			}
			else  {#None
				$statusData += ($TrackedUpd.ToString())
			}
			$trackedHit = $true
		}
		if ($TrackedDel -gt 0)
		{#Red/Black
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0xb02040, 0x0, $TrackedDel.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Red().BlackB().Write($TrackedDel.ToString())
			}
			else  {#None
				$statusData += ($TrackedDel.ToString())
			}
			$trackedHit = $true
		}
		if ($TrackedAdd -gt 0)
		{#green/black
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0x20b020, 0x0, $TrackedAdd.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Green().BlackB().Write($TrackedAdd.ToString())
			}
			else  {#None
				$statusData += ($TrackedAdd.ToString())
			}
			$trackedHit = $true
		}
		if ($TrackedRen -gt 0)
		{#purple/black
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0xDA70D6, 0x0, $TrackedRen.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Purple().BlackB().Write($TrackedRen.ToString())
			}
			else  {#None
				$statusData += ($TrackedRen.ToString())
			}
			$trackedHit = $true
		}
		if ($TrackedCop -gt 0)
		{#cyan/black
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0x66b9b9, 0x0, $TrackedCop.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Cyan().BlackB().Write($TrackedCop.ToString())
			}
			else  {#None
				$statusData += ($TrackedCop.ToString())
			}
			$trackedHit = $true
		}
		if ($unTrackedUnk -gt 0)
		{#Green/white
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0x209020, 0x0, $unTrackedUnk.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Green().WhiteB().Write($unTrackedUnk.ToString())
			}
			else  {#None
				$statusData += ($unTrackedUnk.ToString())
			}
			$untrackedHit = $true
		}
		if ($unTrackedDel -gt 0)
		{#red/white
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0x209020, 0x0, $unTrackedDel.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Red().WhiteB().Write($unTrackedDel.ToString())
			}
			else  {#None
				$statusData += ($unTrackedDel.ToString())
			}
			$untrackedHit = $true
		}
		if ($unTrackedMod -gt 0)
		{#blue/white
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$statusData += (Color).WriteColor(0x202090, 0x0, $unTrackedMod.ToString())
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$statusData += (Color).Blue().WhiteB().Write($unTrackedMod.ToString())
			}
			else  {#None
				$statusData += ($unTrackedMod.ToString())
			}
			$untrackedHit = $true
		}
		if ($gStatus[0] -match "\[.*ahead ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				#Ahead/To Push
				#Orange/White
				if ($ENV:TRENCHCOLOR -eq 2) {#Full
					$statusData += (Color).WriteColor(0x887000, $endColor, [char]0x2191)
					$statusData += (Color).WriteColor(0x883800, $endColor, $Matches[1])
				}
				elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
					$statusData += (Color).Red().Bold().WhiteB().Write([char]0x2191)
					$statusData += (Color).Red().Bold().WhiteB().Write($Matches[1])
				}
				else  {#None
					$statusData += ([char]0x2191)
					$statusData += ($Matches[1])
				}
				$untrackedHit = $true
			}
		}
		if ($statusData.Length -gt 0) {
			if ($trackedHit -eq $true) {
				
				if ($ENV:TRENCHCOLOR -eq 2) {#Full
					$result += (Color).WriteGradient(0x0, 0x0, $endColor, $endColor, $fromIcon)
				}
				elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
					$result += (Color).Black().GreenB().Write($fromIcon)
				}
				else  {#None
					$result += ($fromIcon)
				}
			}
			elseif ($untrackedHit -eq $true) {
				
				if ($ENV:TRENCHCOLOR -eq 2) {#Full
					$result += (Color).WriteGradient(0x0, 0x0, $endColor, $endColor, $fromBlankIcon)
				}
				elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
					$result += (Color).White().GreenB().Write($fromIcon)
				}
				else  {#None
					$result += ($fromBlankIcon)
				}
			}

			$result += $statusData
			if ($untrackedHit -eq $true) {
				if ($ENV:TRENCHCOLOR -eq 2) {#Full
					$result += (Color).WriteGradient($endColor, $endColor, 0x0, 0x0, $toIcon)
				}
				elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
					$result += (Color).White().BlackB().Write($toIcon)
				}
				else  {#None
					$result += ($toIcon)
				}
			}
			elseif ($trackedHit -eq $true) {
				if ($ENV:TRENCHCOLOR -eq 2) {#Full
					$result += (Color).WriteGradient($endColor, $endColor, 0x0, 0x0, $toBlankIcon)
				}
				elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
					$result += (Color).White().BlackB().Write($toBlankIcon)
				}
				else  {#None
					$result += ($toBlankIcon)
				}
			}
		}
		else {
			if ($ENV:TRENCHCOLOR -eq 2) {#Full
				$result += (Color).WriteGradient($endColor, $endColor, 0x0, 0x0, $toIcon)
			}
			elseif ($ENV:TRENCHCOLOR -eq 1) {#Simple
				$result += (Color).Green().BlackB().Write($toIcon)
			}
			else  {#None
				$result += ($toIcon)
			}
		}


	}
	$result += " "
	return $result
}

Export-ModuleMember -Function TrenchPrompt
