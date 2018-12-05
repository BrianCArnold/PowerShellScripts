if (((ls Cert:\LocalMachine\My | where { $_.Subject -eq "CN=trenchie@trenchie.us" } ).Count -lt 1) -And (($PSVersionTable.PSVersion).Major -lt 6)) 
{
        $cert = New-SelfSignedCertificate -DnsName 'trenchie@trenchie.us' -CertStoreLocation Cert:\LocalMachine\My\ -Type Codesigning
        Export-Certificate -Cert $cert -FilePath signing.cer
        Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\LocalMachine\Root
        Import-Certificate -FilePath .\signing.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher\
}