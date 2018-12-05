$cert = New-SelfSignedCertificate -DnsName 'trenchie@trenchie.us' -CertStoreLocation Cert:\LocalMachine\My\ -Type Codesigning
Export-Certificate -Cert $cert -FilePath signing.cer
Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\LocalMachine\Root
Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher\


function SignScript {                                                                                    
        $barnoldCert = (dir cert:LocalMachine\My\ -CodeSigningCert -DnsName "trenchie@trenchie.us")[0]                                     
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
Set-ExecutionPolicy AllSigned -Scope LocalMachine    

ls -R | where {!$_.Name.StartsWith('.') -And !$_.Name.EndsWith('.cer') -And !$_.Name.EndsWith('.bat')} | Copy-Item -Destination (ls $PROFILE).Directory -Force

SignScript (ls $PROFILE).Directory

# SIG # Begin signature block
# MIIMgQYJKoZIhvcNAQcCoIIMcjCCDG4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUiix15WrAkLnz7WkOt8z+KuHm
# QjagggfQMIIDLzCCAhegAwIBAgIQQqHHSQcmD7dJoeQLDkbcjjANBgkqhkiG9w0B
# AQsFADAfMR0wGwYDVQQDDBR0cmVuY2hpZUB0cmVuY2hpZS51czAeFw0xODEyMDUy
# MDAyMzRaFw0xOTEyMDUyMDIyMzRaMB8xHTAbBgNVBAMMFHRyZW5jaGllQHRyZW5j
# aGllLnVzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvKfBB1ie7It0
# 6ZD5jsNEXvpNqsE31IxNvpi+1P56yX8sRFQ7sf1pdyK/Q5fIbbBNY71Ul6HSHoW8
# At8y8hMXBXgP6dHQYASm4rTuKYH5U3qRrI1wmZXvLEPFuWPcjVMARIQa+n0PY5aX
# sd93pHv2/ntK/IxS0lz5cDFSqgaxad7yXnQmab/mvDa+hARSWIsZ6E6hr+pEhpBt
# /4ow0i/hH5Cg6iyvwW93aOvXmgHbgPKJZGHP+nW9+0zTDmN8lkkowldhTrntIEae
# DDL7ZYG593RoDO9tfL6+6B+Sq475fuZz8MPbzJC5PsHeUMmgp3T0F+0lTkhLHxcc
# aOHSJCsIiQIDAQABo2cwZTAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHwYDVR0RBBgwFoIUdHJlbmNoaWVAdHJlbmNoaWUudXMwHQYDVR0OBBYE
# FIe8AJu9r9jv3cTdK6p0Xtxx+oqxMA0GCSqGSIb3DQEBCwUAA4IBAQBzz69Xhi05
# 7F8m/mPFPzwq5Yut1qs5jWWw81nnmZ+UXhCiLtdxB6ynLbmoQQDnEfrrQw22+52x
# yLwL2iPXDs190zkUHCn6AH6CPvakJkgpEeeLSPtUhEcoKfgPVGGtnUT31pjO/6Ia
# q6qzuqlmgaN8dgOyxG6VfJqWOary+K1t2bZ/ym5U3LNnU7tMyamafpvcwOK6VRhK
# Go7cERjLmxcI8MHRVLy7/9/hT/rJQlQLRvqzfnNwlwsN+pQUbZEHhQoQsg1gUWKB
# oB+UysPoHmvs1CyakMleoD16f4y4vP9c71U8LYdi7t2Ctj7izRFi6XOSwR7Xqa9i
# QhJ4erLnNftyMIIEmTCCA4GgAwIBAgIPFojwOSVeY45pFDkH5jMLMA0GCSqGSIb3
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
# ATAzMB8xHTAbBgNVBAMMFHRyZW5jaGllQHRyZW5jaGllLnVzAhBCocdJByYPt0mh
# 5AsORtyOMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ+EvGAbyLaZKarhGjYaRWty4IzwjANBgkq
# hkiG9w0BAQEFAASCAQA7/OrdwCE8lwV/dON4NzemJb7cyBcvuNf5thTgS4c2xwJZ
# 4F1ZER51/bmGNdIHrp1FOMUTw6FuzQqFITNS4i+ylk7EEKF3Oite/CUu5S7Nys8T
# qCYm59CVSm6xO1VbEcO2qDAe1wKuxail+nlvWIrbHCJfLav0KOhKPNpO5rKVdeyn
# 5wjov0Hkq8r58m4a2lAooH2SA+DurYSBH0UeDdm/dMAlIHTZCwLWGHugwWJt5U76
# 6AgUocjU9cKLLT54nlwVERyB0DG5LjHX3R3ba8goXHFPvLdaDPI8JgaOTIMNnDQA
# P7a5Eht9M289fggJCXQ+uUrdEvLBK8zWsfvVPCOToYICQzCCAj8GCSqGSIb3DQEJ
# BjGCAjAwggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAV
# BgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
# dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UE
# AxMUVVROLVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTgxMjA1MjAxMjM3WjAjBgkqhkiG9w0BCQQxFgQUxZsrJjYcj08wsUbro9unNiCF
# uyEwDQYJKoZIhvcNAQEBBQAEggEAQhN6QxJ61b/6M2Ft345AWqwIGXU4NtRnQmh4
# QTVQY/hN8E/qP2WWbPmVTc+SghSXG5RrBzRD+F1nYpEQQKEr4METznwqZzE7VsJK
# VqpoySnsTDnrrb4Sd/0eseFTt3Zv5PGh8KlmDDaeGEIwykkO2jGoGmZUaIThB/WI
# EMG8SxTSb3THM3+Z78Q4vEI81C2pcKcAs6uflYse7j0wF2mCMbJYFzXR2+l1xxjD
# Qcm11EvewHYDAQSLMGBN7A4NoKgH08L31EAmpndDfINo25r3Qee49pt8MsinwFqC
# CdFana4UozpIrENwfXP6XphSPtQbPmJ23BIitytYPqmYP5JUrQ==
# SIG # End signature block
