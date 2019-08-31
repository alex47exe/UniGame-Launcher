#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_one.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.4.7.47
#AutoIt3Wrapper_Res_ProductVersion=1.4.7.47
#AutoIt3Wrapper_Res_LegalCopyright=2017-2019, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/tl /sf /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ;**** Pragma Compile ****
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Compression, 9)
#pragma compile(InputBoxRes, true)
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(FileVersion, 1.4.7.47)
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017-2019, SalFisher47')
#pragma compile(OriginalFilename, UniGame_Launcher_one.exe)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(ProductVersion, 1.4.7.47)
#EndRegion ;**** Pragma Compile ****

; === UniGame_Launcher_one.au3 =====================================================================================================
; Title .........: UniGame Launcher
; Version .......: 1.4.7.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Universal Game Launcher one
; Author(s) .....: SalFisher47
; Last Modified .: August 31, 2019 - last compiled on August 31, 2019
; ==================================================================================================================================

#include <ProcessConstants.au3>
#include <StringConstants.au3>
#include <WinAPI.au3>

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
$Ini_ProgramData = @AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini"
FileInstall("ProgramData.ini", $Ini_ProgramData, 0)

$exe_run = IniRead($Ini, "Exe", "exe_run", "")
$exe_path_full = @ScriptDir & "\" & $exe_run
$exe_only = StringTrimLeft($exe_path_full, StringInStr($exe_path_full, "\", 0, -1))
$exe_path_only = StringTrimRight($exe_path_full, StringLen($exe_only)+1)
$exe_cmd = IniRead($Ini, "Exe", "exe_cmd", "")
If $exe_cmd <> "" Then
	If $CmdLineRaw <> "" Then
		If $CmdLineRaw <> $exe_cmd Then
			$exe_cmd = $exe_cmd & " " & $CmdLineRaw
		EndIf
	EndIf
EndIf
$exe_compat = IniRead($Ini, "Exe", "exe_compat", "")

$exe_run_alt = IniRead($Ini, "Exe", "exe_run_alt", "")
$exe_path_full_alt = @ScriptDir & "\" & $exe_run_alt
$exe_only_alt = StringTrimLeft($exe_path_full_alt, StringInStr($exe_path_full_alt, "\", 0, -1))
$exe_path_only_alt = StringTrimRight($exe_path_full_alt, StringLen($exe_only_alt)+1)
$exe_cmd_alt = IniRead($Ini, "Exe", "exe_cmd_alt", "")
If $exe_cmd_alt <> "" Then
	If $CmdLineRaw <> "" Then
		If $CmdLineRaw <> $exe_cmd_alt Then
			$exe_cmd_alt = $exe_cmd_alt & " " & $CmdLineRaw
		EndIf
	EndIf
EndIf
$exe_compat_alt = IniRead($Ini, "Exe", "exe_compat_alt", "")

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

; real game exe
$exeR = IniRead($Ini, "process", "exe_real", "")
If $exeR == "" Then
	$exeR = $exe_run
	$exeR_path_full = $exe_path_full
	$exeR_only = $exe_only
	$exeR_path_only = $exe_path_only
Else
	$exeR_path_full = @ScriptDir & "\" & $exeR
	$exeR_only = StringTrimLeft($exeR_path_full, StringInStr($exeR_path_full, "\", 0, -1))
	$exeR_path_only = StringTrimRight($exeR_path_full, StringLen($exeR_only)+1)
EndIf

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
		Exit
	Else
		If $run_firewall <> 1 Then
			$first_launch = 0
			If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
				IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
			EndIf
			_RunMain()
			Exit
		Else
			$first_launch = 1
			If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
				IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
			EndIf
			_RunAdmin()
			Exit
		EndIf
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
If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe_path_full) <> $exe_compat Then
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe_path_full, "REG_SZ", $exe_compat)
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
	;_RunBefore_FirstLaunch()
	If $affinity_mask_bin <> "" Then
		If $exe_run_alt <> "" Then
			If $run_next <> 1 Then
				ShellExecute($exe_only_alt, " " & $exe_cmd_alt, $exe_path_only_alt)
				$pid = ProcessWait($exe_only_alt)
				_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
			Else
				ShellExecute($exe_only_alt, " " & $exe_cmd_alt, $exe_path_only_alt)
				$pid = ProcessWait($exe_only_alt)
				_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
				;ProcessWait($exe_only_alt) --- not used now
				ProcessWaitClose($exe_only_alt)
				Sleep(250)
				If Not ProcessExists($exe_only) Then
					ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
					$pid = ProcessWait($exeR_only)
					_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
				EndIf
			EndIf
		Else
			ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
			$pid = ProcessWait($exeR_only)
			_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
		EndIf
	Else
		If $exe_run_alt <> "" Then
			If $run_next <> 1 Then
				ShellExecute($exe_only_alt, " " & $exe_cmd_alt, $exe_path_only_alt)
			Else
				ShellExecute($exe_only_alt, " " & $exe_cmd_alt, $exe_path_only_alt)
				ProcessWait($exe_only_alt)
				ProcessWaitClose($exe_only_alt)
				Sleep(250)
				If Not ProcessExists($exe_only) Then
					ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
				EndIf
			EndIf
		Else
			ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
		EndIf
	EndIf
	; add commands here to run after game exe at first launch
	;_RunAfter_FirstLaunch()
Else
	; add commands here to run before game exe at every launch, except the first one
	;_RunBefore_EveryLaunch()
	If $affinity_mask_bin <> "" Then
		ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
		$pid = ProcessWait($exeR_only)
		_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
	Else
		ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
	EndIf
	; add commands here to run after game exe at every launch, except the first one
	;_RunAfter_EveryLaunch()
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