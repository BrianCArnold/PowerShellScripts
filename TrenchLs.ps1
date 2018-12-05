$isLong = $false
$myParams = @{}
$myParams["Force"] = $false
$myParams["Exclude"] = ".*"
$myArgs = @()
$skippedOptions = @("-l", "-A", "-d")
$isQuoted = $false

Class LongFormatFile 
{
	[string] $Mode;
	[string] $Links;   
	[string] $Owner; 
	[string] $Group;
	[string] $Length;
	[string] $Modified;
	[string] $Name;
	[string] $Extension;

	LongFormatFile([System.IO.FileInfo] $fil, $isQuoted)
	{
		$this.Mode = $fil.Mode
		$this.Links = 1
		try
		{
			$acc = [System.IO.File]::GetAccessControl($fil.FullName)
	
			$this.Owner = $acc.Owner.Split('\')[1]
			$this.Group = $acc.Group.Split('\')[1]
		}
		catch
		{
			$this.Owner = ''
			$this.Group = ''
		}
		$this.Length  = $fil.Length
		$this.Modified = $fil.LastWriteTimeUtc.ToString("MMM dd yyyy HH:mm")
		
		$this.Name = if ($isQuoted)  {'"' + $fil.Name + '"'} else {$fil.Name}
		$this.Extension = $fil.Extension
	}

	LongFormatFile([System.IO.DirectoryInfo] $fil, $isQuoted)
	{
		$this.Mode = $fil.Mode
		$this.Links = 1
		try
		{
			$acc = [System.IO.File]::GetAccessControl($fil.FullName)
	
			$this.Owner = $acc.Owner.Split('\')[1]
			$this.Group = $acc.Group.Split('\')[1]
		}
		catch
		{
			$this.Owner = ''
			$this.Group = ''
		}
		$this.Length  = '-'
		$this.Modified = $fil.LastWriteTimeUtc.ToString("MMM dd yyyy HH:mm")
		$this.Name = if ($isQuoted)  {'"' + $fil.Name + '"'} else {$fil.Name}
		$this.Extension = '.'
	}

}

Class ShortFormatFile 
{
	[string] $Name;

	ShortFormatFile([System.IO.FileInfo] $fil, $isQuoted)
	{
		$this.Name = if ($isQuoted)  {'"' + $fil.Name + '"'} else {$fil.Name}
	}

	ShortFormatFile([System.IO.DirectoryInfo] $fil, $isQuoted)
	{
		$this.Name = if ($isQuoted)  {'"' + $fil.Name + '"'} else {$fil.Name}
	}

}

$ShortFormat = 
{    
	ForEach ($fil in $input)
	{
		Write-Output([ShortFormatFile]::new($fil, $isQuoted))
	}
}

$LongFormat =
{ 
	ForEach ($fil in $input)
	{
		$output = [LongFormatFile]::new($fil, $isQuoted)
		Write-Output($output)
	}
	#return [System.IO.File]::GetAccessControl($dirs[0].FullName).Owner
}


$tryResolve = 
{
	param($arg)
	try
	{
		if (!$skippedOptions.Contains($arg))
		{
			$lsArg = (Get-Command Get-ChildItem).ResolveParameter($arg)            
			$myParams[$lsArg.Name] = $true
			return $true
		}
		return $false
	}
	catch
	{
		return $false
	}
}
foreach($arg in $args)
{
	if ($arg.StartsWith("-"))
	{
		$lsArgs = ""
		if (!$tryResolve.Invoke($arg))
		{
			foreach ($char in $arg.ToString().ToCharArray() | Select-Object -Skip 1)
			{
				switch ($char)
				{
					'l' { 
					$isLong = $true ; Break
					}
					'A' { 
					$myParams["Force"] = $true
					$myParams.Remove("Exclude")
					}
					'a' { 
					$myParams["Force"] = $true
					$myParams.Remove("Exclude")
					}
					'Q' {
					$isQuoted = $true
					}
					'R' {
					$myParams["Recurse"] = $true
					}
					default {
						if (!$tryResolve.Invoke('-' + $char))
						{                        
							$myArgs += $arg
						}
					}
				}
			}
		}
	}
	else
	{
		$myArgs += $arg
	}
}
if ($myArgs.Length -eq 0)
{
	$myArgs += '.'
}

$FormatName = 
{
	switch ($_.Extension)
	{
		'.cs' { $color = "1;32"; break }
		'.cshtml' { $color = "1;7;34;102"; break }
		'.json' { $color = "0;33"; break }
		'.js' { $color = "0;32"; break }
		'.dll' { $color = "0;35"; break }
		'.csproj' { $color = "1;36"; break }
		'.user' { $color = "0;36"; break }
		'.exe' { $color = "1;35"; break }
		'.dll' { $color = "0;35"; break }
		'.config' { $color = "1;33"; break }
		'.' { $color = "1;7;34"; break }
		default { $color = "37" }
	}
	if ($_.Name.StartsWith('.'))
	{
		$color = '4;' + $color
	}
	$e = [char]27
	"$e[${color}m$($_.Name)${e}[0m"
}

foreach ($path in $myArgs)
{
	$myParams.Path = $path
	if ($myArgs.Length -gt 1)
	{
		Write-Output($path + ":")
	}
	Write-Output("total " + $result.Count)
	#Write-Output($myParams)
	if ($isLong)
	{
		&Get-ChildItem @myParams | &$LongFormat | Format-Table -Property Mode,Links,Owner,Group,Length,Modified,@{
			  Label = "Name"
			  Expression =
			  $FormatName
			}
	}
	else
	{
		&Get-ChildItem @myParams | &$ShortFormat | Format-Wide -AutoSize -Property $FormatName
	}

# SIG # Begin signature block
# MIIMgQYJKoZIhvcNAQcCoIIMcjCCDG4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3QNDWF3OtagClZmMrSxr3gGx
# u7+gggfQMIIDLzCCAhegAwIBAgIQE+WWiHsXloFFkHYl/qa6AzANBgkqhkiG9w0B
# AQsFADAfMR0wGwYDVQQDDBR0cmVuY2hpZUB0cmVuY2hpZS51czAeFw0xODEyMDUx
# OTU0MDhaFw0xOTEyMDUyMDE0MDhaMB8xHTAbBgNVBAMMFHRyZW5jaGllQHRyZW5j
# aGllLnVzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAymFyQXs8mLFz
# 4M8ZcAAI/7IAjJC0wvDaQ00/4Ih3b+8nwNUuOCrxhL6gyz/f1rsfeAFkHtLUJBYM
# VPmuXau13xqqJ4CFPPTWS5CJSUwgh3Ii99DL4IJf42sRBtEl028216M0LMehF3PY
# rNXa0VTR72HTOCN8R5+f9HcICtF66LQF+zRhJsl0JcHbTv6UyL55qOqGP6wHJQIs
# 8VRMj861LLXQTQet/KVadpsz2c4LKxMRw2Fi588sUJFX+XZEkpEkskgZ7VhyOLSK
# szYg4jlzF2bbQPYEsx59BgT85jASPYYBULrJeH2aIQJyPOn1XGSYsIG7u97R1n5t
# xaDQc35IsQIDAQABo2cwZTAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHwYDVR0RBBgwFoIUdHJlbmNoaWVAdHJlbmNoaWUudXMwHQYDVR0OBBYE
# FGcP919A+DvTHfpH9p1WOxiNMJVtMA0GCSqGSIb3DQEBCwUAA4IBAQAph3ISDeCZ
# JzQ7nPH6h4ellLSM0TMJoaw0C2ccua+Ox6DnsfL2JKHFbOtCEh6x8WWtiK10zgMR
# PRW9i22seYdGGi4Oov2Rr54b6PsLcnmCecXlyxVJnSruGUe/qFVtpAOhMpDy5dGL
# 7C8Q7rxf3cY3p3UPtFzUmHjmbwwZzOCLY4KOAo8O5CshfNMhIqAw/aoGQmI7VpO1
# pNEawq2uaijjMB44wYVWV3Dr6hR9oKPwQFAhMiok6+MZIzWLhrNTtmsP+Vyx5qxB
# ICxu5cfVgYjWdKmiMNzgF+Kx+CYZzcxdPqJariOS+T54a8c+6IYfMZ9BiUL0INui
# 0Gz2LeIhWJVfMIIEmTCCA4GgAwIBAgIPFojwOSVeY45pFDkH5jMLMA0GCSqGSIb3
# DQEBBQUAMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNh
# bHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAf
# BgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVROLVVT
# RVJGaXJzdC1PYmplY3QwHhcNMTUxMjMxMDAwMDAwWhcNMTkwNzA5MTg0MDM2WjCB
# hDELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
# A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKjAoBgNV
# BAMTIUNPTU9ETyBTSEEtMSBUaW1lIFN0YW1waW5nIFNpZ25lcjCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAOnpPd/XNwjJHjiyUlNCbSLxscQGBGue/YJ0
# UEN9xqC7H075AnEmse9D2IOMSPznD5d6muuc3qajDjscRBh1jnilF2n+SRik4rtc
# Tv6OKlR6UPDV9syR55l51955lNeWM/4Og74iv2MWLKPdKBuvPavql9LxvwQQ5z1I
# Rf0faGXBf1mZacAiMQxibqdcZQEhsGPEIhgn7ub80gA9Ry6ouIZWXQTcExclbhzf
# RA8VzbfbpVd2Qm8AaIKZ0uPB3vCLlFdM7AiQIiHOIiuYDELmQpOUmJPv/QbZP7xb
# m1Q8ILHuatZHesWrgOkwmt7xpD9VTQoJNIp1KdJprZcPUL/4ygkCAwEAAaOB9DCB
# 8TAfBgNVHSMEGDAWgBTa7WR0FJwUPKvdmam9WyhNizzJ2DAdBgNVHQ4EFgQUjmst
# M2v0M6eTsxOapeAK9xI1aogwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAw
# FgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDov
# L2NybC51c2VydHJ1c3QuY29tL1VUTi1VU0VSRmlyc3QtT2JqZWN0LmNybDA1Bggr
# BgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5j
# b20wDQYJKoZIhvcNAQEFBQADggEBALozJEBAjHzbWJ+zYJiy9cAx/usfblD2CuDk
# 5oGtJoei3/2z2vRz8wD7KRuJGxU+22tSkyvErDmB1zxnV5o5NuAoCJrjOU+biQl/
# e8Vhf1mJMiUKaq4aPvCiJ6i2w7iH9xYESEE9XNjsn00gMQTZZaHtzWkHUxY93TYC
# CojrQOUGMAu4Fkvc77xVCf/GPhIudrPczkLv+XZX4bcKBUCYWJpdcRaTcYxlgepv
# 84n3+3OttOe/2Y5vqgtPJfO44dXddZhogfiqwNGAwsTEOYnB9smebNd0+dmX+E/C
# mgrNXo/4GengpZ/E8JIh5i15Jcki+cPwOoRXrToW9GOUEB1d0MYxggQbMIIEFwIB
# ATAzMB8xHTAbBgNVBAMMFHRyZW5jaGllQHRyZW5jaGllLnVzAhAT5ZaIexeWgUWQ
# diX+proDMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQlP0EiQbIWBPftP92Vhi6Se0oddTANBgkq
# hkiG9w0BAQEFAASCAQBJAa5fxAkoilaZCpnhdcmYRceqWKobpp+DLWwE3JPIueDP
# kMkj4dQwO+Whc1vuZInocKmfuxb5zSSZCkYDdl7m/XCUtX73F3a80PWhC03ii3aU
# 56DdA2OT8Jwb40VVhfkat3QCdpHfKWJ6gyZpaxFMnxxvco3oQhKvI5ktmpjVQH4E
# uB6UK1+4Snviqs9nSz9GWlj4h5nsrvsrnZwRk2m0mB+bBngnz5HpiBoSS+dSFYTm
# 50gAQeb36gkTVnH1GQ4ftihU1Fua5hZ6QA/yae+h7fdZyt5FkYVP3V8+Ah2BRy4l
# +MpwTEHAyu1bXa41DHaYA5ccpM25IV22XykdMGl3oYICQzCCAj8GCSqGSIb3DQEJ
# BjGCAjAwggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAV
# BgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
# dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UE
# AxMUVVROLVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTgxMjA1MjAwNDIwWjAjBgkqhkiG9w0BCQQxFgQUfA+G/4DJ4vhBzBgtqLY3+yNV
# mZYwDQYJKoZIhvcNAQEBBQAEggEAxYmujzW/LYPFFVblTQrlYaXLUrTlZqcTu9QL
# efqg3j0VbFMzWfnbBff6yANcfkCP2soJrxIfRw/xM3SN9D7FGzmIcmWjIvsia/Qy
# IcxTAuv3XT4BlNCUySm/LrcvJgTatFowdopq0L+ZMwoK+ZhFuxn3xXJ3X71ZH4Oc
# FYX1dc2wnnY5GCZK5h47TvPF6M0tz94WPmqXmOmsr6nmxpsirwUhaI2FhX6vT2iz
# EWyr40aYpNW/x6oABshuaVLrfg5hg8JNLsWS1mOd/t0SjYfCKRSW2vt7eOj2tZuM
# lEL9jHsACfGiplmGv/FZ9i+6EjJadZNAafWX81kgOtN04xDtsw==
# SIG # End signature block
