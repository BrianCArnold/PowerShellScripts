@echo off
"powershell.exe" Set-ExecutionPolicy RemoteSigned -Scope Process -Force; iex (dir createCert.ps1)[0]; iex (dir publish.ps1)[0];
