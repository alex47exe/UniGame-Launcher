#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_two.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.5.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.5.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2017-2020, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/tl /sf /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** Pragma Compile ****
#pragma compile(Console, False)
#pragma compile(x64, False)
#pragma compile(ExecLevel, AsInvoker)
#pragma compile(Compatibility, vista, win7, win8, win81, win10)
#pragma compile(AutoItExecuteAllowed, True)
#pragma compile(InputBoxRes, True)
#pragma compile(Stripper, True)
#pragma compile(FileVersion, 1.5.0.47)
#pragma compile(ProductVersion, 1.5.0.47)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017-2020, SalFisher47')
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(OriginalFilename, UniGame_Launcher_two.exe)
#EndRegion ;**** Pragma Compile ****

; === UniGame_Launcher_two.au3 =====================================================================================================
; Title .........: UniGame Launcher
; Version .......: 1.5.0.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Universal Game Launcher two
; Author(s) .....: SalFisher47
; Last Modified .: June 21, 2020 - last compiled on June 21, 2020
; ==================================================================================================================================

#include <Array.au3>
#include <File.au3>
#include <WinAPI.au3>
#include <ProcessConstants.au3>
#include <StringConstants.au3>
#include "_Include\_UDF\Zip_Functions.au3" ; thanks to wraithdu - https://www.autoitscript.com/forum/topic/116565-zip-udf-zipfldrdll-library/#comments

Global $Env_RoamingAppData = @AppDataDir, _
		$Env_LocalAppData = @LocalAppDataDir, _
		$Env_ProgramData = @AppDataCommonDir, _
		$Env_UserProfile = @UserProfileDir, _
		$Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
		If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"
Global $7z_dir = $Env_ProgramData & "\SalFisher47\7za", $7z = $7z_dir & "\7za.exe"

$Ini = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"
$ini_RunAdmin = IniRead($ini, "launcher", "run_admin", "")
$ini_1stRun = IniRead($ini, "launcher", "1st_run", "")

; check for game path and add it to ini file in C:\ProgramData\SalFisher47\UniGame Launcher
If Not FileExists(@AppDataCommonDir & "\SalFisher47\UniGame Launcher") Then DirCreate(@AppDataCommonDir & "\SalFisher47\UniGame Launcher")
$Ini_ProgramData = @AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini"
FileInstall("ProgramData.ini", $Ini_ProgramData, 0)

; check if _1st_run.zip exists, when 1st_run = 1 in ini file
If $ini_1stRun == 1 Then
	If Not FileExists(@ScriptDir & "\_1st_run.zip") Then
		$first_launch = 1
		FileInstall("_1st_run.zip", @ScriptDir & "\_1st_run.zip", 0)
		FileInstall("ProgramData.ini", $Ini_ProgramData, 1)
	EndIf
EndIf

; check for 7za.exe, unpack it to C:\ProgramData\SalFisher47\7za if not present
; disabled now, using Zip_Functions.au3
;If Not FileExists($7z) Then
;	DirCreate($7z_dir)
;	FileInstall("_FileInstall\7za\7za.exe", $7z_dir & "\7za.exe", 0)
;	FileInstall("_FileInstall\7za\7-Zip.chm", $7z_dir & "\7-Zip.chm", 0)
;	FileInstall("_FileInstall\7za\License.txt", $7z_dir & "\License.txt", 0)
;	FileInstall("_FileInstall\7za\Readme.txt", $7z_dir & "\Readme.txt", 0)
;EndIf

