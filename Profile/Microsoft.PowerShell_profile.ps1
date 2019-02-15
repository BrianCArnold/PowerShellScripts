function prompt {
	TrenchPrompt
}
$profileDir = (Get-ChildItem $PROFILE)[0].Directory.FullName + "\"

Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
