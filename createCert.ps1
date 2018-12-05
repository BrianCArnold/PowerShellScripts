$cert = New-SelfSignedCertificate -DnsName 'trenchie@trenchie.us' -CertStoreLocation Cert:\CurrentUser\My\ -Type Codesigning
Export-Certificate -Cert $cert -FilePath signing.cer
Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\CurrentUser\Root


function SignScript {                                                                                    
        $barnoldCert = (dir cert:currentuser\my\ -CodeSigningCert -DnsName "trenchie@trenchie.us")[0]                                     
        foreach ($arg in ($args + $input)) {                                                                                                  
                $startFolder = Get-Location                                                                                                   
                Write-Host("Signing ") -NoNewline                                                                                             
                Write-Host($arg) -NoNewline                                                                                                   
                $location = (Get-Item -Path $arg)                                                                                             
                if ($location.Mode.StartsWith("d")) {                                                                                         
                        Write-Host("/")                                                                                                       
                        Set-Location $location                                                                                                
                        $childFiles = $location.GetFiles()                                                                                    
                        SignScript @childFiles                                                                                                
                        $childDirs = $location.GetDirectories()                                                                               
                        SignScript @childDirs                                                                                                 
                        Set-Location $startFolder                                                                                             
                }                                                                                                                             
                else {                                                                                                                        
                        $result = Set-AuthenticodeSignature $arg $barnoldCert -TimestampServer http://timestamp.comodoca.com/authenticode     
                        Write-Host("... ") -NoNewline                                                                                         
                        switch ($result.Status) {                                                                                             
                                "Valid" { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Green }                    
                                Default { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Red }                      
                        }                                                                                                                     
                }                                                                                                                             
        }                                                                                                                                     
}                                                                                                                                             

SignScript .
# SIG # Begin signature block
# MIIMgQYJKoZIhvcNAQcCoIIMcjCCDG4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUN1O1YtQ/K9ANFT8R75hp4B8W
# 4gugggfQMIIDLzCCAhegAwIBAgIQE+WWiHsXloFFkHYl/qa6AzANBgkqhkiG9w0B
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
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS8zJR5vUCuuG/yHLt5Is0Mi31PyDANBgkq
# hkiG9w0BAQEFAASCAQAXPlKtXWpdvgtbIrpupLCGUV1PVJBRFKCrdd0/ihIZ/cHl
# mI2sHXOaSCvwZZkkhgIKoYIHZbICf9lo3Yz/nCI9JGq+zDO+O42AHbJiCvz4DcM3
# G1gSzLC+Ff4w22rW1PNJ/5nNx18QDhrO7o+1RBCmNyliGfnbxTIRWYo5dIRgDO8M
# TblaKPw7A92/vzEe9XYKTn4Tv8IZEPtBRsmUK2+WAiycU2chi1rBdJpVwRdggqPC
# AhzZnXHMyKED6EE+FmbvKIZXGocxYWj3U8O2tHOiu1YKNJmcQd0oyuOekGbiNw20
# nzrh1zRowCEQGbZ3wPiaPNNnjMnSZ/HC3fm2w4TOoYICQzCCAj8GCSqGSIb3DQEJ
# BjGCAjAwggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAV
# BgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
# dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UE
# AxMUVVROLVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTgxMjA1MjAwNDExWjAjBgkqhkiG9w0BCQQxFgQUC6N/75yOt0dmlJGO0ARlc9p+
# 5RcwDQYJKoZIhvcNAQEBBQAEggEAQ4mJCMFA7CrgQKtjrEUfC+Pu1Z9IMzUWjMA4
# dz8G0AYOVw7alIEe3prsfFpACDhgoPlXu1t3ZjrKmNPNzwvoqXa789/BIkMJcQpT
# UUTZiPwxtF0HZaauqqYPAzXXzBX5DsR2TZeUC5XL/c1iExKdN1xnepAbCEBXhk80
# /kkmHfyyiJevxfoVOguaY86nIDjPVHke9EgMMzy2AU123R/prFr4b0BTliS/4wSp
# +KEAKYsi/5+UTm+Jm4+nJVTEkJu7nZWNixvrr34RIEQRgDiHPSYgukce+fw0lI3C
# d2JcEON+po2HIz7Cn9maE03YHWFeQxoF1vhnMds5mjwlpP3H4w==
# SIG # End signature block
