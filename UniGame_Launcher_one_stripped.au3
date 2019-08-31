#NoTrayIcon
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
Global Const $PROCESS_SET_INFORMATION = 0x00000200
Global Const $PROCESS_QUERY_INFORMATION = 0x00000400
Global Const $STR_ENTIRESPLIT = 1
Global Const $SE_PRIVILEGE_ENABLED = 0x00000002
Global Enum $SECURITYANONYMOUS = 0, $SECURITYIDENTIFICATION, $SECURITYIMPERSONATION, $SECURITYDELEGATION
Global Const $TOKEN_QUERY = 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES = 0x00000020
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__ImpersonateSelf($iLevel = $SECURITYIMPERSONATION)
Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__LookupPrivilegeValue($sSystem, $sName)
Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[3]
EndFunc
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
If $hThread = 0 Then
Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error + 10, @extended, 0)
$hThread = $aResult[0]
EndIf
Local $aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[4]
EndFunc
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then
Local Const $ERROR_NO_TOKEN = 1008
If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
$hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
EndIf
Return $hToken
EndFunc
Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)
Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iCurrState = DllStructGetSize($tCurrState)
Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iPrevState = DllStructGetSize($tPrevState)
Local $tRequired = DllStructCreate("int Data")
DllStructSetData($tCurrState, "Count", 1)
DllStructSetData($tCurrState, "LUID", $iLUID)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)
DllStructSetData($tPrevState, "Count", 1)
DllStructSetData($tPrevState, "LUID", $iLUID)
Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
If $bEnable Then
$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
Else
$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
EndIf
DllStructSetData($tPrevState, "Attributes", $iAttributes)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then Return SetError(3, @error, False)
Return True
EndFunc
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Func _WinAPI_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return $aResult[0]
If Not $bDebugPriv Then Return SetError(100, 0, 0)
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error + 10, @extended, 0)
_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
Local $iError = @error
Local $iExtended = @extended
Local $iRet = 0
If Not @error Then
$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
$iError = @error
$iExtended = @extended
If $aResult[0] Then $iRet = $aResult[0]
_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
If @error Then
$iError = @error + 20
$iExtended = @extended
EndIf
Else
$iError = @error + 30
EndIf
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
Return SetError($iError, $iExtended, $iRet)
EndFunc
Func _WinAPI_SetProcessAffinityMask($hProcess, $iMask)
Local $aResult = DllCall("kernel32.dll", "bool", "SetProcessAffinityMask", "handle", $hProcess, "ulong_ptr", $iMask)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Global $Env_RoamingAppData = @AppDataDir, $Env_LocalAppData = @LocalAppDataDir, $Env_ProgramData = @AppDataCommonDir, $Env_UserProfile = @UserProfileDir, $Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"
$Ini = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"
$ini_RunAdmin = IniRead($ini, "launcher", "run_admin", "")
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
Func _RunMain()
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
Else
If $affinity_mask_bin <> "" Then
ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
$pid = ProcessWait($exeR_only)
_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
Else
ShellExecute($exe_only, " " & $exe_cmd, $exe_path_only)
EndIf
EndIf
EndFunc
Func _RunAdmin()
If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".exe") <> "RUNASADMIN" Then
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".exe", "REG_SZ", "RUNASADMIN")
EndIf
ShellExecute(StringTrimRight(@ScriptName, 4) & ".exe", $CmdLineRaw, @ScriptDir)
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
Case "outbound"
If $sDelete == 1 Then
RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " program = " & Chr(34) & $sPath & Chr(34) & " dir = out", "", @SW_HIDE)
EndIf
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
Case "outbound"
If $sDelete == 1 Then
RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = TCP localport = " & $sPort & " dir = out", "", @SW_HIDE)
EndIf
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
Case "outbound"
If $sDelete == 1 Then
RunWait(@ComSpec & " /c " & "netsh advfirewall firewall delete rule name = " & Chr(34) & $sName & Chr(34) & " protocol = UDP localport = " & $sPort & " dir = out", "", @SW_HIDE)
EndIf
EndSwitch
EndFunc
Func _Bin2Dec($sBin)
Return BitOr((StringLen($sBin) > 1 ? BitShift(_Bin2Dec(StringTrimRight($sBin, 1)), -1) : 0), StringRight($sBin, 1))
EndFunc
