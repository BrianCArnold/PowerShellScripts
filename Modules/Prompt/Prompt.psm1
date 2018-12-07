function colorBlack
{
  return "$([char]27)[0;30m" +  $args[0] + "$([char]27)[m"
}

function colorBlue
{
  return "$([char]27)[34m" +  $args[0] + "$([char]27)[m"
}

function colorGreen
{
  return "$([char]27)[0;32m" +  $args[0] + "$([char]27)[m"
}

function colorCyan
{
  return "$([char]27)[0;36m" +  $args[0] + "$([char]27)[m"
}

function colorRed
{
  return "$([char]27)[0;31m" +  $args[0] + "$([char]27)[m"
}

function colorPurple
{
  return "$([char]27)[0;35m" +  $args[0] + "$([char]27)[m"
}

function colorBrown
{
  return "$([char]27)[0;33m" +  $args[0] + "$([char]27)[m"
}

function colorLightBlack
{
  return "$([char]27)[1;30m" +  $args[0] + "$([char]27)[m"
}

function colorLightBlue
{
  return "$([char]27)[1;34m" +  $args[0] + "$([char]27)[m"
}

function colorLightGreen
{
  return "$([char]27)[1;32m" +  $args[0] + "$([char]27)[m"
}

function colorLightCyan
{
  return "$([char]27)[1;36m" +  $args[0] + "$([char]27)[m"
}

function colorLightRed
{
  return "$([char]27)[1;31m" +  $args[0] + "$([char]27)[m"
}

function colorLightPurple
{
  return "$([char]27)[1;35m" +  $args[0] + "$([char]27)[m"
}

function colorLightBrown
{
  return "$([char]27)[1;33m" +  $args[0] + "$([char]27)[m"
}

function colorBlackInv
{
  return "$([char]27)[7;30m" +  $args[0] + "$([char]27)[m"
}

function colorBlueInv
{
  return "$([char]27)[7;34m" +  $args[0] + "$([char]27)[m"
}

function colorGreenInv
{
  return "$([char]27)[7;32m" +  $args[0] + "$([char]27)[m"
}

function colorCyanInv
{
  return "$([char]27)[7;36m" +  $args[0] + "$([char]27)[m"
}

function colorRedInv
{
  return "$([char]27)[7;31m" +  $args[0] + "$([char]27)[m"
}

function colorPurpleInv
{
  return "$([char]27)[7;35m" +  $args[0] + "$([char]27)[m"
}

function colorBrownInv
{
  return "$([char]27)[7;33m" +  $args[0] + "$([char]27)[m"
}

function colorLightBlackInv
{
  return "$([char]27)[7;30m" +  $args[0] + "$([char]27)[m"
}

function colorLightBlueInv
{
  return "$([char]27)[7;34m" +  $args[0] + "$([char]27)[m"
}

function colorLightGreenInv
{
  return "$([char]27)[7;32m" +  $args[0] + "$([char]27)[m"
}

function colorLightCyanInv
{
  return "$([char]27)[7;36m" +  $args[0] + "$([char]27)[m"
}

function colorLightRedInv
{
  return "$([char]27)[7;31m" +  $args[0] + "$([char]27)[m"
}

function colorLightPurpleInv
{
  return "$([char]27)[7;35m" +  $args[0] + "$([char]27)[m"
}

function colorLightBrownInv
{
  return "$([char]27)[7;33m" +  $args[0] + "$([char]27)[m"
}

function underline
{
  return "$([char]27)[4m" +  $args[0] + "$([char]27)[m"	
}

function bold
{
  return "$([char]27)[1m" +  $args[0] + "$([char]27)[m"	
}

function TrenchPrompt {
	$result=""
	$location = $(pwd)[0].Path.ToString()
	$result+=colorPurpleInv("PS" + ($PSVersionTable.PSVersion).Major.ToString())
	$result+=colorBlack(" ")
	$result+=colorBrown(underline($location)) + " "
	$result+=colorBlack(" ")
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

		

		$branch = $gStatus[0] -replace "## ([^.]+).*", '$1'
		$result+=bold(colorBlue(underline($branch)))
		
		$result+= "["
		if ($TrackedMod -gt 0) { $result+=colorCyan($TrackedMod.ToString())}
		if ($TrackedUpd -gt 0) { $result+=colorCyan($TrackedUpd.ToString())}	
		if ($unTrackedMod -gt 0) {$result+=colorCyanInv($unTrackedMod.ToString())}
		if ($TrackedDel -gt 0) { $result+=colorRed($TrackedDel.ToString())}
		if ($unTrackedDel -gt 0) {$result+=colorRedInv($unTrackedDel.ToString())}
		if ($TrackedAdd -gt 0) { $result+=colorGreen($TrackedAdd.ToString())}
		if ($unTrackedUnk -gt 0) {$result+=colorGreenInv($unTrackedUnk.ToString())}
		if ($TrackedRen -gt 0) { $result+=colorPurple($TrackedRen.ToString())}
		if ($TrackedCop -gt 0) { $result+=colorBlue($TrackedCop.ToString())}	
		if ($gStatus[0] -match "\[.*ahead ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				$result+=colorBrown($Matches[1])
			}
		}
		if ($gStatus[0] -match "\[.*behind ([0-9]+).*\]") {
			if ($Matches[1] -ne $null) {
				$result+=colorBrownInv($Matches[1])
			}
		}
		if ($result[$result.Length-1] -eq "[")
		{
			$result = $result.Substring(0, $result.Length - 1)
		}
		else {
			$result+= "]"
		}


		## master...origin/master [ahead 1, behind 8]
		$result+=(" ")
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
	$result+=($sig)

	$result+=(" ")
	return $result
}

Export-ModuleMember -Function TrenchPrompt
