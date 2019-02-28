
function Get-GitShortStatus {
	git status -sb
}

function Get-GitLog {
	git log
}


function Clear-Window {
	$pshost = Get-Host
	$line = ""
	for ($y = 0; $y -lt $pshost.UI.RawUI.WindowSize.Height; $y++) {
		for ($x = 0; $x -lt $psHost.UI.RawUI.WindowSize.Width; $x++) {
			$line += " "
		}
	}
	Write-Host $line
	Clear-Host
}

function Get-GitDiff {
	git diff
}

Set-Alias gls Get-GitShortStatus
Set-Alias glog Get-GitLog
Set-Alias giff Get-GitDiff
Set-Alias g git
Set-Alias dn dotnet
Set-Alias cclear Clear-Window


Export-ModuleMember -Function Get-GitShortStatus, Get-GitDiff, Get-GitLog, Clear-Window -Alias gls, glog, cclear, dn, giff, g