$exe32_run = IniRead($Ini, "Exe", "exe32_run", "")
$exe32_path_full = @ScriptDir & "\" & $exe32_run
$exe32_only = StringTrimLeft($exe32_path_full, StringInStr($exe32_path_full, "\", 0, -1))
$exe32_path_only = StringTrimRight($exe32_path_full, StringLen($exe32_only)+1)
$exe32_cmd = IniRead($Ini, "Exe", "exe32_cmd", "")
If $exe32_cmd <> "" Then
	If $CmdLineRaw <> "" Then
		If $CmdLineRaw <> $exe32_cmd Then
			$exe32_cmd = $exe32_cmd & " " & $CmdLineRaw
		EndIf
	EndIf
EndIf
$exe32_compat = IniRead($Ini, "Exe", "exe32_compat", "")

$exe32_run_alt = IniRead($Ini, "Exe", "exe32_run_alt", "")
$exe32_path_full_alt = @ScriptDir & "\" & $exe32_run_alt
$exe32_only_alt = StringTrimLeft($exe32_path_full_alt, StringInStr($exe32_path_full_alt, "\", 0, -1))
$exe32_path_only_alt = StringTrimRight($exe32_path_full_alt, StringLen($exe32_only_alt)+1)
$exe32_cmd_alt = IniRead($Ini, "Exe", "exe32_cmd_alt", "")
If $exe32_cmd_alt <> "" Then
	If $CmdLineRaw <> "" Then
		If $CmdLineRaw <> $exe32_cmd_alt Then
			$exe32_cmd_alt = $exe32_cmd_alt & " " & $CmdLineRaw
		EndIf
	EndIf
EndIf
$exe32_compat_alt = IniRead($Ini, "Exe", "exe32_compat_alt", "")

$exe64_run = IniRead($Ini, "Exe", "exe64_run", "")
$exe64_path_full = @ScriptDir & "\" & $exe64_run
$exe64_only = StringTrimLeft($exe64_path_full, StringInStr($exe64_path_full, "\", 0, -1))
$exe64_path_only = StringTrimRight($exe64_path_full, StringLen($exe64_only)+1)
$exe64_cmd = IniRead($Ini, "Exe", "exe64_cmd", "")
If $exe64_cmd <> "" Then
	If $CmdLineRaw <> "" Then
		If $CmdLineRaw <> $exe64_cmd Then
			$exe64_cmd = $exe64_cmd & " " & $CmdLineRaw
		EndIf
	EndIf
EndIf
$exe64_compat = IniRead($Ini, "Exe", "exe64_compat", "")

$exe64_run_alt = IniRead($Ini, "Exe", "exe64_run_alt", "")
$exe64_path_full_alt = @ScriptDir & "\" & $exe64_run_alt
$exe64_only_alt = StringTrimLeft($exe64_path_full_alt, StringInStr($exe64_path_full_alt, "\", 0, -1))
$exe64_path_only_alt = StringTrimRight($exe64_path_full_alt, StringLen($exe64_only_alt)+1)
$exe64_cmd_alt = IniRead($Ini, "Exe", "exe64_cmd_alt", "")
If $exe64_cmd_alt <> "" Then
	If $CmdLineRaw <> "" Then
		If $CmdLineRaw <> $exe64_cmd_alt Then
			$exe64_cmd_alt = $exe64_cmd_alt & " " & $CmdLineRaw
		EndIf
	EndIf
EndIf
$exe64_compat_alt = IniRead($Ini, "Exe", "exe64_compat_alt", "")

$run_next = IniRead($Ini, "Exe", "run_next", 0)

; convert cpu affinity mask from binary to hexadecimal
$affinity_mask_bin = IniRead($Ini, "process", "affinity_mask", "")
If $affinity_mask_bin <> "" Then
	$affinity_mask_dec = _Bin2Dec($affinity_mask_bin)
	$affinity_mask_hex = Hex($affinity_mask_dec)
	For $i = 1 To StringLen($affinity_mask_hex)
		If StringLeft($affinity_mask_hex, 1) == 0 Then
			$affinity_mask_hex = StringTrimLeft($affinity_mask_hex, 1)
		EndIf
	Next
	$affinity_mask_hex = "0x" & $affinity_mask_hex
EndIf

; real game exe (32bit)
$exe32R = IniRead($Ini, "process", "exe32_real", "")
If $exe32R == "" Then
	$exe32R = $exe32_run
	$exe32R_path_full = $exe32_path_full
	$exe32R_only = $exe32_only
	$exe32R_path_only = $exe32_path_only
Else
	$exe32R_path_full = @ScriptDir & "\" & $exe32R
	$exe32R_only = StringTrimLeft($exe32R_path_full, StringInStr($exe32R_path_full, "\", 0, -1))
	$exe32R_path_only = StringTrimRight($exe32R_path_full, StringLen($exe32R_only)+1)
EndIf

; real game exe (64bit)
$exe64R = IniRead($Ini, "process", "exe64_real", "")
If $exe64R == "" Then
	$exe64R = $exe64_run
	$exe64R_path_full = $exe64_path_full
	$exe64R_only = $exe64_only
	$exe64R_path_only = $exe64_path_only
Else
	$exe64R_path_full = @ScriptDir & "\" & $exe64R
	$exe64R_only = StringTrimLeft($exe64R_path_full, StringInStr($exe64R_path_full, "\", 0, -1))
	$exe64R_path_only = StringTrimRight($exe64R_path_full, StringLen($exe64R_only)+1)
EndIf

; check for savegame path and add it to ini file in C:\ProgramData\SalFisher47\UniGame Launcher
$ini_Savegame_dir = IniRead($ini, "savegame", "savegame_dir", "")
$ini_Savegame_subdir = IniRead($ini, "savegame", "savegame_subdir", "")
$Savegame_dir = ""
Switch $ini_Savegame_dir
	Case "_MyDocs_" Or "MyDocs"
		$Savegame_dir = @MyDocumentsDir & "\" & $ini_Savegame_subdir
	Case "_PublicDocs_" Or "PublicDocs"
		$Savegame_dir = @DocumentsCommonDir & "\" & $ini_Savegame_subdir
	Case "_RoamingAppData_" Or "RoamingAppData"
		$Savegame_dir = $Env_RoamingAppData & "\" & $ini_Savegame_subdir
	Case "_LocalAppData_" Or "LocalAppData"
		$Savegame_dir = $Env_LocalAppData & "\" & $ini_Savegame_subdir
	Case "_ProgramData_" Or "ProgramData"
		$Savegame_dir = $Env_ProgramData & "\" & $ini_Savegame_subdir
	Case "_SavedGames_" Or "SavedGames"
		$Savegame_dir = $Env_SavedGames & "\" & $ini_Savegame_subdir
	Case "_UserProfile_" Or "UserProfile"
		$Savegame_dir = @UserProfileDir & "\" & $ini_Savegame_subdir
	Case "_GameDir_" Or "GameDir"
		$Savegame_dir = @ScriptDir & "\" & $ini_Savegame_subdir
EndSwitch

; kill incompatible processes before starting the game
$Ini_kill_process = IniRead($Ini, "process", "end_process", "")
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

; intialize some variables and read fireall settings
Local $sName, $sPath, $sPort, $sRule, $sDelete, $sBin, $run_firewall

$Ini_firewall_block_in = IniRead($Ini, "Firewall", "exe_block_inbound", "")
$Ini_firewall_block_in_check = IniRead($Ini_ProgramData, "Firewall", "exe_block_inbound", "")
If $Ini_firewall_block_in <> $Ini_firewall_block_in_check Then
	IniWrite($Ini_ProgramData, "Firewall", "exe_block_inbound", " " & $Ini_firewall_block_in)
	$run_firewall = 1
EndIf
$firewall_block_in = ""
If $Ini_firewall_block_in <> "" Then $firewall_block_in = StringSplit($Ini_firewall_block_in, ", ", $STR_ENTIRESPLIT)

$Ini_firewall_block_out = IniRead($Ini, "Firewall", "exe_block_outbound", "")
$Ini_firewall_block_out_check = IniRead($Ini_ProgramData, "Firewall", "exe_block_outbound", "")
If $Ini_firewall_block_out <> $Ini_firewall_block_out_check Then
	IniWrite($Ini_ProgramData, "Firewall", "exe_block_outbound", " " & $Ini_firewall_block_out)
	$run_firewall = 1
EndIf
$firewall_block_out = ""
If $Ini_firewall_block_out <> "" Then $firewall_block_out = StringSplit($Ini_firewall_block_out, ", ", $STR_ENTIRESPLIT)

$Ini_exe_block_Reset = IniRead($Ini, "Firewall", "exe_block_Reset", 0)
$Ini_exe_block_Reset_check = IniRead($Ini_ProgramData, "Firewall", "exe_block_Reset", 0)
If $Ini_exe_block_Reset <> $Ini_exe_block_Reset_check Then
	IniWrite($Ini_ProgramData, "Firewall", "exe_block_Reset", " " & $Ini_exe_block_Reset)
	$run_firewall = 1
EndIf

$Ini_ports_open_tcp = IniRead($Ini, "Firewall", "port_open_TCP", "")
$Ini_ports_open_tcp_check = IniRead($Ini_ProgramData, "Firewall", "port_open_TCP", "")
If $Ini_ports_open_tcp <> $Ini_ports_open_tcp_check Then
	IniWrite($Ini_ProgramData, "Firewall", "port_open_TCP", " " & $Ini_ports_open_tcp)
	$run_firewall = 1
EndIf
$ports_open_tcp = ""
If $Ini_ports_open_tcp <> "" Then $ports_open_tcp = StringSplit($Ini_ports_open_tcp, ", ", $STR_ENTIRESPLIT)

$Ini_ports_open_udp = IniRead($Ini, "Firewall", "port_open_UDP", "")
$Ini_ports_open_udp_check = IniRead($Ini_ProgramData, "Firewall", "port_open_UDP", "")
If $Ini_ports_open_udp <> $Ini_ports_open_udp_check Then
	IniWrite($Ini_ProgramData, "Firewall", "port_open_UDP", " " & $Ini_ports_open_udp)
	$run_firewall = 1
EndIf
$ports_open_udp = ""
If $Ini_ports_open_udp <> "" Then $ports_open_udp = StringSplit($Ini_ports_open_udp, ", ", $STR_ENTIRESPLIT)

$Ini_port_open_Reset = IniRead($Ini, "Firewall", "port_open_Reset", 0)
$Ini_port_open_Reset_check = IniRead($Ini_ProgramData, "Firewall", "port_open_Reset", 0)
If $Ini_port_open_Reset <> $Ini_port_open_Reset_check Then
	IniWrite($Ini_ProgramData, "Firewall", "port_open_Reset", " " & $Ini_port_open_Reset)
	$run_firewall = 1
EndIf

;$desktopRatio = Round(@DesktopWidth/@DesktopHeight, 2) --- not used now

; check if running as administrator, then execute _RunMain, _RunBefore & _RunAfter functions
If IniRead($Ini_ProgramData, "game", "game_path", "") <> @ScriptDir Then
	$first_launch = 1
	IniWrite($Ini_ProgramData, "game", "game_path", " " & @ScriptDir)
	If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
		IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
	EndIf
	If $ini_RunAdmin == 1 Then
		_RunAdmin()
		Exit
	Else
		If $run_firewall <> 1 Then
			_RunMain()
			Exit
		Else
			_RunAdmin()
			Exit
		EndIf
	EndIf
Else
	If IsAdmin() Then
		$first_launch = 1
		If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
			IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
		EndIf
		_RunMain()
		FileDelete(StringTrimRight(@ScriptFullPath, 3) & "a3x") ; delete .a3x script when running through a3x wrapper
		Exit
	Else
		If $run_firewall <> 1 Then
			$first_launch = 0
			If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
				IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
			EndIf
			_RunMain()
			FileDelete(StringTrimRight(@ScriptFullPath, 3) & "a3x") ; delete .a3x script when running through a3x wrapper
			Exit
		Else
			$first_launch = 1
			If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
				IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
			EndIf
			_RunAdmin()
			FileDelete(StringTrimRight(@ScriptFullPath, 3) & "a3x") ; delete .a3x script when running through a3x wrapper
			Exit
		EndIf
	EndIf
EndIf

; use this only if you want launcher friendly paths for ini files in C:\ProgramData\SalFisher47\UniGame Launcher
; $Savegame_dir = IniRead($Ini_ProgramData, "game", "savegame_path", "")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @MyDocumentsDir, "_MyDocs_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @DocumentsCommonDir, "_PublicDocs_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @LocalAppDataDir, "_LocalAppData_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @AppDataDir, "_RoamingAppData_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @AppDataCommonDir, "_ProgramData_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @UserProfileDir, "_UserProfile_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], $Env_SavedGames, "_SavedGames_")
;_ReplaceStringInFile($ini_1stRun_open_file[$j], @ScriptDir, "_GameDir_")

Func _1st_run()
	;$Unpack_Line_1st_run_7z = ' x -y -o' & '"' & @ScriptDir & '\_1st_run' & '"' & ' ' & '"' & @ScriptDir & "\_1st_run.7z" ; unpack whole archive
	;$Unpack_Line_1st_run_ini = ' x -y -o' & '"' & @TempDir & '\_1st_run' & '"' & ' ' & '"' & @ScriptDir & "\_1st_run.7z" & '"' & ' ' & '"' & '_1st_run.ini' & '"' ; unpack only '_1st_run.ini' from archive
	;$Unpack_Line_1st_run_dir = ' x -y -o' & '"' & @TempDir & '\_1st_run\destination_folder_name' & '"' & ' ' & '"' & @ScriptDir & "\_1st_run.7z" & '"' & ' ' & '"' & 'source_folder_name' & '\*' & '"' ; unpack 'source_folder_name' from archive
	;ShellExecuteWait("7za.exe", $Unpack_Line_1st_run_7z, $7z_dir, "", @SW_HIDE) ; disabled now, using Zip_Functions.au3
	_Zip_UnzipAll(@ScriptDir & "\_1st_run.zip", @ScriptDir & "\_1st_run")
	;---
	Local $ini_1stRun_copy_from[1], $ini_1stRun_copy_to[1], $ini_1stRun_open_file[1], $ini_1stRun_file_cmd[1]
	For $i = 1 To 9
		_ArrayAdd($ini_1stRun_copy_from, IniRead(@ScriptDir & "\_1st_run\_1st_run.ini", "copy", "copy_from" & $i, ""))
		If $ini_1stRun_copy_from[$i] <> "" Then
			Switch StringLeft($ini_1stRun_copy_from[$i], 8)
				Case "_SaveDir"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_SaveDir_", $Savegame_dir)
				Case "_MyDocs_"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_MyDocs_", @MyDocumentsDir)
				Case "_PublicD"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_PublicDocs_", @DocumentsCommonDir )
				Case "_LocalAp"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_LocalAppData_", @LocalAppDataDir)
				Case "_Roaming"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_RoamingAppData_", @AppDataDir)
				Case "_Program"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_ProgramData_", @AppDataCommonDir)
				Case "_UserPro"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_UserProfile_", @UserProfileDir)
				Case "_SavedGa"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_SavedGames_", $Env_SavedGames)
				Case "_GameDir"
					$ini_1stRun_copy_from[$i] = StringReplace($ini_1stRun_copy_from[$i], "_GameDir_", @ScriptDir)
				Case Else
					$ini_1stRun_copy_from[$i] = @ScriptDir & "\_1st_run\" & $ini_1stRun_copy_from[$i]
			EndSwitch
		EndIf
		_ArrayAdd($ini_1stRun_copy_to, IniRead(@ScriptDir & "\_1st_run\_1st_run.ini", "copy", "copy_to" & $i, ""))
		If $ini_1stRun_copy_to[$i] <> "" Then
			Switch StringLeft($ini_1stRun_copy_to[$i], 8)
				Case "_SaveDir"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_SaveDir_", $Savegame_dir)
				Case "_MyDocs_"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_MyDocs_", @MyDocumentsDir)
				Case "_PublicD"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_PublicDocs_", @DocumentsCommonDir )
				Case "_LocalAp"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_LocalAppData_", @LocalAppDataDir)
				Case "_Roaming"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_RoamingAppData_", @AppDataDir)
				Case "_Program"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_ProgramData_", @AppDataCommonDir)
				Case "_UserPro"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_UserProfile_", @UserProfileDir)
				Case "_SavedGa"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_SavedGames_", $Env_SavedGames)
				Case "_GameDir"
					$ini_1stRun_copy_to[$i] = StringReplace($ini_1stRun_copy_to[$i], "_GameDir_", @ScriptDir)
			EndSwitch
		EndIf
		If $ini_1stRun_copy_to[$i] == $Savegame_dir Then
			If DirGetSize($ini_1stRun_copy_to[$i]) <> 0 Then
				DirCopy($ini_1stRun_copy_to[$i], $ini_1stRun_copy_to[$i] & "_1st_run", 1)
				FileCreateShortcut($ini_1stRun_copy_to[$i] & "_1st_run", $ini_1stRun_copy_to[$i] & "\_1st_run.lnk")
				DirCopy($ini_1stRun_copy_from[$i], $ini_1stRun_copy_to[$i], 1)
			Else
				DirCopy($ini_1stRun_copy_from[$i], $ini_1stRun_copy_to[$i], 1)
			EndIf
		Else
			DirCopy($ini_1stRun_copy_from[$i], $ini_1stRun_copy_to[$i], 1)
		EndIf
	Next
	For $j = 1 To 9
		_ArrayAdd($ini_1stRun_open_file, IniRead(@ScriptDir & "\_1st_run\_1st_run.ini", "open", "open_file" & $j, ""))
		If $ini_1stRun_open_file[$j] <> "" Then
			Switch StringLeft($ini_1stRun_open_file[$j], 8)
				Case "_SaveDir"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_SaveDir_", $Savegame_dir)
				Case "_MyDocs_"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_MyDocs_", @MyDocumentsDir)
				Case "_PublicD"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_PublicDocs_", @DocumentsCommonDir )
				Case "_LocalAp"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_LocalAppData_", @LocalAppDataDir)
				Case "_Roaming"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_RoamingAppData_", @AppDataDir)
				Case "_Program"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_ProgramData_", @AppDataCommonDir)
				Case "_UserPro"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_UserProfile_", @UserProfileDir)
				Case "_SavedGa"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_SavedGames_", $Env_SavedGames)
				Case "_GameDir"
					$ini_1stRun_open_file[$j] = StringReplace($ini_1stRun_open_file[$j], "_GameDir_", @ScriptDir)
				Case Else
					$ini_1stRun_open_file[$j] = @ScriptDir & "\_1st_run\" & $ini_1stRun_open_file[$j]
			EndSwitch
		EndIf
		_ArrayAdd($ini_1stRun_file_cmd, IniRead(@ScriptDir & "\_1st_run\_1st_run.ini", "open", "file_cmd" & $j, ""))
		If $ini_1stRun_file_cmd[$j] <> "" Then
			If $CmdLineRaw <> "" Then
				If $CmdLineRaw <> $ini_1stRun_file_cmd[$j] Then
					$ini_1stRun_file_cmd[$j] = $ini_1stRun_file_cmd[$j] & " " & $CmdLineRaw
				EndIf
			EndIf
		EndIf
		$open_file_only = StringTrimLeft($ini_1stRun_open_file[$j], StringInStr($ini_1stRun_open_file[$j], "\", 0, -1))
		$open_file_path_only = StringTrimRight($ini_1stRun_open_file[$j], StringLen($open_file_only)+1)
		$open_file_extension = StringRight($open_file_only, 4)
		If $ini_1stRun_open_file[$j] <> "" Then
			Switch $open_file_extension
				Case ".au3", ".a3x"
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_SaveDir_", $Savegame_dir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_MyDocs_", @MyDocumentsDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_PublicDocs_", @DocumentsCommonDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_LocalAppData_", @LocalAppDataDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_RoamingAppData_", @AppDataDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_ProgramData_", @AppDataCommonDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_UserProfile_", @UserProfileDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_SavedGames_", $Env_SavedGames)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_GameDir_", @ScriptDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_LauncherName_", @ScriptName)
					ShellExecuteWait(@ScriptFullPath, ' /AutoIt3ExecuteScript ' & '"' & $ini_1stRun_open_file[$j] & '"', $open_file_path_only)
				Case ".bat", ".ps1"
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_SaveDir_", $Savegame_dir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_MyDocs_", @MyDocumentsDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_PublicDocs_", @DocumentsCommonDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_LocalAppData_", @LocalAppDataDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_RoamingAppData_", @AppDataDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_ProgramData_", @AppDataCommonDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_UserProfile_", @UserProfileDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_SavedGames_", $Env_SavedGames)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_GameDir_", @ScriptDir)
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_LauncherName_", @ScriptName)
					Switch $open_file_extension
						Case ".bat"
							FileInstall("_FileInstall\run_scripts\bat_script.au3", $ini_1stRun_open_file[$j] & '.au3', 1)
						Case ".ps1"
							FileInstall("_FileInstall\run_scripts\bat_script.au3", $ini_1stRun_open_file[$j] & '.au3', 1)
							If FileExists(StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat') Then
								FileCopy(StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat', StringTrimRight($ini_1stRun_open_file[$j], 4) & '_1st_run.bat', 1)
								FileInstall("_FileInstall\run_scripts\ps1_script.bat", StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat', 1)
							Else
								FileInstall("_FileInstall\run_scripts\ps1_script.bat", StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat', 1)
							EndIf
					EndSwitch
					_ReplaceStringInFile($ini_1stRun_open_file[$j] & '.au3', "_file_path_", '"' & StringTrimRight($ini_1stRun_open_file[$j], 4) & ".bat" & '"')
					;RunWait(@ScriptFullPath & ' /AutoIt3ExecuteScript ' & '"' & $ini_1stRun_open_file[$j] & '.au3' & '"') ; for some reason this runs a second similarly named launcher if present, so we're gonna use ShellExecuteWait instead which prevents this from happening
					ShellExecuteWait(@AutoItExe, ' /AutoIt3ExecuteScript ' & '"' & $ini_1stRun_open_file[$j] & '.au3' & '"', @ScriptDir)
				Case ".reg"
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_SaveDir_", StringReplace($Savegame_dir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_MyDocs_", StringReplace(@MyDocumentsDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_PublicDocs_", StringReplace(@DocumentsCommonDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_LocalAppData_", StringReplace(@LocalAppDataDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_RoamingAppData_", StringReplace(@AppDataDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_ProgramData_", StringReplace(@AppDataCommonDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_UserProfile_", StringReplace(@UserProfileDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_SavedGames_", StringReplace($Env_SavedGames, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_GameDir_", StringReplace(@ScriptDir, "\", "\\"))
					_ReplaceStringInFile($ini_1stRun_open_file[$j], "_LauncherName_", @ScriptName)
					FileInstall("_FileInstall\run_scripts\bat_script.au3", $ini_1stRun_open_file[$j] & '.au3', 1)
					If FileExists(StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat') Then
						FileCopy(StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat', StringTrimRight($ini_1stRun_open_file[$j], 4) & '_1st_run.bat', 1)
						FileInstall("_FileInstall\run_scripts\reg_script_silent.bat", StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat', 1)
					Else
						FileInstall("_FileInstall\run_scripts\reg_script_silent.bat", StringTrimRight($ini_1stRun_open_file[$j], 4) & '.bat', 1)
					EndIf
					_ReplaceStringInFile($ini_1stRun_open_file[$j] & '.au3', "_file_path_", '"' & StringTrimRight($ini_1stRun_open_file[$j], 4) & ".bat" & '"')
					;RunWait(@ScriptFullPath & ' /AutoIt3ExecuteScript ' & '"' & $ini_1stRun_open_file[$j] & '.au3' & '"') ; for some reason this runs a second similarly named launcher if present, so we're gonna use ShellExecuteWait instead which prevents this from happening
					ShellExecuteWait(@AutoItExe, ' /AutoIt3ExecuteScript ' & '"' & $ini_1stRun_open_file[$j] & '.au3' & '"', @ScriptDir)
				Case Else
					ShellExecuteWait($open_file_only, $ini_1stRun_file_cmd[$j], $open_file_path_only)
			EndSwitch
		EndIf
	Next
	DirRemove(@ScriptDir & "\_1st_run", 1)
	For $k = 1 to 9
		If FileExists(StringTrimRight($ini_1stRun_open_file[$k], 4) & '_1st_run.bat') Then
			FileDelete(StringTrimRight($ini_1stRun_open_file[$k], 4) & '.bat')
			FileMove(StringTrimRight($ini_1stRun_open_file[$k], 4) & '_1st_run.bat', StringTrimRight($ini_1stRun_open_file[$k], 4) & '.bat', 1)
		EndIf
	Next
EndFunc

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
		If $Ini_exe_block_Reset <> 1 Then
			If $Ini_firewall_block_in <> "" Then
				For $i = 1 To $firewall_block_in[0]
					_FirewallBlockExe("_Block " & "'" & StringTrimLeft($firewall_block_in[$i], StringInStr($firewall_block_in[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_in[$i], "inbound", 1)
				Next
			EndIf
			If $Ini_firewall_block_out <> "" Then
				For $i = 1 To $firewall_block_out[0]
					_FirewallBlockExe("_Block " & "'" & StringTrimLeft($firewall_block_out[$i], StringInStr($firewall_block_out[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_out[$i], "outbound", 1)
				Next
			EndIf
		Else
			If $Ini_firewall_block_in <> "" Then
				For $i = 1 To $firewall_block_in[0]
					_FirewallAllowExe("_Block " & "'" & StringTrimLeft($firewall_block_in[$i], StringInStr($firewall_block_in[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_in[$i], "inbound", 1)
				Next
			EndIf
			If $Ini_firewall_block_out <> "" Then
				For $i = 1 To $firewall_block_out[0]
					_FirewallAllowExe("_Block " & "'" & StringTrimLeft($firewall_block_out[$i], StringInStr($firewall_block_out[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_out[$i], "outbound", 1)
				Next
			EndIf
		EndIf
		If $Ini_port_open_Reset <> 1 Then
			If $Ini_ports_open_tcp <> "" Then
				For $i = 1 To $ports_open_tcp[0]
					_FirewallOpenTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "inbound", 1)
					_FirewallOpenTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "outbound", 1)
				Next
			EndIf
			If $Ini_ports_open_udp <> "" Then
				For $i = 1 To $ports_open_udp[0]
					_FirewallOpenUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "inbound", 1)
					_FirewallOpenUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "outbound", 1)
				Next
			EndIf
		Else
			If $Ini_ports_open_tcp <> "" Then
				For $i = 1 To $ports_open_tcp[0]
					_FirewallCloseTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "inbound", 1)
					_FirewallCloseTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "outbound", 1)
				Next
			EndIf
			If $Ini_ports_open_udp <> "" Then
				For $i = 1 To $ports_open_udp[0]
					_FirewallCloseUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "inbound", 1)
					_FirewallCloseUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "outbound", 1)
				Next
			EndIf
		EndIf
		; add commands here to run before game exe at first launch
		If $ini_1stRun == 1 Then _1st_run()
		;_RunBefore_FirstLaunch()
		If $affinity_mask_bin <> "" Then
			If $exe32_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute($exe32_only_alt, " " & $exe32_cmd_alt, $exe32_path_only_alt)
					$pid = ProcessWait($exe32_only_alt)
					_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
				Else
					ShellExecute($exe32_only_alt, " " & $exe32_cmd_alt, $exe32_path_only_alt)
					$pid = ProcessWait($exe32_only_alt)
					_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
					;ProcessWait($exe32_only_alt) --- not used now
					ProcessWaitClose($exe32_only_alt)
					Sleep(250)
					If Not ProcessExists($exe32_only) Then
						ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
						$pid = ProcessWait($exe32R_only)
						_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
					EndIf
				EndIf
			Else
				ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
				$pid = ProcessWait($exe32R_only)
				_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
			EndIf
		Else
			If $exe32_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute($exe32_only_alt, " " & $exe32_cmd_alt, $exe32_path_only_alt)
				Else
					ShellExecute($exe32_only_alt, " " & $exe32_cmd_alt, $exe32_path_only_alt)
					ProcessWait($exe32_only_alt)
					ProcessWaitClose($exe32_only_alt)
					Sleep(250)
					If Not ProcessExists($exe32_only) Then
						ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
					EndIf
				EndIf
			Else
				ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
			EndIf
		EndIf
		; add commands here to run after game exe at first launch
		;_RunAfter_FirstLaunch()
	Else
		; add commands here to run before game exe at every launch, except the first one
		;_RunBefore_EveryLaunch()
		If $affinity_mask_bin <> "" Then
			ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
			$pid = ProcessWait($exe32R_only)
			_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
		Else
			ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
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
		If $Ini_exe_block_Reset <> 1 Then
			If $Ini_firewall_block_in <> "" Then
				For $i = 1 To $firewall_block_in[0]
					_FirewallBlockExe("_Block " & "'" & StringTrimLeft($firewall_block_in[$i], StringInStr($firewall_block_in[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_in[$i], "inbound", 1)
				Next
			EndIf
			If $Ini_firewall_block_out <> "" Then
				For $i = 1 To $firewall_block_out[0]
					_FirewallBlockExe("_Block " & "'" & StringTrimLeft($firewall_block_out[$i], StringInStr($firewall_block_out[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_out[$i], "outbound", 1)
				Next
			EndIf
		Else
			If $Ini_firewall_block_in <> "" Then
				For $i = 1 To $firewall_block_in[0]
					_FirewallAllowExe("_Block " & "'" & StringTrimLeft($firewall_block_in[$i], StringInStr($firewall_block_in[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_in[$i], "inbound", 1)
				Next
			EndIf
			If $Ini_firewall_block_out <> "" Then
				For $i = 1 To $firewall_block_out[0]
					_FirewallAllowExe("_Block " & "'" & StringTrimLeft($firewall_block_out[$i], StringInStr($firewall_block_out[$i], "\", 0, -1)) & "'" & " - SalFisher47", @ScriptDir & "\" & $firewall_block_out[$i], "outbound", 1)
				Next
			EndIf
		EndIf
		If $Ini_port_open_Reset <> 1 Then
			If $Ini_ports_open_tcp <> "" Then
				For $i = 1 To $ports_open_tcp[0]
					_FirewallOpenTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "inbound", 1)
					_FirewallOpenTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "outbound", 1)
				Next
			EndIf
			If $Ini_ports_open_udp <> "" Then
				For $i = 1 To $ports_open_udp[0]
					_FirewallOpenUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "inbound", 1)
					_FirewallOpenUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "outbound", 1)
				Next
			EndIf
		Else
			If $Ini_ports_open_tcp <> "" Then
				For $i = 1 To $ports_open_tcp[0]
					_FirewallCloseTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "inbound", 1)
					_FirewallCloseTCP("_Open TCP port " & $ports_open_tcp[$i] & " - SalFisher47", $ports_open_tcp[$i], "outbound", 1)
				Next
			EndIf
			If $Ini_ports_open_udp <> "" Then
				For $i = 1 To $ports_open_udp[0]
					_FirewallCloseUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "inbound", 1)
					_FirewallCloseUDP("_Open UDP port " & $ports_open_udp[$i] & " - SalFisher47", $ports_open_udp[$i], "outbound", 1)
				Next
			EndIf
		EndIf
		; add commands here to run before game exe at first launch
		If $ini_1stRun == 1 Then _1st_run()
		;_RunBefore_FirstLaunch()
		If $affinity_mask_bin <> "" Then
			If $exe64_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute($exe64_only_alt, " " & $exe64_cmd_alt, $exe64_path_only_alt)
					$pid = ProcessWait($exe64_only_alt)
					_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
				Else
					ShellExecute($exe64_only_alt, " " & $exe64_cmd_alt, $exe64_path_only_alt)
					$pid = ProcessWait($exe64_only_alt)
					_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
					;ProcessWait($exe64_only_alt) --- not used now
					ProcessWaitClose($exe64_only_alt)
					Sleep(250)
					If Not ProcessExists($exe64_only) Then
						ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
						$pid = ProcessWait($exe64R_only)
						_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
					EndIf
				EndIf
			Else
				ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
				$pid = ProcessWait($exe64R_only)
				_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
			EndIf
		Else
			If $exe64_run_alt <> "" Then
				If $run_next <> 1 Then
					ShellExecute($exe64_only_alt, " " & $exe64_cmd_alt, $exe64_path_only_alt)
				Else
					ShellExecute($exe64_only_alt, " " & $exe64_cmd_alt, $exe64_path_only_alt)
					ProcessWait($exe64_only_alt)
					ProcessWaitClose($exe64_only_alt)
					Sleep(250)
					If Not ProcessExists($exe64_only) Then
						ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
					EndIf
				EndIf
			Else
				ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
			EndIf
		EndIf
		; add commands here to run after game exe at first launch
		;_RunAfter_FirstLaunch()
	Else
		; add commands here to run before game exe at every launch, except the first one
		;_RunBefore_EveryLaunch()
		If $affinity_mask_bin <> "" Then
			ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
			$pid = ProcessWait($exe64R_only)
			_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
		Else
			ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
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

Func _FirewallBlockExe($sName, $sPath, $sRule, $sDelete)
	Switch $sRule
		Case "inbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " program = " & Chr(34) & $sPath & Chr(34) & " dir = in", "", @SW_HIDE)
			EndIf
			RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = in action = block program = " & Chr(34) & $sPath & Chr(34) & " enable = yes", "", @SW_HIDE)
		Case "outbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " program = " & Chr(34) & $sPath & Chr(34) & " dir = out", "", @SW_HIDE)
			EndIf
			RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = out action = block program = " & Chr(34) & $sPath & Chr(34) & " enable = yes", "", @SW_HIDE)
	EndSwitch
EndFunc

Func _FirewallAllowExe($sName, $sPath, $sRule, $sDelete)
	Switch $sRule
		Case "inbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " program = " & Chr(34) & $sPath & Chr(34) & " dir = in", "", @SW_HIDE)
			EndIf
			;RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = in action = allow program = " & Chr(34) & $sPath & Chr(34) & " enable = yes", "", @SW_HIDE)
		Case "outbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " program = " & Chr(34) & $sPath & Chr(34) & " dir = out", "", @SW_HIDE)
			EndIf
			;RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = out action = allow program = " & Chr(34) & $sPath & Chr(34) & " enable = yes", "", @SW_HIDE)
	EndSwitch
EndFunc

Func _FirewallOpenTCP($sName, $sPort, $sRule, $sDelete)
	Switch $sRule
		Case "inbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = TCP localport = " & $sPort & " dir = in", "", @SW_HIDE)
			EndIf
			RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = in action = allow protocol = TCP localport = " & $sPort, "", @SW_HIDE)
		Case "outbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = TCP localport = " & $sPort & " dir = out", "", @SW_HIDE)
			EndIf
			RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = out action = allow protocol = TCP localport = " & $sPort, "", @SW_HIDE)
	EndSwitch
EndFunc

Func _FirewallCloseTCP($sName, $sPort, $sRule, $sDelete)
	Switch $sRule
		Case "inbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = TCP localport = " & $sPort & " dir = in", "", @SW_HIDE)
			EndIf
			;RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = in action = allow protocol = TCP localport = " & $sPort, "", @SW_HIDE)
		Case "outbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = TCP localport = " & $sPort & " dir = out", "", @SW_HIDE)
			EndIf
			;RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = out action = allow protocol = TCP localport = " & $sPort, "", @SW_HIDE)
	EndSwitch
EndFunc

Func _FirewallOpenUDP($sName, $sPort, $sRule, $sDelete)
	Switch $sRule
		Case "inbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = UDP localport = " & $sPort & " dir = in", "", @SW_HIDE)
			EndIf
			RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = in action = allow protocol = UDP localport = " & $sPort, "", @SW_HIDE)
		Case "outbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = UDP localport = " & $sPort & " dir = out", "", @SW_HIDE)
			EndIf
			RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = out action = allow protocol = UDP localport = " & $sPort, "", @SW_HIDE)
	EndSwitch
EndFunc

Func _FirewallCloseUDP($sName, $sPort, $sRule, $sDelete)
	Switch $sRule
		Case "inbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = UDP localport = " & $sPort & " dir = in", "", @SW_HIDE)
			EndIf
			;RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = in action = allow protocol = UDP localport = " & $sPort, "", @SW_HIDE)
		Case "outbound"
			If $sDelete == 1 Then
				RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = UDP localport = " & $sPort & " dir = out", "", @SW_HIDE)
			EndIf
			;RunWait(@ComSpec & " /c " & "netsh advfirewall firewall add rule name = " & Chr(34) & $sName & Chr(34) & " dir = out action = allow protocol = UDP localport = " & $sPort, "", @SW_HIDE)
	EndSwitch
EndFunc

Func _Bin2Dec($sBin)
    Return BitOr((StringLen($sBin) > 1 ? BitShift(_Bin2Dec(StringTrimRight($sBin, 1)), -1) : 0), StringRight($sBin, 1))
EndFunc ; https://www.autoitscript.com/forum/topic/163035-dec2bin-bin2dec/

Func _Dec2Bin($sBin)
    Return (BitShift($sBin, 1) ? _Dec2Bin(BitShift($sBin, 1)) : "") & BitAnd($sBin, 1)
EndFunc ; https://www.autoitscript.com/forum/topic/163035-dec2bin-bin2dec/