
function SignScript {
	$barnoldCert = (dir cert:LocalMachine\My\ -CodeSigningCert -DnsName "trenchie@trenchie.us")[0]
	foreach ($arg in ($args + $input)) {
		$startFolder = Get-Location
		$location = (Get-Item -Path $arg)
		if ($location.Mode.StartsWith("d")) {
			Set-Location $location
			$childFiles = $location.GetFiles()
			SignScript @childFiles
			$childDirs = $location.GetDirectories()
			SignScript @childDirs
			Set-Location $startFolder
		}
		else {
			Write-Host("Signing ") -NoNewline
			Write-Host($arg) -NoNewline
			$result = Set-AuthenticodeSignature -FilePath $arg -Certificate $barnoldCert -TimestampServer http://timestamp.comodoca.com/authenticode
			Write-Host("... ") -NoNewline
			switch ($result.Status) {
				"Valid" { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Green }
				Default { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Red }
			}
		}
	}
}

#Copy Profile files.
if ($IsLinux) {
	echo "Installing Profile..."
	$ProfileDir = $PROFILE.Replace($PROFILE.Substring($PROFILE.LastIndexOf('/') + 1), '')
	mkdir -p $ProfileDir
	Copy-Item -Recurse -Force ".\Profile\*" -Destination $ProfileDir

	echo "Installing Modules..."
	$ModuleDir = $env:PSModulePath.Substring(0, $env:PSModulePath.IndexOf(":"))
	$ModuleDir = $ModuleDir.Replace($ModuleDir.Substring($ModuleDir.LastIndexOf('/') + 1), '')
	mkdir -p $ModuleDir
	Copy-Item -Recurse -Force ".\Modules" -Destination $ModuleDir
}
if ($IsWindows -or ($PSVersionTable.PSVersion).Major -lt 6) {
	echo "Installing Profile..."
	$ProfileDir = $PROFILE.Replace($PROFILE.Substring($PROFILE.LastIndexOf('\') + 1), '')
	Copy-Item -Recurse -Force ".\Profile\*" -Destination $ProfileDir

	echo "Installing Modules..."
	$ModuleDir = $env:PSModulePath.Substring(0, $env:PSModulePath.IndexOf(";"))
	$ModuleDir = $ModuleDir.Replace($ModuleDir.Substring($ModuleDir.LastIndexOf('\') + 1), '')
	Copy-Item -Recurse -Force ".\Modules" -Destination $ModuleDir
}

.\extern\posh-git\install.ps1

if (($PSVersionTable.PSVersion).Major -lt 6) {
	Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force 2> $null
	SignScript (ls $PROFILE).Directory
}
