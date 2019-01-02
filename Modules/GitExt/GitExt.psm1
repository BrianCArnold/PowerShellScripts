
function Get-GitStatus {
	git status -sb
}

Export-ModuleMember -Function Get-GitStatus

Set-Alias gls Get-GitStatus

Export-ModuleMember -Alias gls
