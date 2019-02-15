
function Get-GitStatus {
	git status -sb
}



Export-ModuleMember -Function Get-GitStatus

Set-Alias gls Get-GitStatus
Set-Alias dn dotnet

Export-ModuleMember -Alias gls
Export-ModuleMember -Alias dn
