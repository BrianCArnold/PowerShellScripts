 
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
            $result =Set-AuthenticodeSignature -FilePath $arg -Certificate $barnoldCert -TimestampServer http://timestamp.comodoca.com/authenticode                        
            Write-Host("... ") -NoNewline                                                                                         
            switch ($result.Status) {                                                                                             
                "Valid" { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Green }                    
                Default { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Red }                      
            }                                                                                                                     
        }                                                                                                                             
    }                                                                                                                                     
}     

Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force 2> $null

Copy-Item -Recurse -Force .\Profile\* -Destination $PROFILE.Replace($PROFILE.Substring($PROFILE.LastIndexOf('\')+1), '')

SignScript (ls $PROFILE).Directory