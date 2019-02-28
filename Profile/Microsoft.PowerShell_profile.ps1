function prompt {
	TrenchPrompt
}
$profileDir = (Get-ChildItem $PROFILE)[0].Directory.FullName + "\"

Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Import-Module TrenchLs
Import-Module GitExt
Import-Module Color
Import-Module Prompt
Import-Module SignScript
