function prompt {
	TrenchPrompt
}
$profileDir = (Get-ChildItem $PROFILE)[0].Directory.FullName + "\"
Set-Alias "dn" "dotnet"
Export-Alias "dn"
