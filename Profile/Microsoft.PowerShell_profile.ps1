function prompt {
	TrenchPrompt
}

#function prompt
#{
#	Write-Host("PS " + $(pwd)[0].Path + " ") -nonewline -foregroundcolor White
#	$gStatus = $(git status -sb 2> $null)
#	if (($gStatus | measure).Count -eq 1) { $gStatus = @($gStatus) }
#	if ($gStatus -ne $null)
#	{
#
#		$files = $gStatus[1..($gStatus.Length-1)]
#	# M odified
#    # A dded
#    # D eleted
#    # R enamed
#	# C opied
#	# U pdated
#		$unTrackedMod = ($files | Where-Object {$_[1] -eq 'M'}).Count # *
#		$unTrackedDel = ($files | Where-Object {$_[1] -eq 'D'}).Count # -
#		$unTrackedUnk = ($files | Where-Object {$_[1] -eq '?'}).Count # +
#
#
#		$TrackedMod = ($files | Where-Object {$_[0] -eq 'M'}).Count # *
#		$TrackedAdd = ($files | Where-Object {$_[0] -eq 'A'}).Count # ↑
#		$TrackedDel = ($files | Where-Object {$_[0] -eq 'D'}).Count # ↓
#		$TrackedRen = ($files | Where-Object {$_[0] -eq 'R'}).Count # →
#		$TrackedCop = ($files | Where-Object {$_[0] -eq 'C'}).Count # ↕
#		$TrackedUpd = ($files | Where-Object {$_[0] -eq 'U'}).Count # *
#
#
#
#		if ($unTrackedMod -gt 0) {cout($unTrackedMod.ToString() + '*') }
#		if ($unTrackedDel -gt 0) {cout($unTrackedDel.ToString() + '-') }
#		if ($unTrackedUnk -gt 0) {cout($unTrackedUnk.ToString() + '+') }
#		if ($TrackedMod -gt 0) { cout($TrackedMod.ToString() + '#') }
#		if ($TrackedAdd -gt 0) { cout($TrackedAdd.ToString() + '^') }
#		if ($TrackedDel -gt 0) { cout($TrackedDel.ToString() + 'x') }
#		if ($TrackedRen -gt 0) { cout($TrackedRen.ToString() + '>') }
#		if ($TrackedCop -gt 0) { cout($TrackedCop.ToString() + '=') }
#		if ($TrackedUpd -gt 0) { cout($TrackedUpd.ToString() + '#') }
#
#		$branch = $gStatus[0] -replace "## ([^.]+).*", '$1'
#		cout($branch)
#
#
#
#		## master...origin/master [ahead 1, behind 8]
#		if ($gStatus[0] -match "\[.*ahead ([0-9]+).*\]")
#		{
#			if ($Matches[1] -ne $null)
#			{
#				cout(">" + $Matches[1])
#			}
#		}
#		if ($gStatus[0] -match "\[.*behind ([0-9]+).*\]")
#		{
#			if ($Matches[1] -ne $null)
#			{
#				cout("<" + $Matches[1])
#			}
#		}
#
#		cout(" ")
#	}
#	cout("$")
#
#    return " "
#}

$profileDir = (Get-ChildItem $PROFILE)[0].Directory.FullName + "\"

#Set-Alias ffind ($profileDir + "ffind.ps1") -Option AllScope -Scope Global

#Set-Alias ls ($profileDir + "TrenchLs.ps1") -Option AllScope -Scope Global
# SIG # Begin signature block
# MIIMgQYJKoZIhvcNAQcCoIIMcjCCDG4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqrnWwKwQzbglh1G7W1TvcOQG
# 6/OgggfQMIIDLzCCAhegAwIBAgIQE+WWiHsXloFFkHYl/qa6AzANBgkqhkiG9w0B
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
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRcknLYuVqbAoXuuaqgm54dYHPSFjANBgkq
# hkiG9w0BAQEFAASCAQBjDij9S+AyzeDH9VgBsLITPCM58WLRj5TQ7w7pBc/4+N2D
# AfcMfL/f+mQRmIW3B2yhzLpff+goNkJUV/wZEuzOzAEdh68R3XjzJ0ZWMiw9H5LA
# rpZdFJ5RoIV2Neb7e/dfPL1NDoMHV8cxb3VE21atRBbH/Vi7n8AzmiD+fQoHzj38
# cVKmPd8y/eKO9ZQekmJtJUw9fQRRxoYTwsRi0Zq3TFhbn+SbPvjoH9sKdx3g+KiI
# gJNria9s71bwyCkAfFiavBhSpCZaoThmxopGNOEyKtXBt5zCwTKgI8r/3YXsyX5R
# 4dzYp0dlJMYDefBJAkzk7f2c4MAcxzYZs7FweemIoYICQzCCAj8GCSqGSIb3DQEJ
# BjGCAjAwggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAV
# BgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
# dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UE
# AxMUVVROLVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTgxMjA1MjAwNDE3WjAjBgkqhkiG9w0BCQQxFgQUfSDKaHG+XwCV1BYtAKwfimJp
# KhcwDQYJKoZIhvcNAQEBBQAEggEAQLz86dM4f7jbtFUm5nenYQiNCvi3Krq6WBiQ
# kr+kkyHbICrQqL0Eoml/V/almW5MH7ymDGbFecHzUOp5DGiFvLmKq9XT/pUYR6m2
# yzcIcbOFbi96zR2dF7MuWYRMfnVGePISUKAOvhJzFS+hkJps2hfXgpANb48ii5fs
# QHbIOeHPKAOqJQ/NSkYD/X6Jy6keiLd4kVAIOsy7+ZszgeDKsCwSAqq5yLvLNiYo
# 5qmfFd+6/uxiFgJ7HcAE5a8frO3++gxkcxUJuUMCaNJEvlyBEoxuqLhmWgos4q0I
# ujYtvAqcj8GcL59ljyIQ+a2qjCzZe2vcf2yk7482nXogTitoZw==
# SIG # End signature block
