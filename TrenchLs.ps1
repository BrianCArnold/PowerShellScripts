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
}
# SIG # Begin signature block
# MIIMpAYJKoZIhvcNAQcCoIIMlTCCDJECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUYr8VJ8rSNoOVwCgo5lw7GkNK
# FLOgggfmMIIDRTCCAjGgAwIBAgIQQ2iLvgg9Z7lH80CpfuU/HzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2Vyc2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xODA4MDYxNDAyMDZaFw0zOTEyMzEyMzU5NTlaMCExHzAdBgNVBAMTFmJhcm5v
# bGQgUG93ZXJzaGVsbCBDU0MwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDl/SRC4SSm9+t6x7mENNfG0JjohwNEx5ntxEp1tkffojdw/yJfdyMFZDohyUQR
# fl6KXBU3ESzDH9WDZpBS66fHGHriTBmFmgFt0lj5a/YwpAwMTyyd4hoiCtqD4Ti4
# 8gnzItq9r5hSXyvlgSt1wEaQUD3HL+tSGeqowTAsD9IZNzzXmR8TBdXd6zqPICQf
# 8/dGfDd987zgBEAebG/LEz5i2k9wYealRJd8L7MhVechXlkJ9+f3cdpTRLGqktQA
# vEX9EGr3QV2eX21vqPFggIiPOgOXOwg1oxT6xHvzJuga2WPve0cQdn57VTAXvSCr
# Mc52ZVX4PmCUY6zA4NodnH1pAgMBAAGjdjB0MBMGA1UdJQQMMAoGCCsGAQUFBwMD
# MF0GA1UdAQRWMFSAEMY7DeuvjUQQlX5oczo+o/ahLjAsMSowKAYDVQQDEyFQb3dl
# cnNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3SCEPvdMUUI8d6RTWgQMRE0I+sw
# CQYFKw4DAh0FAAOCAQEACR9wsRGhl9/V0d68vHTYxIf0TS1cujI6PKBrNxDsyjM3
# agt/Nevr6vtOJfeT3rTnLn64bHlOpO3F5sTKOLDcVheYsAMtw9NpaPjWJ6DhQRFl
# 1Ut2c5Yinny7+Jiy2eDyskWghdHRN0cq9YoM/OBH8oMxms/Ai7keNckP63nn+kdQ
# FiY5kqBfkFnEimOeN4efF7CnFTB5NHHSWuSzlUfdPHjvrWXntbx0Ws2+xwflAhui
# 37nLV1RabOMSd0SkFSO9gYT/XRqmY45ChwqpD2NcniuuJ0vbptVqMN7P8/TnzIlN
# bR/1zH9u8fJpBJldRadtXp/b8YCg+AUHjr5dGd5zlzCCBJkwggOBoAMCAQICDxaI
# 8DklXmOOaRQ5B+YzCzANBgkqhkiG9w0BAQUFADCBlTELMAkGA1UEBhMCVVMxCzAJ
# BgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhl
# IFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVz
# dC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0MB4XDTE1MTIzMTAw
# MDAwMFoXDTE5MDcwOTE4NDAzNlowgYQxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJH
# cmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNP
# TU9ETyBDQSBMaW1pdGVkMSowKAYDVQQDEyFDT01PRE8gU0hBLTEgVGltZSBTdGFt
# cGluZyBTaWduZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDp6T3f
# 1zcIyR44slJTQm0i8bHEBgRrnv2CdFBDfcagux9O+QJxJrHvQ9iDjEj85w+Xeprr
# nN6mow47HEQYdY54pRdp/kkYpOK7XE7+jipUelDw1fbMkeeZedfeeZTXljP+DoO+
# Ir9jFiyj3Sgbrz2r6pfS8b8EEOc9SEX9H2hlwX9ZmWnAIjEMYm6nXGUBIbBjxCIY
# J+7m/NIAPUcuqLiGVl0E3BMXJW4c30QPFc2326VXdkJvAGiCmdLjwd7wi5RXTOwI
# kCIhziIrmAxC5kKTlJiT7/0G2T+8W5tUPCCx7mrWR3rFq4DpMJre8aQ/VU0KCTSK
# dSnSaa2XD1C/+MoJAgMBAAGjgfQwgfEwHwYDVR0jBBgwFoAU2u1kdBScFDyr3Zmp
# vVsoTYs8ydgwHQYDVR0OBBYEFI5rLTNr9DOnk7MTmqXgCvcSNWqIMA4GA1UdDwEB
# /wQEAwIGwDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMEIG
# A1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9VVE4tVVNF
# UkZpcnN0LU9iamVjdC5jcmwwNQYIKwYBBQUHAQEEKTAnMCUGCCsGAQUFBzABhhlo
# dHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQC6MyRA
# QIx821ifs2CYsvXAMf7rH25Q9grg5OaBrSaHot/9s9r0c/MA+ykbiRsVPttrUpMr
# xKw5gdc8Z1eaOTbgKAia4zlPm4kJf3vFYX9ZiTIlCmquGj7woieotsO4h/cWBEhB
# PVzY7J9NIDEE2WWh7c1pB1MWPd02AgqI60DlBjALuBZL3O+8VQn/xj4SLnaz3M5C
# 7/l2V+G3CgVAmFiaXXEWk3GMZYHqb/OJ9/tzrbTnv9mOb6oLTyXzuOHV3XWYaIH4
# qsDRgMLExDmJwfbJnmzXdPnZl/hPwpoKzV6P+Bnp4KWfxPCSIeYteSXJIvnD8DqE
# V606FvRjlBAdXdDGMYIEKDCCBCQCAQEwQDAsMSowKAYDVQQDEyFQb3dlcnNoZWxs
# IExvY2FsIENlcnRpZmljYXRlIFJvb3QCEENoi74IPWe5R/NAqX7lPx8wCQYFKw4D
# AhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZI
# hvcNAQkEMRYEFAbzRMvz9/4oZyRAPhJav5NyA46KMA0GCSqGSIb3DQEBAQUABIIB
# ALxmpWD2c5rCoZVNJFz5Jz8MH3CQiQEYnhE6tjrg1sIRstormvn4jQjjb2brZ+ZV
# 1JEj/HYWKg7zxYd1LuWbsRStsEu+UBs1Cvr0+ApEG64km4dDzeDjJZ6w3Ix6tz0l
# OCe+GjS/uvmQ7b4fWRdm6UN07eDHH+F2l21o3D8Qzk/ePEXeqvzirvQXFRpuRrc7
# W9I+R+Qlip1NYeSawu/bAGyYGKvlMyCWQF6aaHwjvS2cSw7AV70a/OZGgpCYtpJW
# dw+izFJq6vuejiM04llmRdZo1qcubBNVYSlyueKXmFpoCrQB4/R0YNFhWVAr2n1p
# p1Yjk9Aympq7Cm3LGZubtuehggJDMIICPwYJKoZIhvcNAQkGMYICMDCCAiwCAQEw
# gakwgZUxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBM
# YWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UE
# CxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMR0wGwYDVQQDExRVVE4tVVNFUkZp
# cnN0LU9iamVjdAIPFojwOSVeY45pFDkH5jMLMAkGBSsOAwIaBQCgXTAYBgkqhkiG
# 9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xODEwMjUxNDAyMTVa
# MCMGCSqGSIb3DQEJBDEWBBQp9+uSsl/bbcbsJdk0uQ/G/rPQrTANBgkqhkiG9w0B
# AQEFAASCAQC7KW1IIzKinouHMb05kc5gTENXSJwTbwYPGyz3KBlT1iHBBcgVALZB
# MD44vnBZlMI1CUAi7mNNqSBJljtCP2j8Pyy1nX5B9T2OiOtP0XoMMxfKyuzuGViy
# 1uTuWYdHVa0WaYm9XqkOM0vZYiuONMDg+Pt7QyGgEWlhytwIMD28OgGWfNBwybu4
# NkAAILmwJYlvKDkFZIqOk7A9e+IuVGAJxW1aMfqChO/ki5BRYkfsk0IQRYyXgrxb
# 4z7ZB54dm2Ex92xOLRl9ObMyHxYkalauKqhyKkTi1EO9ONZHnXN8d9QmXJdXPPfG
# jvMXjSK9c4E+/aolhlW0CztNpBPAtC86
# SIG # End signature block
