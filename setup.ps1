function setMSGTemp($message){
	$progressBarValue = Get-Content -Path "$env:APPDATA\EmuDeck\msg.log" -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+1

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii "$env:APPDATA\EmuDeck\msg.log"
	Write-Output $message
	Add-Content "$env:APPDATA\EmuDeck\msg.log" "# $message" -NoNewline -Encoding UTF8
	Start-Sleep -Seconds 0.5
}
setMSGTemp 'Creating configuration files. please wait'

Write-Output "" > "$env:USERPROFILE\EmuDeck\logs\EmuDeckSetup.log"

Start-Sleep -Seconds 1.5

Start-Transcript "$env:USERPROFILE\EmuDeck\logs\EmuDeckSetup.log"

#We install 7zip - Now its on the appimage
#winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements

# JSON Parsing to ps1 file

. "$env:APPDATA\EmuDeck\backend\functions\JSONtoPS1.ps1"
JSONtoPS1


#
# Functions, settings and vars
#

. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

setScreenDimensionsScale

mkdir "$emulationPath" -ErrorAction SilentlyContinue
mkdir "$biosPath" -ErrorAction SilentlyContinue
mkdir "$toolsPath" -ErrorAction SilentlyContinue
mkdir "$toolsPath\launchers" -ErrorAction SilentlyContinue
mkdir "$savesPath" -ErrorAction SilentlyContinue

#
# Installation
#
#
#Clear old installation msg log
Remove-Item "$userFolder\AppData\Roaming\EmuDeck\msg.log" -ErrorAction SilentlyContinue
Write-Output "Installing, please stand by..."
Write-Output ""

copyFromTo "$env:APPDATA\EmuDeck\backend\roms" "$romsPath"


#Dowloading..ESDE
$test=Test-Path -Path "$esdePath\EmulationStation.exe"
if(-not($test) -and $doInstallESDE -eq "true" ){
	ESDE_install
}

$test=Test-Path -Path "$env:USERPROFILE\EmuDeck\Pegasus\pegasus-fe.exe"
if(-not($test) -and $doInstallPegasus -eq "true" ){
	pegasus_install
}

#SRM
SRM_install


#
# Emulators Download
#

#RetroArch
$test=Test-Path -Path "$emusPath\RetroArch\RetroArch.exe"
if(-not($test) -and $doInstallRA -eq "true" ){
	RetroArch_install
}

#Dolphin
$test=Test-Path -Path "$emusPath\Dolphin-x64\Dolphin.exe"
if(-not($test) -and $doInstallDolphin -eq "true" ){
	Dolphin_install
}

#PCSX2
$test=Test-Path -Path "$emusPath\PCSX2-Qt\pcsx2-qtx64-avx2.exe"
if(-not($test) -and $doInstallPCSX2 -eq "true" ){
	PCSX2QT_install
}

#RPCS3
$test=Test-Path -Path "$emusPath\RPCS3\rpcs3.exe"
if(-not($test) -and $doInstallRPCS3 -eq "true" ){
	RPCS3_install
}

#Xemu
$test=Test-Path -Path "$emusPath\xemu\xemu.exe"
if(-not($test) -and $doInstallXemu -eq "true" ){
	Xemu_install
}

#Yuzu
$test=Test-Path -Path "$emusPath\yuzu\yuzu-windows-msvc\yuzu.exe"
if(-not($test) -and $doInstallYuzu -eq "true" ){
	Yuzu_install
}

#Citra
$test=Test-Path -Path "$emusPath\citra\citra-qt.exe"
if(-not($test) -and $doInstallCitra -eq "true" ){
	Citra_install
}
#melonDS
$test=Test-Path -Path "$emusPath\melonDS\melonDS.exe"
if(-not($test) -and $doInstallmelonDS -eq "true" ){
	melonDS_install
}

#Ryujinx
$test=Test-Path -Path "$emusPath\Ryujinx\Ryujinx.exe"
if(-not($test) -and $doInstallRyujinx -eq "true" ){
	Ryujinx_install
}

#DuckStation
$test=Test-Path -Path "$emusPath\duckstation\duckstation-qt-x64-ReleaseLTCG.exe"
if(-not($test) -and $doInstallDuck -eq "true" ){
	DuckStation_install
}

#Cemu
$test=Test-Path -Path "$emusPath\cemu\Cemu.exe"
if(-not($test) -and $doInstallCemu -eq "true" ){
	Cemu_install
}

#Xenia
$test=Test-Path -Path "$emusPath\xenia\xenia.exe"
if(-not($test) -and $doInstallXenia -eq "true" ){
	Xenia_install
}

#Vita3K
$test=Test-Path -Path "$emusPath\Vita3K\Vita3K.exe"
if(-not($test) -and $doInstallVita3K -eq "true" ){
	Vita3K_install
}

#MAME
$test=Test-Path -Path "$emusPath\mame\mame.exe"
if(-not($test) -and $doInstallMAME -eq "true" ){
	MAME_install
}

#Primehack
$test=Test-Path -Path "$emusPath\Primehack\Primehack.exe"
if(-not($test) -and $doInstallPrimehack -eq "true" ){
	Primehack_install
}

#PPSSPP
$test=Test-Path -Path "$emusPath\ppsspp_win\PPSSPPWindows64.exe"
if(-not($test) -and $doInstallPPSSPP -eq "true" ){
	PPSSPP_install
}
#mGBA
$test=Test-Path -Path "$emusPath\mgba\mgba.exe"
if(-not($test) -and $doInstallMGBA -eq "true" ){
	mGBA_install
}

