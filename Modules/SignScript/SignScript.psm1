function SignScript {                  
    $barnoldCert = (dir cert:LocalMachine\My\ -CodeSigningCert -DnsName "trenchie@trenchie.us")[0]          
    $loc = @()                                
    foreach ($arg in ($args + $input)) {                                                                                                   
        $startFolder = Get-Location                                                                                                   
        $location = (Get-Item -Path $arg)                                                                                             
        if ($location.Mode.StartsWith("d")) {  
            $loc += $arg
            Set-Location $location                                                                                                
            $childFiles = $location.GetFiles()                                                                                    
            SignScript @childFiles                                                                                                
            $childDirs = $location.GetDirectories()                                                                               
            SignScript @childDirs                                                                                                 
            Set-Location $startFolder
            if ($loc.Length > 1)
            {
                $loc = $loc[0..($loc.Length-2)];
            }   
            else
            {
                $loc = @()
            }                                                                                          
        }                                                                                                                             
        else {                                                                                                                                                
            Write-Host("Signing ") -NoNewline
            Write-Host($arg) -NoNewline
            Write-Host([System.String]::Join("", $loc)) -NoNewline
            $result =Set-AuthenticodeSignature -FilePath $arg -Certificate $barnoldCert -TimestampServer http://timestamp.comodoca.com/authenticode                        
            Write-Host("... ") -NoNewline                                                                                         
            switch ($result.Status) {                                                                                             
                "Valid" { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Green }                    
                Default { Write-Host $result.StatusMessage -ForegroundColor Black -BackgroundColor Red }                      
            }                                                                                                                     
        }                                                                                                                                  
    }                                                                                                                                     
}     

Export-ModuleMember -Function SignScript
