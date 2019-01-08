#NoTrayIcon
#RequireAdmin

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_two.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.0.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2017, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ;**** Pragma Compile ****
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Compression, 9)
#pragma compile(InputBoxRes, true)
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(FileVersion, 1.0.0.47)
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017, SalFisher47')
#pragma compile(OriginalFilename, UniGame_Launcher_two.exe)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(ProductVersion, 1.0.0.47)
#EndRegion ;**** Pragma Compile ****

; === UniGame Launcher.au3 =========================================================================================================
; Title .........: UniGame Launcher
; Version .......: 1.0.0.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Universal Game Launcher
; Author(s) .....: SalFisher47
; Last Modified .: March 20, 2017 - last compiled on January 8 2019
; ==================================================================================================================================

Global $Env_RoamingAppData = @AppDataDir, _
		$Env_LocalAppData = @LocalAppDataDir, _
		$Env_ProgramData = @AppDataCommonDir, _
		$Env_UserProfile = @UserProfileDir, _
		$Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
		If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"

$Ini = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"

$exe32_run = IniRead($Ini, "Exe", "exe32_run", "")
$exe32_path_full = @ScriptDir & "\" & $exe32_run
$exe32_only = StringTrimLeft($exe32_path_full, StringInStr($exe32_path_full, "\", 0, -1))
$exe32_path_only = StringTrimRight($exe32_path_full, StringLen($exe32_only)+1)
$exe32_cmd = IniRead($Ini, "Exe", "exe32_cmd", "")
$exe32_compat = IniRead($Ini, "Exe", "exe32_compat", "")

$exe64_run = IniRead($Ini, "Exe", "exe64_run", "")
$exe64_path_full = @ScriptDir & "\" & $exe64_run
$exe64_only = StringTrimLeft($exe64_path_full, StringInStr($exe64_path_full, "\", 0, -1))
$exe64_path_only = StringTrimRight($exe64_path_full, StringLen($exe64_only)+1)
$exe64_cmd = IniRead($Ini, "Exe", "exe64_cmd", "")
$exe64_compat = IniRead($Ini, "Exe", "exe64_compat", "")

If @OSArch == "X86" Then
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe32_path_full) <> $exe32_compat Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe32_path_full, "REG_SZ", $exe32_compat)
	EndIf
	ShellExecute($exe32_only, " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only)
Else
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe64_path_full) <> $exe64_compat Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe64_path_full, "REG_SZ", $exe64_compat)
	EndIf
	ShellExecute($exe64_only, " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only)
EndIf