#Scumm
$test=Test-Path -Path "$emusPath\scummvm\scummvm.exe"
if(-not($test) -and $doInstallScummVM -eq "true" ){
	ScummVM_install
}

#
# Emus Configuration
#

setMSG 'Configuring Emulators'

if ( "$doSetupESDE" -eq "true" ){
	ESDE_init
	#$setupSaves+="ESDE_setupSaves;"
}

if ( "$doSetupPegasus" -eq "true" ){
	pegasus_init
}

if ( "$doSetupSRM" -eq "true" ){
	SRM_init
}

$setupSaves=''
if ( "$doSetupRA" -eq "true" ){
	RetroArch_init
	$setupSaves+="RetroArch_setupSaves;"
}

if ( "$doSetupDuck" -eq "true" ){
	DuckStation_init
	$setupSaves+="DuckStation_setupSaves;"
}

if ( "$doSetupDolphin" -eq "true" ){
	Dolphin_init
	$setupSaves+="Dolphin_setupSaves;"
}

if ( "$doSetupYuzu" -eq "true" ){
	Yuzu_init
	$setupSaves+="Yuzu_setupSaves;"
}

if ( "$doSetupRyujinx" -eq "true" ){
	Ryujinx_init
	$setupSaves+="Ryujinx_setupSaves;"
}

if ( "$doSetupCitra" -eq "true" ){
	Citra_init
	$setupSaves+="Citra_setupSaves;"
}

if ( "$doSetupCemu" -eq "true" ){
	Cemu_init
	$setupSaves+="Cemu_setupSaves;"
}

if ( "$doSetupPCSX2" -eq "true" ){
	PCSX2QT_init
	$setupSaves+="PCSX2QT_setupSaves;"
}

if ( "$doSetupRPCS3" -eq "true" ){
	RPCS3_init
	$setupSaves+="RPCS3_setupSaves;"
}


if ( "$doSetupPPSSPP" -eq "true" ){
	PPSSPP_init
	$setupSaves+="PPSSPP_setupSaves;"
}


if ( "$doSetupmelonDS" -eq "true" ){
	melonDS_init
	$setupSaves+="melonDS_setupSaves;"
}

if ( "$doSetupXemu" -eq "true" ){
	Xemu_init
	$setupSaves+="Xemu_setupSaves;"
}

if ( "$doSetupXenia" -eq "true" ){
	Xenia_init
	$setupSaves+="Xenia_setupSaves;"
}

if ( "$doSetupVita3K" -eq "true" ){
	Vita3K_init
	$setupSaves+="Vita3K_setupSaves;"
}

if ( "$doSetupScummVM" -eq "true" ){
	ScummVM_init
	$setupSaves+="ScummVM_setupSaves;"
}

if ( "$doSetupMGBA" -eq "true" ){
	mGBA_init
	$setupSaves+="mGBA_setupSaves;"
}

setMSG 'Configuring Save folders'
$setupSaves = $setupSaves.Substring(0, $setupSaves.Length - 1)
Invoke-Expression $setupSaves

autofix_areInstalled

Stop-Transcript

