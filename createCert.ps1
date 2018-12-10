if (((ls Cert:\LocalMachine\My | where { $_.Subject -eq "CN=" + $env:USERNAME + "@" + $env:COMPUTERNAME } ).Count -lt 1) -And (($PSVersionTable.PSVersion).Major -lt 6))
{
        $cert = New-SelfSignedCertificate -DnsName ($env:USERNAME + "@" + $env:COMPUTERNAME) -CertStoreLocation Cert:\LocalMachine\My\ -Type Codesigning
        Export-Certificate -Cert $cert -FilePath signing.cer
        Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\LocalMachine\Root
        Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher\
        Remove-Item .\signing.cer
}
