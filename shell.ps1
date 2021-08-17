# Configure a PS shell for the tool kit usage
# Identity dynamically the tools path
Remove-Item alias:curl
Remove-Item alias:wget
$base = $pwd
Set-Location .\Python
$pythonLoc = "${pwd}"
Set-Location $base
"home = ${pythonLoc}" | Out-File -FilePath .\PythonEnv\pyvenv.cfg -Encoding "utf8"
"include-system-site-packages = false" | Out-File -FilePath .\PythonEnv\pyvenv.cfg -Append -Encoding "utf8"
"version = 3.7.9" | Out-File -FilePath .\PythonEnv\pyvenv.cfg -Append -Encoding "utf8"
.\PythonEnv\Scripts\Activate.ps1
Set-Location .\jdk-*
$jdkLoc = "${pwd}"
$env:JAVA_HOME = "${pwd}"
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $pwd, [System.EnvironmentVariableTarget]::User)
Set-Location $base
Set-Location .\PortScan\nmap-*
$nmapLoc = "${pwd}"
Set-Location $base
$env:PATH += ";${pwd};${pwd}\PortScan;${nmapLoc};${pwd}\Wget\bin;${jdkLoc}\bin;"
Set-Location $base
Set-Location .\Curl\curl-*\bin\
$env:PATH += ";${pwd};"
Set-Location $base
Write-Host "[+] Environement:" -ForegroundColor Yellow
python --version
java.exe --version
javac.exe --version
curl.exe --version
wget.exe --version
nmap.exe --version
naabu.exe -version
Write-Host "[+] Toolkit base:" -ForegroundColor Yellow
$base