# SIG # Begin signature block
# MIIvNgYJKoZIhvcNAQcCoIIvJzCCLyMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAZLBYM0157OV2R
# Xg1EDLx9cJJnW6VaPlD6ARa7YNAkH6CCE00wggXJMIIEsaADAgECAhAbtY8lKt8j
# AEkoya49fu0nMA0GCSqGSIb3DQEBDAUAMH4xCzAJBgNVBAYTAlBMMSIwIAYDVQQK
# ExlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMScwJQYDVQQLEx5DZXJ0dW0gQ2Vy
# dGlmaWNhdGlvbiBBdXRob3JpdHkxIjAgBgNVBAMTGUNlcnR1bSBUcnVzdGVkIE5l
# dHdvcmsgQ0EwHhcNMjEwNTMxMDY0MzA2WhcNMjkwOTE3MDY0MzA2WjCBgDELMAkG
# A1UEBhMCUEwxIjAgBgNVBAoTGVVuaXpldG8gVGVjaG5vbG9naWVzIFMuQS4xJzAl
# BgNVBAsTHkNlcnR1bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEkMCIGA1UEAxMb
# Q2VydHVtIFRydXN0ZWQgTmV0d29yayBDQSAyMIICIjANBgkqhkiG9w0BAQEFAAOC
# Ag8AMIICCgKCAgEAvfl4+ObVgAxknYYblmRnPyI6HnUBfe/7XGeMycxca6mR5rlC
# 5SBLm9qbe7mZXdmbgEvXhEArJ9PoujC7Pgkap0mV7ytAJMKXx6fumyXvqAoAl4Va
# qp3cKcniNQfrcE1K1sGzVrihQTib0fsxf4/gX+GxPw+OFklg1waNGPmqJhCrKtPQ
# 0WeNG0a+RzDVLnLRxWPa52N5RH5LYySJhi40PylMUosqp8DikSiJucBb+R3Z5yet
# /5oCl8HGUJKbAiy9qbk0WQq/hEr/3/6zn+vZnuCYI+yma3cWKtvMrTscpIfcRnNe
# GWJoRVfkkIJCu0LW8GHgwaM9ZqNd9BjuiMmNF0UpmTJ1AjHuKSbIawLmtWJFfzcV
# WiNoidQ+3k4nsPBADLxNF8tNorMe0AZa3faTz1d1mfX6hhpneLO/lv403L3nUlbl
# s+V1e9dBkQXcXWnjlQ1DufyDljmVe2yAWk8TcsbXfSl6RLpSpCrVQUYJIP4ioLZb
# MI28iQzV13D4h1L92u+sUS4Hs07+0AnacO+Y+lbmbdu1V0vc5SwlFcieLnhO+Nqc
# noYsylfzGuXIkosagpZ6w7xQEmnYDlpGizrrJvojybawgb5CAKT41v4wLsfSRvbl
# jnX98sy50IdbzAYQYLuDNbdeZ95H7JlI8aShFf6tjGKOOVVPORa5sWOd/7cCAwEA
# AaOCAT4wggE6MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFLahVDkCw6A/joq8
# +tT4HKbROg79MB8GA1UdIwQYMBaAFAh2zcsH/yT2xc3tu5C84oQ3RnX3MA4GA1Ud
# DwEB/wQEAwIBBjAvBgNVHR8EKDAmMCSgIqAghh5odHRwOi8vY3JsLmNlcnR1bS5w
# bC9jdG5jYS5jcmwwawYIKwYBBQUHAQEEXzBdMCgGCCsGAQUFBzABhhxodHRwOi8v
# c3ViY2Eub2NzcC1jZXJ0dW0uY29tMDEGCCsGAQUFBzAChiVodHRwOi8vcmVwb3Np
# dG9yeS5jZXJ0dW0ucGwvY3RuY2EuY2VyMDkGA1UdIAQyMDAwLgYEVR0gADAmMCQG
# CCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJKoZIhvcNAQEM
# BQADggEBAFHCoVgWIhCL/IYx1MIy01z4S6Ivaj5N+KsIHu3V6PrnCA3st8YeDrJ1
# BXqxC/rXdGoABh+kzqrya33YEcARCNQOTWHFOqj6seHjmOriY/1B9ZN9DbxdkjuR
# mmW60F9MvkyNaAMQFtXx0ASKhTP5N+dbLiZpQjy6zbzUeulNndrnQ/tjUoCFBMQl
# lVXwfqefAcVbKPjgzoZwpic7Ofs4LphTZSJ1Ldf23SIikZbr3WjtP6MZl9M7JYjs
# NhI9qX7OAo0FmpKnJ25FspxihjcNpDOO16hO0EoXQ0zF8ads0h5YbBRRfopUofbv
# n3l6XYGaFpAP4bvxSgD5+d2+7arszgowgga5MIIEoaADAgECAhEAmaOACiZVO2Wr
# 3G6EprPqOTANBgkqhkiG9w0BAQwFADCBgDELMAkGA1UEBhMCUEwxIjAgBgNVBAoT
# GVVuaXpldG8gVGVjaG5vbG9naWVzIFMuQS4xJzAlBgNVBAsTHkNlcnR1bSBDZXJ0
# aWZpY2F0aW9uIEF1dGhvcml0eTEkMCIGA1UEAxMbQ2VydHVtIFRydXN0ZWQgTmV0
# d29yayBDQSAyMB4XDTIxMDUxOTA1MzIxOFoXDTM2MDUxODA1MzIxOFowVjELMAkG
# A1UEBhMCUEwxITAfBgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMgUy5BLjEkMCIG
# A1UEAxMbQ2VydHVtIENvZGUgU2lnbmluZyAyMDIxIENBMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAnSPPBDAjO8FGLOczcz5jXXp1ur5cTbq96y34vuTm
# flN4mSAfgLKTvggv24/rWiVGzGxT9YEASVMw1Aj8ewTS4IndU8s7VS5+djSoMcbv
# IKck6+hI1shsylP4JyLvmxwLHtSworV9wmjhNd627h27a8RdrT1PH9ud0IF+njvM
# k2xqbNTIPsnWtw3E7DmDoUmDQiYi/ucJ42fcHqBkbbxYDB7SYOouu9Tj1yHIohzu
# C8KNqfcYf7Z4/iZgkBJ+UFNDcc6zokZ2uJIxWgPWXMEmhu1gMXgv8aGUsRdaCtVD
# 2bSlbfsq7BiqljjaCun+RJgTgFRCtsuAEw0pG9+FA+yQN9n/kZtMLK+Wo837Q4QO
# ZgYqVWQ4x6cM7/G0yswg1ElLlJj6NYKLw9EcBXE7TF3HybZtYvj9lDV2nT8mFSkc
# SkAExzd4prHwYjUXTeZIlVXqj+eaYqoMTpMrfh5MCAOIG5knN4Q/JHuurfTI5XDY
# O962WZayx7ACFf5ydJpoEowSP07YaBiQ8nXpDkNrUA9g7qf/rCkKbWpQ5boufUnq
# 1UiYPIAHlezf4muJqxqIns/kqld6JVX8cixbd6PzkDpwZo4SlADaCi2JSplKShBS
# ND36E/ENVv8urPS0yOnpG4tIoBGxVCARPCg1BnyMJ4rBJAcOSnAWd18Jx5n858JS
# qPECAwEAAaOCAVUwggFRMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFN10XUwA
# 23ufoHTKsW73PMAywHDNMB8GA1UdIwQYMBaAFLahVDkCw6A/joq8+tT4HKbROg79
# MA4GA1UdDwEB/wQEAwIBBjATBgNVHSUEDDAKBggrBgEFBQcDAzAwBgNVHR8EKTAn
# MCWgI6Ahhh9odHRwOi8vY3JsLmNlcnR1bS5wbC9jdG5jYTIuY3JsMGwGCCsGAQUF
# BwEBBGAwXjAoBggrBgEFBQcwAYYcaHR0cDovL3N1YmNhLm9jc3AtY2VydHVtLmNv
# bTAyBggrBgEFBQcwAoYmaHR0cDovL3JlcG9zaXRvcnkuY2VydHVtLnBsL2N0bmNh
# Mi5jZXIwOQYDVR0gBDIwMDAuBgRVHSAAMCYwJAYIKwYBBQUHAgEWGGh0dHA6Ly93
# d3cuY2VydHVtLnBsL0NQUzANBgkqhkiG9w0BAQwFAAOCAgEAdYhYD+WPUCiaU58Q
# 7EP89DttyZqGYn2XRDhJkL6P+/T0IPZyxfxiXumYlARMgwRzLRUStJl490L94C9L
# GF3vjzzH8Jq3iR74BRlkO18J3zIdmCKQa5LyZ48IfICJTZVJeChDUyuQy6rGDxLU
# UAsO0eqeLNhLVsgw6/zOfImNlARKn1FP7o0fTbj8ipNGxHBIutiRsWrhWM2f8pXd
# d3x2mbJCKKtl2s42g9KUJHEIiLni9ByoqIUul4GblLQigO0ugh7bWRLDm0CdY9rN
# LqyA3ahe8WlxVWkxyrQLjH8ItI17RdySaYayX3PhRSC4Am1/7mATwZWwSD+B7eMc
# ZNhpn8zJ+6MTyE6YoEBSRVrs0zFFIHUR08Wk0ikSf+lIe5Iv6RY3/bFAEloMU+vU
# BfSouCReZwSLo8WdrDlPXtR0gicDnytO7eZ5827NS2x7gCBibESYkOh1/w1tVxTp
# V2Na3PR7nxYVlPu1JPoRZCbH86gc96UTvuWiOruWmyOEMLOGGniR+x+zPF/2DaGg
# K2W1eEJfo2qyrBNPvF7wuAyQfiFXLwvWHamoYtPZo0LHuH8X3n9C+xN4YaNjt2yw
# zOr+tKyEVAotnyU9vyEVOaIYMk3IeBrmFnn0gbKeTTyYeEEUz/Qwt4HOUBCrW602
# NCmvO1nm+/80nLy5r0AZvCQxaQ4wgga/MIIEp6ADAgECAhBUsN7LB9L4KOkgMXsJ
# G1QIMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhBc3Nl
# Y28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0NlcnR1bSBDb2RlIFNpZ25p
# bmcgMjAyMSBDQTAeFw0yMzEyMTUxMjQ0NTZaFw0yNDEyMTQxMjQ0NTVaMGUxCzAJ
# BgNVBAYTAkVTMRQwEgYDVQQHDAtWaWxsYWxiaWxsYTEfMB0GA1UECgwWUm9kcmln
# byBTZWRhbm8gSmltZW5lejEfMB0GA1UEAwwWUm9kcmlnbyBTZWRhbm8gSmltZW5l
# ejCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAI2GNPfNadWxZpICb9kW
# U0McDTx7bNxB6ErCPppAGMUFrU7DLnJ8UKDN+sfe4rm+pyghIYLQqHMvPQ54EJeq
# Zs5geqXFvlEenXuwiJs1t4UO0yD+Gbjk32P0q2B8Y0/Lxin4z9EAi1LYvwIh6kEN
# auDg7VBOYl0tDmWKP6mqaqkpGXK/ltgaskS9oR0mXIz1bOcXE6bAfMdvvfwq+YHY
# Lrqq6qjqAL1FvXVC5u32rXlex6yS4rJ5C0s3WuDyQlqfNHm9a8QOzcGitXf2b9GQ
# D2TENA0VrwENaVZGMhm1pmg9yZ9gy7gma42oId0OuZOy6gF/kd+AbaVYMR94r2wi
# Ziy6fYz19FeP/Fk9GrwLCH1HDhWhseBxHI8HXv07XIFDiyH000qi1YTB5OqP99am
# rdkmTR1bbuTjydU3JdNERwetPANiDUN3aBCpEHdAH4+YWUp+VN3fQPJUAaB5WUiC
# BJz4WlTCqTRXtFrOYmJHmnByYkXrT0ftxK+5WnlKyyS+LvzAZu7hZE1NbcGGHzUz
# XQ+Xk3iRmx142j+UrB08SL40h2oF5TBczK1G0PVGAG56LQ8QuQ3SctnPNBOobrqG
# 13jKFM29cxs3ANob75j5IcXxVjrXiabdySsC7o3hY4SyDOnk7e+EUNQBJZbLVIIJ
# 3A/xqlrbBvU3QYaipLuQdbBDAgMBAAGjggF4MIIBdDAMBgNVHRMBAf8EAjAAMD0G
# A1UdHwQ2MDQwMqAwoC6GLGh0dHA6Ly9jY3NjYTIwMjEuY3JsLmNlcnR1bS5wbC9j
# Y3NjYTIwMjEuY3JsMHMGCCsGAQUFBwEBBGcwZTAsBggrBgEFBQcwAYYgaHR0cDov
# L2Njc2NhMjAyMS5vY3NwLWNlcnR1bS5jb20wNQYIKwYBBQUHMAKGKWh0dHA6Ly9y
# ZXBvc2l0b3J5LmNlcnR1bS5wbC9jY3NjYTIwMjEuY2VyMB8GA1UdIwQYMBaAFN10
# XUwA23ufoHTKsW73PMAywHDNMB0GA1UdDgQWBBQQKwRGH7/oAxh3CQEAR0xieePL
# EjBLBgNVHSAERDBCMAgGBmeBDAEEATA2BgsqhGgBhvZ3AgUBBDAnMCUGCCsGAQUF
# BwIBFhlodHRwczovL3d3dy5jZXJ0dW0ucGwvQ1BTMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAAVPCnrMPQUKb
# lzOxzCq9banT75fHMGi7l+IrI9w+V38iTTrSPEe3aveoZQm3gLfSVr6P1lbD6tnJ
# HlzI626XAz0yzNdk6xkU25t8CLIMsXxNIuKcgiMAzSHTlrDmsaPCwTZ9pttWtMVt
# h6cj8oighuRcUYLSMjm401AaP0gEPEMN6Oxv7Fv124FxrqA6HkRFRaH2vy3fON8j
# SKtqR9yTd3vScKtEOVTY0s2CAmR76TGmEiW5hSr8XKR9d60j9+/EOYivy4g43LdP
# xv0NydG3J2iVsx4RSMRA3qz5E2BjfnY557uug/kVRma6e825yK2STLe9zCoxvk9G
# vFffTfCxkxr2lmu6u6FBTzN7TkiOktyDmLT2y+s6k8iWmOzDeGh/5p9FYy+kDviO
# xtp8jYSfNY+YbBpMvgcAFTvr3h7nde+AeO9CwWvQhfpsZmjZRNhpYE+dOxzHbgfm
# ekm2bwmUIDf4YFm4MJeTS8Vjgznve+0oy8BOhQPCgOyR62fHiW9fitbLNEuq+p74
# NyNdMFERwxa/98r0UqA1q23cFZS2IalbMjFA9csJCzUTUGiNTLJZmXfRZYZR+OJM
# HK4pPhh8Us/EYNAPMJ8vMIlzLUCaBx8dT2DRlBMaas6bSTSCxB4SvabIaAjcJUvK
# bng3ibbgjicHnPRGJ1iW6i/6jyg+H04xghs/MIIbOwIBATBqMFYxCzAJBgNVBAYT
# AlBMMSEwHwYDVQQKExhBc3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMT
# G0NlcnR1bSBDb2RlIFNpZ25pbmcgMjAyMSBDQQIQVLDeywfS+CjpIDF7CRtUCDAN
# BglghkgBZQMEAgEFAKB8MBAGCisGAQQBgjcCAQwxAjAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqG
# SIb3DQEJBDEiBCDieikz54mHuX7UseS13WVsw+hpoXqmXC9zfpzsDbJWATANBgkq
# hkiG9w0BAQEFAASCAgBij0ONiZwMgUC51zg3WvNh3UV7/egTy2NXy7qhzOHqNbYT
# y6ADSHTgFEWW+69TXZ4ercgc+Z5x6Bsexpvt/cmlRsjY8N/jAnKGjeKPcy/iVAF/
# IO32vXaRXHbGK53+Fxu38sq4NMTKQ2aQzX6ee+ke3nPoO5o1BnFXswJSBwJqaGlL
# YUyX9K2vdQIt4EhWHArB9I7AIGrr6R8KIbFSP9eMgHADuS5zoTiNjKYeIOjqlIN2
# DBVJU99l7vYMUZP3y9uevtXU/ai8y1HlUPLZr3JfIx+UYsfIpCDptr3HSNY/GUsC
# iKMk5MEwW1DhEd5yPtAVjERVFh7JdidOaiQhFu2fNsO9ARiGjun8hXa7VxgXQt5+
# cedHlja9CTF8JjzOVdll49nFy9lW+lC8Deaf/TDZ1akZaHH9t5bkJMeMIvW+fdiK
# w7TKKjALRNO2NOTVaWJ500ELDvC1ZY6PMhR9DG57HBbFUDVv1pxpU6vPS4BaVmBx
# 3DExLEeuXEElDkYgTE4cmxz0PAf6F4ZXeVDww/3yk3gaOp68iXAVOA8BkyifNBgm
# tQvcRo+1VQkujuuRXYL4Kas2kx3BTRIG/GIrgfZO7X3Ta8eBZ173DtJztnI0R1iv
# cCp53TyXpFb1oNgRmFHUJsfT6ZsTu60qbIDIXqXXppqtaSGwr4Qb3LU0LhuO36GC
# GCgwghgkBgorBgEEAYI3AwMBMYIYFDCCGBAGCSqGSIb3DQEHAqCCGAEwghf9AgED
# MQ0wCwYJYIZIAWUDBAICMIHOBgsqhkiG9w0BCRABBKCBvgSBuzCBuAIBAQYLKoRo
# AYb2dwIFAQswMTANBglghkgBZQMEAgEFAAQgw/FZdhNbioaT2JRXuuAe+/vWqPwd
# SmJ9NDYlgSZRRR4CBwqofDIVhskYDzIwMjMxMjI3MTAzMzA3WjADAgEBoFSkUjBQ
# MQswCQYDVQQGEwJQTDEhMB8GA1UECgwYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEu
# MR4wHAYDVQQDDBVDZXJ0dW0gVGltZXN0YW1wIDIwMjOgghMjMIIGlTCCBH2gAwIB
# AgIQCcXM+LtmfXE3qsFZgAbLMTANBgkqhkiG9w0BAQwFADBWMQswCQYDVQQGEwJQ
# TDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEuMSQwIgYDVQQDExtD
# ZXJ0dW0gVGltZXN0YW1waW5nIDIwMjEgQ0EwHhcNMjMxMTAyMDgzMjIzWhcNMzQx
# MDMwMDgzMjIzWjBQMQswCQYDVQQGEwJQTDEhMB8GA1UECgwYQXNzZWNvIERhdGEg
# U3lzdGVtcyBTLkEuMR4wHAYDVQQDDBVDZXJ0dW0gVGltZXN0YW1wIDIwMjMwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC5Frrqxud9kjaqgkAo85Iyt6ec
# N343OWPztNOFkORvsc6ukhucOOQQ+szxH0jsi3ARjBwG1b9oQwnDx1COOkOpwm2H
# zY2zxtJe2X2qC+H8DMt4+nUNAYFuMEMjReq5ptDTI3JidDEbgcxKdr2azfCwmJ3F
# pqGpKr1LbtCD2Y7iLrwZOxODkdVYKEyJL0UPJ2A18JgNR54+CZ0/pVfCfbOEZag6
# 5oyU3A33ZY88h5mhzn9WIPF/qLR5qt9HKe9u8Y+uMgz8MKQagH/ajWG/uYcqeQK2
# 8AS3Eh5AcSwl4xFfwHGaFwExxBWSXLZRGUbn9aFdirSZKKde20p1COlmZkxImJY+
# bxQYSgw5nEM0jPg6rePD+0IQQc4APK6dSHAOQS3QvBJrfzTWlCQokGtOvxcNIs5c
# OvaANmTcGcLgkH0eHgMBpLFlcyzE0QkY8Heh+xltZFEiAvK5gbn8CHs8oo9o0/Jj
# LqdWYLrW4HnES43/NC1/sOaCVmtslTaFoW/WRRbtJaRrK/03jFjrN921dCntRRin
# B/Ew3MQ1kxPN604WCMeLvAOpT3F5KbBXoPDrMoW9OGTYnYqv88A6hTbVFRs+Ei8U
# Jjk4IlfOknHWduimRKQ4LYDY1GDSA33YUZ/c3Pootanc2iWPNavjy/ieDYIdH8XV
# bRfWqchnDpTE+0NFcwIDAQABo4IBYzCCAV8wDAYDVR0TAQH/BAIwADAdBgNVHQ4E
# FgQUx2k8Lua941lH/xkSwdk06EHP448wHwYDVR0jBBgwFoAUvlQCL79AbHNDzqwJ
# JU6eQ0Qa7uAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MDMGA1UdHwQsMCowKKAmoCSGImh0dHA6Ly9jcmwuY2VydHVtLnBsL2N0c2NhMjAy
# MS5jcmwwbwYIKwYBBQUHAQEEYzBhMCgGCCsGAQUFBzABhhxodHRwOi8vc3ViY2Eu
# b2NzcC1jZXJ0dW0uY29tMDUGCCsGAQUFBzAChilodHRwOi8vcmVwb3NpdG9yeS5j
# ZXJ0dW0ucGwvY3RzY2EyMDIxLmNlcjBBBgNVHSAEOjA4MDYGCyqEaAGG9ncCBQEL
# MCcwJQYIKwYBBQUHAgEWGWh0dHBzOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJKoZI
# hvcNAQEMBQADggIBAHjd7rE6Q+b32Ws4vTJeC0HcGDi7mfQUnbaJ9nFFOQpizPX+
# YIpHuK89TPkOdDF7lOEmTZzVQpw0kwpIZDuB8lSM0Gw9KloOvXIsGjF/KgTNxYM5
# aViQNMtoIiF6W9ysmubDHF7lExSToPd1r+N0zYGXlE1uEX4o988K/Z7kwgE/GC64
# 9S1OEZ5IGSGmirtcruLX/xhjIDA5S/cVfz0We/ElHamHs+UfW3/IxTigvvq4JCbd
# ZHg9DsjkW+UgGGAVtkxB7qinmWJamvdwpgujAwOT1ym/giPTW5C8/MnkL18ZgVQ3
# 8sqKqFdqUS+ZIVeXKfV58HaWtV2Lip1Y0luL7Mswb856jz7zXINk79H4XfbWOryf
# 7AtWBjrus28jmHWK3gXNhj2StVcOI48Dc6CFfXDMo/c/E/ab217kTYhiht2rCWeG
# S5THQ3bZVx+lUPLaDe3kVXjYvxMYQKWu04QX6+vURFSeL3WVrUSO6nEnZu7X2EYc
# i5MUmmUdEEiAVZO/03yLlNWUNGX72/949vU+5ZN9r9EGdp7X3W7mLL1Tx4gLmHnr
# B97O+e9RYK6370MC52siufu11p3n8OG5s2zJw2J6LpD+HLbyCgfRId9Q5UKgsj0A
# 1QuoBut8FI6YdaH3sR1ponEv6GsNYrTyBtSR77csUWLUCyVbosF3+ae0+SofMIIG
# uTCCBKGgAwIBAgIRAOf/acc7Nc5LkSbYdHxopYcwDQYJKoZIhvcNAQEMBQAwgYAx
# CzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEu
# MScwJQYDVQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxJDAiBgNV
# BAMTG0NlcnR1bSBUcnVzdGVkIE5ldHdvcmsgQ0EgMjAeFw0yMTA1MTkwNTMyMDda
# Fw0zNjA1MTgwNTMyMDdaMFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhBc3NlY28g
# RGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0NlcnR1bSBUaW1lc3RhbXBpbmcg
# MjAyMSBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOkSHwQ17bld
# esWmlUG+imV/TnfRbSV102aO2/hhKH9/t4NAoVoipzu0ePujH67y8iwlmWuhqRR4
# xLeLdPxolEL55CzgUXQaq+Qzr5Zk7ySbNl/GZloFiYwuzwWS2AVgLPLCZd5DV8QT
# F+V57Y6lsdWTrrl5dEeMfsxhkjM2eOXabwfLy6UH2ZHzAv9bS/SmMo1PobSx+vHW
# ST7c4aiwVRvvJY2dWRYpTipLEu/XqQnqhUngFJtnjExqTokt4HyzOsr2/AYOm8YO
# coJQxgvc26+LAfXHiBkbQkBdTfHak4DP3UlYolICZHL+XSzSXlsRgqiWD4MypWGU
# 4A13xiHmaRBZowS8FET+QAbMiqBaHDM3Y6wohW07yZ/mw9ZKu/KmVIAEBhrXesxi
# fPB+DTyeWNkeCGq4IlgJr/Ecr1px6/1QPtj66yvXl3uauzPPGEXUk6vUym6nZyE1
# IGXI45uGVI7XqvCt99WuD9LNop9Kd1LmzBGGvxucOo0lj1M3IRi8FimAX3krunSD
# guC5HgD75nWcUgdZVjm/R81VmaDPEP25Wj+C1reicY5CPckLGBjHQqsJe7jJz1CJ
# XBMUtZs10cVKMEK3n/xD2ku5GFWhx0K6eFwe50xLUIZD9GfT7s/5/MyBZ1Ep8Q6H
# +GMuudDwF0mJitk3G8g6EzZprfMQMc3DAgMBAAGjggFVMIIBUTAPBgNVHRMBAf8E
# BTADAQH/MB0GA1UdDgQWBBS+VAIvv0Bsc0POrAklTp5DRBru4DAfBgNVHSMEGDAW
# gBS2oVQ5AsOgP46KvPrU+Bym0ToO/TAOBgNVHQ8BAf8EBAMCAQYwEwYDVR0lBAww
# CgYIKwYBBQUHAwgwMAYDVR0fBCkwJzAloCOgIYYfaHR0cDovL2NybC5jZXJ0dW0u
# cGwvY3RuY2EyLmNybDBsBggrBgEFBQcBAQRgMF4wKAYIKwYBBQUHMAGGHGh0dHA6
# Ly9zdWJjYS5vY3NwLWNlcnR1bS5jb20wMgYIKwYBBQUHMAKGJmh0dHA6Ly9yZXBv
# c2l0b3J5LmNlcnR1bS5wbC9jdG5jYTIuY2VyMDkGA1UdIAQyMDAwLgYEVR0gADAm
# MCQGCCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJKoZIhvcN
# AQEMBQADggIBALiTWXfJTBX9lAcIoKd6oCzwQZOfARQkt0OmiQ390yEqMrStHmpf
# ycggfPGlBHdMDDYhHDVTGyvY+WIbdsIWpJ1BNRt9pOrpXe8HMR5sOu71AWOqUqfE
# IXaHWOEs0UWmVs8mJb4lKclOHV8oSoR0p3GCX2tVO+XF8Qnt7E6fbkwZt3/AY/C5
# KYzFElU7TCeqBLuSagmM0X3Op56EVIMM/xlWRaDgRna0hLQze5mYHJGv7UuTCOO3
# wC1bzeZWdlPJOw5v4U1/AljsNLgWZaGRFuBwdF62t6hOKs86v+jPIMqFPwxNJN/o
# u22DqzpP+7TyYNbDocrThlEN9D2xvvtBXyYqA7jhYY/fW9edUqhZUmkUGM++Mvz9
# lyT/nBdfaKqM5otK0U5H8hCSL4SGfjOVyBWbbZlUIE8X6XycDBRRKEK0q5JTsaZk
# soKabFAyRKJYgtObwS1UPoDGcmGirwSeGMQTJSh+WR5EXZaEWJVA6ZZPBlGvjgjF
# YaQ0kLq1OitbmuXZmX7Z70ks9h/elK0A8wOg8oiNVd3o1bb59ms1QF4OjZ45rkWf
# sGuz8ctB9/leCuKzkx5Rt1WAOsXy7E7pws+9k+jrePrZKw2DnmlNaT19QgX2I+hF
# tvhC6uOhj/CgjVEA4q1i1OJzpoAmre7zdEg+kZcFIkrDHgokA5mcIMK1MIIFyTCC
# BLGgAwIBAgIQG7WPJSrfIwBJKMmuPX7tJzANBgkqhkiG9w0BAQwFADB+MQswCQYD
# VQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEnMCUG
# A1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSIwIAYDVQQDExlD
# ZXJ0dW0gVHJ1c3RlZCBOZXR3b3JrIENBMB4XDTIxMDUzMTA2NDMwNloXDTI5MDkx
# NzA2NDMwNlowgYAxCzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hu
# b2xvZ2llcyBTLkEuMScwJQYDVQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRo
# b3JpdHkxJDAiBgNVBAMTG0NlcnR1bSBUcnVzdGVkIE5ldHdvcmsgQ0EgMjCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL35ePjm1YAMZJ2GG5ZkZz8iOh51
# AX3v+1xnjMnMXGupkea5QuUgS5vam3u5mV3Zm4BL14RAKyfT6Lowuz4JGqdJle8r
# QCTCl8en7psl76gKAJeFWqqd3CnJ4jUH63BNStbBs1a4oUE4m9H7MX+P4F/hsT8P
# jhZJYNcGjRj5qiYQqyrT0NFnjRtGvkcw1S5y0cVj2udjeUR+S2MkiYYuND8pTFKL
# KqfA4pEoibnAW/kd2ecnrf+aApfBxlCSmwIsvam5NFkKv4RK/9/+s5/r2Z7gmCPs
# pmt3FirbzK07HKSH3EZzXhliaEVX5JCCQrtC1vBh4MGjPWajXfQY7ojJjRdFKZky
# dQIx7ikmyGsC5rViRX83FVojaInUPt5OJ7DwQAy8TRfLTaKzHtAGWt32k89XdZn1
# +oYaZ3izv5b+NNy951JW5bPldXvXQZEF3F1p45UNQ7n8g5Y5lXtsgFpPE3LG130p
# ekS6UqQq1UFGCSD+IqC2WzCNvIkM1ddw+IdS/drvrFEuB7NO/tAJ2nDvmPpW5m3b
# tVdL3OUsJRXIni54TvjanJ6GLMpX8xrlyJKLGoKWesO8UBJp2A5aRos66yb6I8m2
# sIG+QgCk+Nb+MC7H0kb25Y51/fLMudCHW8wGEGC7gzW3XmfeR+yZSPGkoRX+rYxi
# jjlVTzkWubFjnf+3AgMBAAGjggE+MIIBOjAPBgNVHRMBAf8EBTADAQH/MB0GA1Ud
# DgQWBBS2oVQ5AsOgP46KvPrU+Bym0ToO/TAfBgNVHSMEGDAWgBQIds3LB/8k9sXN
# 7buQvOKEN0Z19zAOBgNVHQ8BAf8EBAMCAQYwLwYDVR0fBCgwJjAkoCKgIIYeaHR0
# cDovL2NybC5jZXJ0dW0ucGwvY3RuY2EuY3JsMGsGCCsGAQUFBwEBBF8wXTAoBggr
# BgEFBQcwAYYcaHR0cDovL3N1YmNhLm9jc3AtY2VydHVtLmNvbTAxBggrBgEFBQcw
# AoYlaHR0cDovL3JlcG9zaXRvcnkuY2VydHVtLnBsL2N0bmNhLmNlcjA5BgNVHSAE
# MjAwMC4GBFUdIAAwJjAkBggrBgEFBQcCARYYaHR0cDovL3d3dy5jZXJ0dW0ucGwv
# Q1BTMA0GCSqGSIb3DQEBDAUAA4IBAQBRwqFYFiIQi/yGMdTCMtNc+EuiL2o+Tfir
# CB7t1ej65wgN7LfGHg6ydQV6sQv613RqAAYfpM6q8mt92BHAEQjUDk1hxTqo+rHh
# 45jq4mP9QfWTfQ28XZI7kZplutBfTL5MjWgDEBbV8dAEioUz+TfnWy4maUI8us28
# 1HrpTZ3a50P7Y1KAhQTEJZVV8H6nnwHFWyj44M6GcKYnOzn7OC6YU2UidS3X9t0i
# IpGW691o7T+jGZfTOyWI7DYSPal+zgKNBZqSpyduRbKcYoY3DaQzjteoTtBKF0NM
# xfGnbNIeWGwUUX6KVKH27595el2BmhaQD+G78UoA+fndvu2q7M4KMYID7zCCA+sC
# AQEwajBWMQswCQYDVQQGEwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVt
# cyBTLkEuMSQwIgYDVQQDExtDZXJ0dW0gVGltZXN0YW1waW5nIDIwMjEgQ0ECEAnF
# zPi7Zn1xN6rBWYAGyzEwDQYJYIZIAWUDBAICBQCgggFWMBoGCSqGSIb3DQEJAzEN
# BgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMjMxMjI3MTAzMzA3WjA3Bgsq
# hkiG9w0BCRACLzEoMCYwJDAiBCDqlUux0EC0MUBI2GWfj2FdiHQszOBnkuBWAk1L
# ADrTHDA/BgkqhkiG9w0BCQQxMgQw7blEqQv25gDj+3vNea81CMuzCHnhjtNw/JoP
# 8vSdtyqUWGX0hfrBUFerOpM0lkQYMIGfBgsqhkiG9w0BCRACDDGBjzCBjDCBiTCB
# hgQUD0+4VR7/2Pbef2cmtDwT0Gql53cwbjBapFgwVjELMAkGA1UEBhMCUEwxITAf
# BgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMgUy5BLjEkMCIGA1UEAxMbQ2VydHVt
# IFRpbWVzdGFtcGluZyAyMDIxIENBAhAJxcz4u2Z9cTeqwVmABssxMA0GCSqGSIb3
# DQEBAQUABIICAKOlYWWbsJ9gZEYshRBJW/UzmNZoC/kv1QlAJLJnfrf13WNCw++B
# OmpFX4L0ra2TBEPIyus6QhykKyFq6zxXWOJ07YnKYHzjFClXjjRqVP8bcAgfr91N
# NKKkDhExFpH06GIHv+yAHelD7Dlum69A0uv6FfIFG2FmKQbD47CkkengxcP2H5WA
# pKkSlWNpqGkXVUEuoB8Db6jrNz+zWU+M3n52/wuSsyHIpB9Mfp+y610wlWri7Im8
# K7Rz6G4P6C9lzBjsAXfoXqUkMgxJ784DPL18wEUKIU6gnogYSQz2NrLbVQWu+ptg
# Jl7op97mGpeeesN+xG/lz92dGl/0im1mBb3tqeO4x5Jg6ALU1MgoctN/u9uRmUmT
# c4tN8e1vMtGzAGzKxh9mcvJb2SFplWlhSRhxlNMxZNhtSF/H+UdEZ0l64EPN+8Nq
# +Q7HaITETrjsDKa54i4Vl019ipO8f01giSfY/cbUKjq1nDj7X5EXmCo8zPuD278W
# +expw8OJ1RBo5d613iGmAxxOLWNhIUkuxJdn08myVnnpdFVFEf1ngT2hD5yMvoBu
# gy4ql25lm+wdpXsCd1IQDcB6yo00lPJrDBu/AKRpGVnm2fMyFLZkENHOE/tyuGdD
# iqcPJVXhxaItsL6NCGG6OnghIjg+EIbvLMqZQW5fcVRQD0BDUVDJ0jCt
# SIG # End signature block
