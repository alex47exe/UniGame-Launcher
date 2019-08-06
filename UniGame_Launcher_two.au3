#NoTrayIcon
;#RequireAdmin

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_two.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.3.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.3.0.47
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
#pragma compile(FileVersion, 1.3.0.47)
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017-2019, SalFisher47')
#pragma compile(OriginalFilename, UniGame_Launcher_two.exe)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(ProductVersion, 1.3.0.47)
#EndRegion ;**** Pragma Compile ****

; === UniGame_Launcher_two.au3 =====================================================================================================
; Title .........: UniGame Launcher
; Version .......: 1.3.0.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Universal Game Launcher two
; Author(s) .....: SalFisher47
; Last Modified .: August 9, 2019 - last compiled on August 9 2019
; ==================================================================================================================================

#include <StringConstants.au3>

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

$exe32_run = IniRead($Ini, "Exe", "exe32_run", "")
$exe32_path_full = @ScriptDir & "\" & $exe32_run
$exe32_only = StringTrimLeft($exe32_path_full, StringInStr($exe32_path_full, "\", 0, -1))
$exe32_path_only = StringTrimRight($exe32_path_full, StringLen($exe32_only)+1)
$exe32_cmd = IniRead($Ini, "Exe", "exe32_cmd", "")
$exe32_compat = IniRead($Ini, "Exe", "exe32_compat", "")

$exe32_run_alt = IniRead($Ini, "Exe", "exe32_run_alt", "")
$exe32_path_full_alt = @ScriptDir & "\" & $exe32_run_alt
$exe32_only_alt = StringTrimLeft($exe32_path_full_alt, StringInStr($exe32_path_full_alt, "\", 0, -1))
$exe32_path_only_alt = StringTrimRight($exe32_path_full_alt, StringLen($exe32_only_alt)+1)
$exe32_cmd_alt = IniRead($Ini, "Exe", "exe32_cmd_alt", "")
$exe32_compat_alt = IniRead($Ini, "Exe", "exe32_compat_alt", "")

$exe64_run = IniRead($Ini, "Exe", "exe64_run", "")
$exe64_path_full = @ScriptDir & "\" & $exe64_run
$exe64_only = StringTrimLeft($exe64_path_full, StringInStr($exe64_path_full, "\", 0, -1))
$exe64_path_only = StringTrimRight($exe64_path_full, StringLen($exe64_only)+1)
$exe64_cmd = IniRead($Ini, "Exe", "exe64_cmd", "")
$exe64_compat = IniRead($Ini, "Exe", "exe64_compat", "")

$exe64_run_alt = IniRead($Ini, "Exe", "exe64_run_alt", "")
$exe64_path_full_alt = @ScriptDir & "\" & $exe64_run_alt
$exe64_only_alt = StringTrimLeft($exe64_path_full_alt, StringInStr($exe64_path_full_alt, "\", 0, -1))
$exe64_path_only_alt = StringTrimRight($exe64_path_full_alt, StringLen($exe64_only_alt)+1)
$exe64_cmd_alt = IniRead($Ini, "Exe", "exe64_cmd_alt", "")
$exe64_compat_alt = IniRead($Ini, "Exe", "exe64_compat_alt", "")

$run_next = IniRead($Ini, "Exe", "run_next", 0)

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

; kill incompatible processes before starting the game
$Ini_kill_process = IniRead($Ini, "Launcher", "end_process", "")
$Kill_process = ""
If $Ini_kill_process <> "" Then
   $Kill_process = StringSplit($Ini_kill_process, ", ", $STR_ENTIRESPLIT)
   For $i = 1 To $Kill_process[0]
	  If ProcessExists($Kill_process[$i]) Then
		 ProcessClose($Kill_process[$i])
		 Sleep(50)
	  EndIf
   Next
EndIf

;$desktopRatio = Round(@DesktopWidth/@DesktopHeight, 2)

; check if running as administrator, then execute _RunMain, _RunBefore & _RunAfter functions
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

Func _RunBefore_FirstLaunch()
	; add commands here to run before game exe at first launch

EndFunc

Func _RunAfter_FirstLaunch()
	; add commands here to run after game exe at first launch

EndFunc

Func _RunBefore_EveryLaunch()
	; add commands here to run before game exe at every launch, except the first one

EndFunc

Func _RunAfter_EveryLaunch()
	; add commands here to run after game exe at every launch, except the first one

EndFunc

Func _RunMain() ; main script
RegRead('HKCU\Software\Valve\Steam', 'SteamPath')
If @error Then
	RegWrite('HKCU\Software\Valve\Steam', 'SteamExe','REG_SZ','d:/steam/steam.exe')
	RegWrite('HKCU\Software\Valve\Steam', 'SteamPath','REG_SZ','d:/steam')
	RegWrite('HKLM\SOFTWARE\Valve\Steam', 'InstallPath','REG_SZ','D:\Steam')
EndIf
If @OSArch == "X86" Then
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe32_path_full) <> $exe32_compat Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe32_path_full, "REG_SZ", $exe32_compat)
	EndIf
	If $Savegame_dir <> "" Then
		If Not FileExists($Savegame_dir) Then DirCreate($Savegame_dir)
		FileCreateShortcut($Savegame_dir, @ScriptDir & "\_savegame.lnk")
	EndIf
	If $first_launch == 1 Then
		; add commands here to run before game exe at first launch
		;_RunBefore_FirstLaunch()
		If $run_first == 1 Then
			If $exe32_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe32_path_full_alt & '"' & " " & $exe32_cmd_alt & " " & $CmdLineRaw, $exe32_path_only_alt, "", @SW_HIDE)
				Else
					ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe32_path_full_alt & '"' & " " & $exe32_cmd_alt & " " & $CmdLineRaw, $exe32_path_only_alt, "", @SW_HIDE)
					ProcessWait($exe32_only_alt)
					ProcessWaitClose($exe32_only_alt)
					Sleep(250)
					If Not ProcessExists($exe32_only) Then
						ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe32_path_full & '"' & " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only, "", @SW_HIDE)
					EndIf
				EndIf
			Else
				ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe32_path_full & '"' & " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only, "", @SW_HIDE)
			EndIf
		Else
			If $exe32_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute($exe32_only_alt, " " & $exe32_cmd_alt & " " & $CmdLineRaw, $exe32_path_only_alt)
				Else
					ShellExecute($exe32_only_alt, " " & $exe32_cmd_alt & " " & $CmdLineRaw, $exe32_path_only_alt)
					ProcessWait($exe32_only_alt)
					ProcessWaitClose($exe32_only_alt)
					Sleep(250)
					If Not ProcessExists($exe32_only) Then
						ShellExecute($exe32_only, " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only)
					EndIf
				EndIf
			Else
				ShellExecute($exe32_only, " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only)
			EndIf
		EndIf
		; add commands here to run after game exe at first launch
		;_RunAfter_FirstLaunch()
	Else
		; add commands here to run before game exe at every launch, except the first one
		;_RunBefore_EveryLaunch()
		If $run_first == 1 Then
			ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe32_path_full & '"' & " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only, "", @SW_HIDE)
		Else
			ShellExecute($exe32_only, " " & $exe32_cmd & " " & $CmdLineRaw, $exe32_path_only)
		EndIf
		; add commands here to run after game exe at every launch, except the first one
		;_RunAfter_EveryLaunch()
	EndIf
Else
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe64_path_full) <> $exe64_compat Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe64_path_full, "REG_SZ", $exe64_compat)
	EndIf
	If $Savegame_dir <> "" Then
		If Not FileExists($Savegame_dir) Then DirCreate($Savegame_dir)
		FileCreateShortcut($Savegame_dir, @ScriptDir & "\_savegame.lnk")
	EndIf
	If $first_launch == 1 Then
		; add commands here to run before game exe at first launch
		;_RunBefore_FirstLaunch()
		If $run_first == 1 Then
			If $exe64_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe64_path_full_alt & '"' & " " & $exe64_cmd_alt & " " & $CmdLineRaw, $exe64_path_only_alt, "", @SW_HIDE)
				Else
					ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe64_path_full_alt & '"' & " " & $exe64_cmd_alt & " " & $CmdLineRaw, $exe64_path_only_alt, "", @SW_HIDE)
					ProcessWait($exe64_only_alt)
					ProcessWaitClose($exe64_only_alt)
					Sleep(250)
					If Not ProcessExists($exe64_only) Then
						ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe64_path_full & '"' & " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only, "", @SW_HIDE)
					EndIf
				EndIf
			Else
				ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe64_path_full & '"' & " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only, "", @SW_HIDE)
			EndIf
		Else
			If $exe64_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute($exe64_only_alt, " " & $exe64_cmd_alt & " " & $CmdLineRaw, $exe64_path_only_alt)
				Else
					ShellExecute($exe64_only_alt, " " & $exe64_cmd_alt & " " & $CmdLineRaw, $exe64_path_only_alt)
					ProcessWait($exe64_only_alt)
					ProcessWaitClose($exe64_only_alt)
					Sleep(250)
					If Not ProcessExists($exe64_only) Then
						ShellExecute($exe64_only, " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only)
					EndIf
				EndIf
			Else
				ShellExecute($exe64_only, " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only)
			EndIf
		EndIf
		; add commands here to run after game exe at first launch
		;_RunAfter_FirstLaunch()
	Else
		; add commands here to run before game exe at every launch, except the first one
		;_RunBefore_EveryLaunch()
		If $run_first == 1 Then
			ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe64_path_full & '"' & " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only, "", @SW_HIDE)
		Else
			ShellExecute($exe64_only, " " & $exe64_cmd & " " & $CmdLineRaw, $exe64_path_only)
		EndIf
		; add commands here to run after game exe at every launch, except the first one
		;_RunAfter_EveryLaunch()
	EndIf
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