#NoTrayIcon
#pragma compile(Console, False)
#pragma compile(x64, False)
#pragma compile(ExecLevel, AsInvoker)
#pragma compile(Compatibility, vista, win7, win8, win81, win10)
#pragma compile(AutoItExecuteAllowed, True)
#pragma compile(InputBoxRes, True)
#pragma compile(Stripper, True)
#pragma compile(FileVersion, 1.5.1.47)
#pragma compile(ProductVersion, 1.5.1.47)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017-2020, SalFisher47')
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(OriginalFilename, UniGame_Launcher_two.exe)
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
Case $ARRAYFILL_FORCE_BOOLEAN
$hDataType = "Boolean"
EndSwitch
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + 1]
$aArray[$iDim_1] = $vValue
Return $iDim_1
EndIf
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
EndIf
$vValue = $aTmp
EndIf
Local $iAdd = UBound($vValue, $UBOUND_ROWS)
ReDim $aArray[$iDim_1 + $iAdd]
For $i = 0 To $iAdd - 1
If String($hDataType) = "Boolean" Then
Switch $vValue[$i]
Case "True", "1"
$aArray[$iDim_1 + $i] = True
Case "False", "0", ""
$aArray[$iDim_1 + $i] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
Else
$aArray[$iDim_1 + $i] = $vValue[$i]
EndIf
Next
Return $iDim_1 + $iAdd - 1
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
Local $iValDim_1, $iValDim_2 = 0, $iColCount
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
Local $aTmp[$iValDim_1][0], $aSplit_2
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iColCount = UBound($aSplit_2)
If $iColCount > $iValDim_2 Then
$iValDim_2 = $iColCount
ReDim $aTmp[$iValDim_1][$iValDim_2]
EndIf
For $j = 0 To $iColCount - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
For $iWriteTo_Index = 0 To $iValDim_1 - 1
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
Else
If String($hDataType) = "Boolean" Then
Switch $vValue[$iWriteTo_Index][$j - $iStart]
Case "True", "1"
$aArray[$iWriteTo_Index + $iDim_1][$j] = True
Case "False", "0", ""
$aArray[$iWriteTo_Index + $iDim_1][$j] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
Else
$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
EndIf
EndIf
Next
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc
Global Const $FO_READ = 0
Global Const $FO_OVERWRITE = 2
Func _ReplaceStringInFile($sFilePath, $sSearchString, $sReplaceString, $iCaseSensitive = 0, $iOccurance = 1)
If StringInStr(FileGetAttrib($sFilePath), "R") Then Return SetError(1, 0, -1)
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
If $hFileOpen = -1 Then Return SetError(2, 0, -1)
Local $sFileRead = FileRead($hFileOpen)
FileClose($hFileOpen)
If $iCaseSensitive = Default Then $iCaseSensitive = 0
If $iOccurance = Default Then $iOccurance = 1
$sFileRead = StringReplace($sFileRead, $sSearchString, $sReplaceString, 1 - $iOccurance, $iCaseSensitive)
Local $iReturn = @extended
If $iReturn Then
Local $iFileEncoding = FileGetEncoding($sFilePath)
$hFileOpen = FileOpen($sFilePath, $iFileEncoding + $FO_OVERWRITE)
If $hFileOpen = -1 Then Return SetError(3, 0, -1)
FileWrite($hFileOpen, $sFileRead)
FileClose($hFileOpen)
EndIf
Return $iReturn
EndFunc
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
Global Const $PROCESS_SET_INFORMATION = 0x00000200
Global Const $PROCESS_QUERY_INFORMATION = 0x00000400
If Not ObjEvent("AutoIt.Error") Then
Global Const $_Zip_COMErrorHandler = ObjEvent("AutoIt.Error", "_Zip_COMErrorFunc")
EndIf
Func _Zip_COMErrorFunc()
EndFunc
Func _Zip_UnzipAll($sZipFile, $sDestPath, $iFlag = 20)
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Or Not _IsFullPath($sDestPath) Then Return SetError(3, 0, 0)
Local $sTempDir = _Zip_TempDirName($sZipFile)
Local $oNS = _Zip_GetNameSpace($sZipFile)
If Not IsObj($oNS) Then Return SetError(4, 0, 0)
$sDestPath = _Zip_PathStripSlash($sDestPath)
If Not FileExists($sDestPath) Then
DirCreate($sDestPath)
If @error Then Return SetError(5, 0, 0)
EndIf
Local $oNS2 = _Zip_GetNameSpace($sDestPath)
If Not IsObj($oNS2) Then Return SetError(6, 0, 0)
$oNS2.CopyHere($oNS.Items(), $iFlag)
DirRemove($sTempDir, 1)
If FileExists($sDestPath & "\" & $oNS.Items().Item($oNS.Items().Count - 1).Name) Then
Return 1
Else
Return SetError(7, 0, 0)
EndIf
EndFunc
Func _IsFullPath($sPath)
If StringInStr($sPath, ":\") Then
Return True
Else
Return False
EndIf
EndFunc
Func _Zip_DllChk()
If Not FileExists(@SystemDir & "\zipfldr.dll") Then Return SetError(1, 0, 0)
If Not RegRead("HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}", "") Then Return SetError(2, 0, 0)
Return 1
EndFunc
Func _Zip_GetNameSpace($sZipFile, $sPath = "")
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Then Return SetError(3, 0, 0)
Local $oApp = ObjCreate("Shell.Application")
Local $oNS = $oApp.NameSpace($sZipFile)
If Not IsObj($oNS) Then Return SetError(4, 0, 0)
If $sPath <> "" Then
Local $aPath = StringSplit($sPath, "\")
Local $oItem
For $i = 1 To $aPath[0]
$oItem = $oNS.ParseName($aPath[$i])
If Not IsObj($oItem) Then Return SetError(5, 0, 0)
$oNS = $oItem.GetFolder
If Not IsObj($oNS) Then Return SetError(6, 0, 0)
Next
EndIf
Return $oNS
EndFunc
Func _Zip_PathNameOnly($sPath)
Return StringRegExpReplace($sPath, ".*\\", "")
EndFunc
Func _Zip_PathStripSlash($sString)
Return StringRegExpReplace($sString, "(^\\+|\\+$)", "")
EndFunc
Func _Zip_TempDirName($sZipFile)
Local $i = 0, $sTemp, $sName = _Zip_PathNameOnly($sZipFile)
Do
$i += 1
$sTemp = @TempDir & "\Temporary Directory " & $i & " for " & $sName
Until Not FileExists($sTemp)
Return $sTemp
EndFunc
Global $Env_RoamingAppData = @AppDataDir, $Env_LocalAppData = @LocalAppDataDir, $Env_ProgramData = @AppDataCommonDir, $Env_UserProfile = @UserProfileDir, $Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"
Global $7z_dir = $Env_ProgramData & "\SalFisher47\7za", $7z = $7z_dir & "\7za.exe"
$Ini = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"
$ini_RunAdmin = IniRead($ini, "launcher", "run_admin", "")
$ini_1stRun = IniRead($ini, "launcher", "1st_run", "")
$_1st_run_ini = "_1st_run.ini"
If Not FileExists(@AppDataCommonDir & "\SalFisher47\UniGame Launcher") Then DirCreate(@AppDataCommonDir & "\SalFisher47\UniGame Launcher")
$Ini_ProgramData = @AppDataCommonDir & "\SalFisher47\UniGame Launcher\" & StringTrimRight(@ScriptName, 4) & ".ini"
FileInstall("ProgramData.ini", $Ini_ProgramData, 0)
If $ini_1stRun == 1 Then
If Not FileExists(@ScriptDir & "\_1st_run.zip") Then
FileInstall("_1st_run.zip", @ScriptDir & "\_1st_run.zip", 0)
FileInstall("ProgramData.ini", $Ini_ProgramData, 1)
EndIf
EndIf
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
$ini_Savegame_dir = IniRead($ini, "savegame", "savegame_dir", "")
$ini_Savegame_subdir = IniRead($ini, "savegame", "savegame_subdir", "")
$Savegame_dir = ""
Switch $ini_Savegame_dir
Case "MyDocs"
$Savegame_dir = @MyDocumentsDir & "\" & $ini_Savegame_subdir
Case "_MyDocs_"
$Savegame_dir = @MyDocumentsDir & "\" & $ini_Savegame_subdir
Case "PublicDocs"
$Savegame_dir = @DocumentsCommonDir & "\" & $ini_Savegame_subdir
Case "_PublicDocs_"
$Savegame_dir = @DocumentsCommonDir & "\" & $ini_Savegame_subdir
Case "RoamingAppData"
$Savegame_dir = $Env_RoamingAppData & "\" & $ini_Savegame_subdir
Case "_RoamingAppData_"
$Savegame_dir = $Env_RoamingAppData & "\" & $ini_Savegame_subdir
Case "LocalAppData"
$Savegame_dir = $Env_LocalAppData & "\" & $ini_Savegame_subdir
Case "_LocalAppData_"
$Savegame_dir = $Env_LocalAppData & "\" & $ini_Savegame_subdir
Case "ProgramData"
$Savegame_dir = $Env_ProgramData & "\" & $ini_Savegame_subdir
Case "_ProgramData_"
$Savegame_dir = $Env_ProgramData & "\" & $ini_Savegame_subdir
Case "SavedGames"
$Savegame_dir = $Env_SavedGames & "\" & $ini_Savegame_subdir
Case "_SavedGames_"
$Savegame_dir = $Env_SavedGames & "\" & $ini_Savegame_subdir
Case "UserProfile"
$Savegame_dir = @UserProfileDir & "\" & $ini_Savegame_subdir
Case "_UserProfile_"
$Savegame_dir = @UserProfileDir & "\" & $ini_Savegame_subdir
Case "GameDir"
$Savegame_dir = @ScriptDir & "\" & $ini_Savegame_subdir
Case "_GameDir_"
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
FileDelete(StringTrimRight(@ScriptFullPath, 3) & "a3x")
Exit
Else
If $run_firewall <> 1 Then
$first_launch = 0
If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
EndIf
_RunMain()
FileDelete(StringTrimRight(@ScriptFullPath, 3) & "a3x")
Exit
Else
$first_launch = 1
If IniRead($Ini_ProgramData, "game", "savegame_path", "") <> $Savegame_dir Then
IniWrite($Ini_ProgramData, "game", "savegame_path", " " & $Savegame_dir)
EndIf
_RunAdmin()
FileDelete(StringTrimRight(@ScriptFullPath, 3) & "a3x")
Exit
EndIf
EndIf
EndIf
Func _1st_run()
_Zip_UnzipAll(@ScriptDir & "\_1st_run.zip", @ScriptDir & "\_1st_run")
Local $ini_1stRun_copy_from[1], $ini_1stRun_copy_to[1], $ini_1stRun_open_file[1], $ini_1stRun_file_cmd[1]
For $i = 1 To 9
_ArrayAdd($ini_1stRun_copy_from, IniRead(@ScriptDir & "\_1st_run\" & $_1st_run_ini, "copy", "copy_from" & $i, ""))
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
_ArrayAdd($ini_1stRun_copy_to, IniRead(@ScriptDir & "\_1st_run\" & $_1st_run_ini, "copy", "copy_to" & $i, ""))
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
_ArrayAdd($ini_1stRun_open_file, IniRead(@ScriptDir & "\_1st_run\" & $_1st_run_ini, "open", "open_file" & $j, ""))
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
_ArrayAdd($ini_1stRun_file_cmd, IniRead(@ScriptDir & "\_1st_run\" & $_1st_run_ini, "open", "file_cmd" & $j, ""))
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
Func _RunMain()
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
If $ini_1stRun == 1 Then _1st_run()
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
Else
If $affinity_mask_bin <> "" Then
ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
$pid = ProcessWait($exe32R_only)
_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
Else
ShellExecute($exe32_only, " " & $exe32_cmd, $exe32_path_only)
EndIf
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
If $ini_1stRun == 1 Then _1st_run()
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
Else
If $affinity_mask_bin <> "" Then
ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
$pid = ProcessWait($exe64R_only)
_WinAPI_SetProcessAffinityMask(_WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION+$PROCESS_SET_INFORMATION, False, $pid), $affinity_mask_hex)
Else
ShellExecute($exe64_only, " " & $exe64_cmd, $exe64_path_only)
EndIf
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
