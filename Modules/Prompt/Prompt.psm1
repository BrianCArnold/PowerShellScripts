

$branchIcon = ([char]0xE0A0).ToString()

function TrenchPrompt {
	$result=""
	$location = $(Get-Location)[0].Path.ToString().Replace("\", "/")

	$result += (Color).Green().Bold().Write("PS" + ($PSVersionTable.PSVersion).Major.ToString())
	$result+=" "
	$result += (Color).Brown().Write(($location)) + " "
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

		$result += (Color).BlueB().Black().Write($repoName)
		#$result += (Color).BlueB().Black().Write($gitLocation)
		$result += (Color).BlueB().White().Bold().Write($branchIcon)
		$result += (Color).BlueB().Write($branch)

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
		$result += " "

		$result += (Color).GreenB().Black().Write($newLoc)

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




		$result += "["
		$TrackedUpd += $TrackedMod
		if ($gStatus[0] -match "\[.*behind ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				$result += $((Color).Brown().Bold().Write([char]0x2193).ToString()) + $((Color).Brown().Write($Matches[1]))
			}
		}
		if ($TrackedUpd -gt 0) { $result += (Color).Blue().Write($TrackedUpd.ToString())}
		if ($unTrackedMod -gt 0) {$result += (Color).BlueB().Black().Write($unTrackedMod.ToString())}
		if ($TrackedDel -gt 0) { $result += (Color).Red().Write($TrackedDel.ToString())}
		if ($unTrackedDel -gt 0) {$result += (Color).RedB().Black().Write($unTrackedDel.ToString())}
		if ($TrackedAdd -gt 0) { $result += (Color).Green().Write($TrackedAdd.ToString())}
		if ($unTrackedUnk -gt 0) {$result += (Color).GreenB().Black().Write($unTrackedUnk.ToString())}
		if ($TrackedRen -gt 0) { $result += (Color).Purple().Write($TrackedRen.ToString())}
		if ($TrackedCop -gt 0) { $result += (Color).Cyan().Write($TrackedCop.ToString())}
		if ($gStatus[0] -match "\[.*ahead ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				$result += $((Color).BrownB().White().Bold().Write([char]0x2191).ToString()) + $((Color).BrownB().Black().Write($Matches[1]))
			}
		}
		if ($result[$result.Length - 1] -eq "[") {
			$result = $result.Substring(0, $result.Length - 1)
		}
		else {
			$result += "]"
		}


		## master...origin/master [ahead 1, behind 8]
		$result += (" ")
	}

	$sig = "$"
	if (($PSVersionTable.PSVersion).Major -lt 6 -or $IsWindows) {
		If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
		{
			$sig = "#"
		}
	} else {
		If ($IsLinux) {
			$uid = id -u
			if ($uid -eq '0') {
				$sig = "#"
			}
		}
	}
	$result+=($sig)

	$result += (" ")
	$result
	return $result
}

Export-ModuleMember -Function TrenchPrompt
