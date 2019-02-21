#NoTrayIcon
;#RequireAdmin

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_one.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.2.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.2.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2017-2019, SalFisher47
#AutoIt3Wrapper_Res_SaveSource=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ;**** Pragma Compile ****
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Compression, 9)
#pragma compile(InputBoxRes, true)
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(FileVersion, 1.2.0.47)
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017-2019, SalFisher47')
#pragma compile(OriginalFilename, UniGame_Launcher_one.exe)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(ProductVersion, 1.2.0.47)
#EndRegion ;**** Pragma Compile ****

; === UniGame_Launcher_one.au3 =====================================================================================================
; Title .........: UniGame Launcher
; Version .......: 1.1.0.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Universal Game Launcher one
; Author(s) .....: SalFisher47
; Last Modified .: January 19, 2019 - last compiled on January 19 2019
; ==================================================================================================================================

Global $Env_RoamingAppData = @AppDataDir, _
		$Env_LocalAppData = @LocalAppDataDir, _
		$Env_ProgramData = @AppDataCommonDir, _
		$Env_UserProfile = @UserProfileDir, _
		$Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
		If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"

$Ini = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"
$ini_RunAdmin = IniRead($ini, "launcher", "run_admin", "")

; check for game path and add it to ini file in C:\ProgramData\SalFisher47\UniGame Launcher
If Not FileExists(@AppDataCommonDir & "\SalFisher47\UniGame Launcher") Then DirCreate(@AppDataCommonDir & "\SalFisher47\UniGame Launcher")
FileInstall("ProgramData.ini", @AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", 0)

$exe_run = IniRead($Ini, "Exe", "exe_run", "")
$exe_path_full = @ScriptDir & "\" & $exe_run
$exe_only = StringTrimLeft($exe_path_full, StringInStr($exe_path_full, "\", 0, -1))
$exe_path_only = StringTrimRight($exe_path_full, StringLen($exe_only)+1)
$exe_cmd = IniRead($Ini, "Exe", "exe_cmd", "")
$exe_compat = IniRead($Ini, "Exe", "exe_compat", "")

$exe_run_alt = IniRead($Ini, "Exe", "exe_run_alt", "")
$exe_path_full_alt = @ScriptDir & "\" & $exe_run_alt
$exe_only_alt = StringTrimLeft($exe_path_full_alt, StringInStr($exe_path_full_alt, "\", 0, -1))
$exe_path_only_alt = StringTrimRight($exe_path_full_alt, StringLen($exe_only_alt)+1)
$exe_cmd_alt = IniRead($Ini, "Exe", "exe_cmd_alt", "")
$exe_compat_alt = IniRead($Ini, "Exe", "exe_compat_alt", "")

$run_first = IniRead($Ini, "Exe", "run_first", 0)
If Not FileExists(@AppDataCommonDir & "\SalFisher47\RunFirst") Then DirCreate(@AppDataCommonDir & "\SalFisher47\RunFirst")
FileInstall("RunFirst\RunFirst.exe", @AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", 0)
FileInstall("RunFirst\RunFirst.txt", @AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.txt", 0)

; check for savegame path and add it to ini file in C:\ProgramData\SalFisher47\UniGame Launcher
$ini_Savegame_dir = IniRead($ini, "savegame", "savegame_dir", "")
$ini_Savegame_subdir = IniRead($ini, "savegame", "savegame_subdir", "")
$Savegame_dir = ""
Switch $ini_Savegame_dir
	Case "MyDocs"
		$Savegame_dir = @MyDocumentsDir & "\" & $ini_Savegame_subdir
	Case "PublicDocs"
		$Savegame_dir = @DocumentsCommonDir & "\" & $ini_Savegame_subdir
	Case "RoamingAppData"
		$Savegame_dir = $Env_RoamingAppData & "\" & $ini_Savegame_subdir
	Case "LocalAppData"
		$Savegame_dir = $Env_LocalAppData & "\" & $ini_Savegame_subdir
	Case "ProgramData"
		$Savegame_dir = $Env_ProgramData & "\" & $ini_Savegame_subdir
	Case "SavedGames"
		$Savegame_dir = $Env_SavedGames & "\" & $ini_Savegame_subdir
	Case "UserProfile"
		$Savegame_dir = @UserProfileDir & "\" & $ini_Savegame_subdir
	Case "GameDir"
		$Savegame_dir = @ScriptDir & "\" & $ini_Savegame_subdir
EndSwitch

If IniRead(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "game_path", "") <> @ScriptDir Then
	$first_launch = 1
	IniWrite(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "game_path", " " & @ScriptDir)
	If IniRead(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "savegame_path", "") <> $Savegame_dir Then
		IniWrite(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "savegame_path", " " & $Savegame_dir)
	EndIf
	If $ini_RunAdmin == 1 Then
		_RunAdmin()
		Exit
	Else
		_RunMain()
		Exit
	EndIf
Else
	If IsAdmin() Then
		$first_launch = 1
		If IniRead(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "savegame_path", "") <> $Savegame_dir Then
			IniWrite(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "savegame_path", " " & $Savegame_dir)
		EndIf
		_RunMain()
		Exit
	Else
		$first_launch = 0
		If IniRead(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "savegame_path", "") <> $Savegame_dir Then
			IniWrite(@AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini", "launcher", "savegame_path", " " & $Savegame_dir)
		EndIf
		_RunMain()
		Exit
	EndIf
EndIf

$desktopRatio = Round(@DesktopWidth/@DesktopHeight, 2)

_RunMain()

Func _RunMain() ; main script
RegRead('HKCU\Software\Valve\Steam', 'SteamPath')
If @error Then
	RegWrite('HKCU\Software\Valve\Steam', 'SteamExe','REG_SZ','d:/steam/steam.exe')
	RegWrite('HKCU\Software\Valve\Steam', 'SteamPath','REG_SZ','d:/steam')
	RegWrite('HKLM\SOFTWARE\Valve\Steam', 'InstallPath','REG_SZ','D:\Steam')
EndIf
If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe_path_full) <> $exe_compat Then
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe_path_full, "REG_SZ", $exe_compat)
EndIf
If $Savegame_dir <> "" Then
	If Not FileExists($Savegame_dir) Then DirCreate($Savegame_dir)
	FileCreateShortcut($Savegame_dir, @ScriptDir & "\_savegame.lnk")
EndIf
If $first_launch == 1 Then
	; add commands here to run before game exe at first launch
	If $run_first == 1 Then
		If $exe_run_alt <> "" Then
			ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe_path_full_alt & '"' & " " & $exe_cmd_alt & " " & $CmdLineRaw, $exe_path_only_alt, "", @SW_HIDE)
		Else
			ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe_path_full & '"' & " " & $exe_cmd & " " & $CmdLineRaw, $exe_path_only, "", @SW_HIDE)
		EndIf
	Else
		If $exe_run_alt <> "" Then
			ShellExecute($exe_only_alt, " " & $exe_cmd_alt & " " & $CmdLineRaw, $exe_path_only_alt)
		Else
			ShellExecute($exe_only, " " & $exe_cmd & " " & $CmdLineRaw, $exe_path_only)
		EndIf
	EndIf
	; add commands here to run after game exe at first launch
Else
	; add commands here to run before game exe at every launch, except the first one
	If $run_first == 1 Then
		ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe_path_full & '"' & " " & $exe_cmd & " " & $CmdLineRaw, $exe_path_only, "", @SW_HIDE)
	Else
		ShellExecute($exe_only, " " & $exe_cmd & " " & $CmdLineRaw, $exe_path_only)
	EndIf
	; add commands here to run after game exe at every launch, except the first one
EndIf
EndFunc

Func _RunAdmin() ; run main script as admin on first launch
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".exe") <> "RUNASADMIN" Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".exe", "REG_SZ", "RUNASADMIN")
	EndIf
	;---
	ShellExecute(StringTrimRight(@ScriptName, 4) & ".exe", $CmdLineRaw, @ScriptDir)
	;---
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".exe") == "RUNASADMIN" Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".exe", "REG_SZ", "")
	EndIf
EndFunc