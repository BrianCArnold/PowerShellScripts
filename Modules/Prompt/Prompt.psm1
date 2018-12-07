function cout ($in_ss)
{
	Write-Host($in_ss) -nonewline -foregroundcolor White -Separator ""
}
function TrenchPrompt {
	Write-Host("PS" + ($PSVersionTable.PSVersion).Major.ToString() + " " + $(pwd)[0].Path + " ") -nonewline -foregroundcolor White
	$gStatus = $(git status -sb 2> $null)
	if (($gStatus | measure).Count -eq 1) { $gStatus = @($gStatus) }
	if ($gStatus -ne $null) {

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



		if ($unTrackedMod -gt 0) {cout($unTrackedMod.ToString() + '*') }
		if ($unTrackedDel -gt 0) {cout($unTrackedDel.ToString() + '-') }
		if ($unTrackedUnk -gt 0) {cout($unTrackedUnk.ToString() + '+') }
		if ($TrackedMod -gt 0) { cout($TrackedMod.ToString() + '#') }
		if ($TrackedAdd -gt 0) { cout($TrackedAdd.ToString() + '^') }
		if ($TrackedDel -gt 0) { cout($TrackedDel.ToString() + 'x') }
		if ($TrackedRen -gt 0) { cout($TrackedRen.ToString() + '>') }
		if ($TrackedCop -gt 0) { cout($TrackedCop.ToString() + '=') }
		if ($TrackedUpd -gt 0) { cout($TrackedUpd.ToString() + '#') }

		$branch = $gStatus[0] -replace "## ([^.]+).*", '$1'
		cout($branch)


		## master...origin/master [ahead 1, behind 8]
		if ($gStatus[0] -match "\[.*ahead ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				cout(">" + $Matches[1])
			}
		}
		if ($gStatus[0] -match "\[.*behind ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				cout("<" + $Matches[1])
			}
		}

		cout(" ")
	}

	$sig = "$"
	If (($PSVersionTable.PSVersion).Major -lt 6) {
		If ($IsWindows) {
			If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
			{

				$sig = "#"
			}

		}
	}
	Else {
		If ($IsLinux) {
			$uid = id -u
			if ($uid -eq '0') {
				$sig = "#"
			}
		}
	}
	cout($sig)

	return " "
}

Export-ModuleMember -Function TrenchPrompt
