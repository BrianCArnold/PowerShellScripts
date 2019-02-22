

$branchIcon = ([char]0xE0A0).ToString()
$toIcon = ([char]0xE0B0).ToString()
$toBlankIcon = ([char]0xE0B1).ToString()
$fromIcon = ([char]0xE0B2).ToString()
$fromBlankIcon = ([char]0xE0B3).ToString()

function TrenchPrompt {
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
		$result = (Color).WriteGradient(0xddffee, 0xffeedd, 0x406020, 0x802020, $simplePrompt)
		$result += (Color).WriteColor(0x802020, 0x0, $toIcon)
	}
 	else {
		$result = (Color).WriteGradient(0xddffee, 0xffeedd, 0x204060, 0x406020, $simplePrompt)
		$result += (Color).WriteColor(0x406020, 0x0, $toIcon)
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
			$repoName = $repoUrl.Substring($repoUrl.LastIndexOf('/') + 1)
		}
		else {
			$repoName = $gitLocation.Substring($gitLocation.LastIndexOf("/")+1)
		}

		$result += (Color).WriteGradient(0xddffee, 0xffeedd, 0x602040, 0x608040, $repoName)
		$result += (Color).WriteGradient(0x000000, 0x000000, 0x608040, 0x608040, $branchIcon)
		$result += (Color).WriteGradient(0xffeedd, 0xeeddff, 0x608040, 0x402060, $branch)

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
		$result += (Color).WriteColor(0x402060, 0xbbffbb, $toIcon)

		$endColor = 0xddddff
		if ($isAdmin) {
			$endColor = 0xff8888
		}

		$result += (Color).WriteGradient(0x302010, 0x301020, 0xbbffbb, $endColor, $newLoc)


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
				$statusData += (Color).WriteColor(0xFFD722, 0x0, [char]0x2193)
				$statusData += (Color).WriteColor(0xFF8C22, 0x0, $Matches[1])
				$trackedHit = $true
			}
		}
		if ($TrackedUpd -gt 0)
		{
			$statusData += (Color).WriteColor(0x2040b0, 0x0, $TrackedUpd.ToString())
			$trackedHit = $true
		}
		if ($TrackedDel -gt 0)
		{
			$statusData += (Color).WriteColor(0xb02040, 0x0, $TrackedDel.ToString())
			$trackedHit = $true
		}
		if ($TrackedAdd -gt 0)
		{
			$statusData += (Color).WriteColor(0x20b020, 0x0, $TrackedAdd.ToString())
			$trackedHit = $true
		}
		if ($TrackedRen -gt 0)
		{
			$statusData += (Color).WriteColor(0xDA70D6, 0x0, $TrackedRen.ToString())
			$trackedHit = $true
		}
		if ($TrackedCop -gt 0)
		{
			$statusData += (Color).WriteColor(0x66b9b9, 0x0, $TrackedCop.ToString())
			$trackedHit = $true
		}
		if ($unTrackedUnk -gt 0)
		{
			$statusData += (Color).WriteColor(0x209020, $endColor, $unTrackedUnk.ToString())
			$untrackedHit = $true
		}
		if ($unTrackedDel -gt 0)
		{
			$statusData += (Color).WriteColor(0x902020, $endColor, $unTrackedDel.ToString())
			$untrackedHit = $true
		}
		if ($unTrackedMod -gt 0)
		{
			$statusData += (Color).WriteColor(0x202090, $endColor, $unTrackedMod.ToString())
			$untrackedHit = $true
		}
		if ($gStatus[0] -match "\[.*ahead ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				$statusData += (Color).WriteColor(0x887000, $endColor, [char]0x2193)
				$statusData += (Color).WriteColor(0x883800, $endColor, $Matches[1])
				$untrackedHit = $true
			}
		}
		if ($statusData.Length -gt 0) {
			if ($trackedHit -eq $true) {
				$result += (Color).WriteGradient(0x0, 0x0, $endColor, $endColor, $fromIcon)
			}
			elseif ($untrackedHit -eq $true) {
				$result += (Color).WriteGradient(0x0, 0x0, $endColor, $endColor, $fromBlankIcon)
			}

			$result += $statusData
			if ($untrackedHit -eq $true) {
				$result += (Color).WriteGradient($endColor, $endColor, 0x0, 0x0, $toIcon)
			}
			elseif ($trackedHit -eq $true) {
				$result += (Color).WriteGradient($endColor, 0xddddff, 0x0, 0x0, $toBlankIcon)
			}
		}
		else {
			$result += (Color).WriteGradient($endColor, $endColor, 0x0, 0x0, $toIcon)
		}


	}
	$result += " "
	return $result
}

Export-ModuleMember -Function TrenchPrompt
