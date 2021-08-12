<#
    .SYNOPSIS
        Script to gather a collection of tools used by the AppSec team during different kind of assessments.
        All tools must be portable!
        Target machine is a WINDOWS
    .EXAMPLE
        Build-Tookit 
    .LINK
        https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-5.1
#>
###############################
# Program constants
###############################
New-Variable -Name WorkFolder -Value "work" -Option Constant
New-Variable -Name TKArchiveName -Value "Toolkit.zip" -Option Constant

###############################
# Utility internal functions
###############################

function Get-RemoteFile {
    param(
        [String]
        $Uri,
        [String]
        $OutFile,
        [switch] 
        $UseClassicWay      
    )
    # See https://adamtheautomator.com/powershell-download-file/
    if ($UseClassicWay) {
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing
    }
    else {
        Start-BitsTransfer -Source $Uri -Destination $OutFile -TransferType Download
    }

}

function Add-FFUF {
    Write-Host ">> Add FFUF..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/ffuf/ffuf/releases/download/v1.3.1/ffuf_1.3.1_windows_amd64.zip" -OutFile "$WorkFolder\ffuf.zip"
    Expand-Archive -LiteralPath "$WorkFolder\ffuf.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\ffuf.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-BurpCE {
    Write-Host ">> Add Burp Community Edition..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://portswigger.net/burp/releases/download?product=community&version=2021.8&type=Jar" -OutFile "$WorkFolder\burp.jar"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-JDK {
    Write-Host ">> Add Java JDK 64 bits..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_windows_hotspot_11.0.12_7.zip" -OutFile "$WorkFolder\jdk.zip"
    Expand-Archive -LiteralPath "$WorkFolder\jdk.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\jdk.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-SecListsRepoCopy {
    Write-Host ">> Add SecLists repo copy..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip" -OutFile "$WorkFolder\seclists.zip" -UseClassicWay
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-DNSpy {
    Write-Host ">> Add DNSpy..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/dnSpy/dnSpy/releases/download/v6.1.8/dnSpy-net-win64.zip" -OutFile "$WorkFolder\dnspy.zip"
    Expand-Archive -LiteralPath "$WorkFolder\dnspy.zip" -DestinationPath "$WorkFolder\DNSpy"
    Remove-Item "$WorkFolder\dnspy.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-JDGUI {
    Write-Host ">> Add JDGUI..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-windows-1.6.6.zip" -OutFile "$WorkFolder\jdgui.zip"
    Expand-Archive -LiteralPath "$WorkFolder\jdgui.zip" -DestinationPath "$WorkFolder\JDGUI"
    Get-RemoteFile -Uri "https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.jar" -OutFile "$WorkFolder\JDGUI\jd-gui.jar"
    Remove-Item "$WorkFolder\jdgui.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-NotepadPP {
    Write-Host ">> Add Notepad++..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.1.2/npp.8.1.2.portable.x64.zip" -OutFile "$WorkFolder\npp.zip"
    Expand-Archive -LiteralPath "$WorkFolder\npp.zip" -DestinationPath "$WorkFolder\NotepadPP"
    Remove-Item "$WorkFolder\npp.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-VSCode {
    Write-Host ">> Add VS Code..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive" -OutFile "$WorkFolder\vscode.zip"
    Expand-Archive -LiteralPath "$WorkFolder\vscode.zip" -DestinationPath "$WorkFolder\VSCode"
    Remove-Item "$WorkFolder\vscode.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Browsers {
    Write-Host ">> Add portable browsers..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://portableapps.com/downloading/?a=FirefoxPortable&n=Mozilla%20Firefox,%20Portable%20Edition&s=s&p=&d=pa&f=FirefoxPortable_91.0_English.paf.exe" -OutFile "$WorkFolder\firefox-portable.exe" -UseClassicWay
    Get-RemoteFile -Uri "https://download-chromium.appspot.com/dl/Win_x64?type=snapshots" -OutFile "$WorkFolder\chromium-portable.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-KeyStoreExplorer {
    Write-Host ">> Add KeyStoreExplorer..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/kaikramer/keystore-explorer/releases/download/v5.4.4/kse-544.zip" -OutFile "$WorkFolder\kse.zip"
    Expand-Archive -LiteralPath "$WorkFolder\kse.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\kse.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-GitPortable {
    Write-Host ">> Add GitPortable..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/git-for-windows/git/releases/download/v2.32.0.windows.2/MinGit-2.32.0.2-64-bit.zip" -OutFile "$WorkFolder\gitportable.zip"
    Expand-Archive -LiteralPath "$WorkFolder\gitportable.zip" -DestinationPath "$WorkFolder\GitPortable"
    Remove-Item "$WorkFolder\gitportable.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Sysinternals {
    Write-Host ">> Add Sysinternals..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "$WorkFolder\sysint.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sysint.zip" -DestinationPath "$WorkFolder\Sysinternals"
    Remove-Item "$WorkFolder\sysint.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Wireshark {
    Write-Host ">> Add Wireshark..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://1.eu.dl.wireshark.org/win32/WiresharkPortable_3.4.7.paf.exe" -OutFile "$WorkFolder\wireshark-portable.exe"
    Write-Host "<< Added!" -ForegroundColor Yellow
}


###############################
# Main section
###############################
Clear-Host
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "[+] Init..." -ForegroundColor Yellow
Remove-Item $WorkFolder -ErrorAction Ignore -Force -Recurse
Remove-Item $TKArchiveName -ErrorAction Ignore -Force
New-Item -ItemType "directory" -Path $WorkFolder
Write-Host "[+] Add tools:" -ForegroundColor Yellow
Add-FFUF
Add-BurpCE
Add-JDK
Add-DNSpy
Add-JDGUI
Add-NotepadPP
Add-VSCode
Add-Browsers
Add-KeyStoreExplorer
Add-GitPortable
Add-Sysinternals
Add-Wireshark
#Add-SecListsRepoCopy
Write-Host "[+] Little cleanup prior to create the archive..." -ForegroundColor Yellow
Remove-Item $WorkFolder\*.md -ErrorAction Ignore -Force
Remove-Item $WorkFolder\LICENSE -ErrorAction Ignore -Force
Write-Host "[+] Create the archive..." -ForegroundColor Yellow
Compress-Archive -Path $WorkFolder -DestinationPath $TKArchiveName
$stopwatch.Stop()
$processingTime = $stopwatch.Elapsed.Minutes
Write-Host "[+] Processing finished in $processingTime minutes!" -ForegroundColor Yellow
Get-FileHash -Algorithm SHA256 $TKArchiveName