#NoTrayIcon
#pragma compile(ExecLevel, AsInvoker)
#pragma compile(Compatibility, vista, win7, win8, win81, win10)
#pragma compile(AutoItExecuteAllowed, True)
#pragma compile(InputBoxRes, True)
#pragma compile(Stripper, True)
#pragma compile(FileVersion, 1.1.5.47)
#pragma compile(ProductVersion, 1.1.5.47)
#pragma compile(ProductName, 'UniGame Launcher Restore')
#pragma compile(FileDescription, 'Restore settings & Repack crack')
#pragma compile(LegalCopyright, '2019-2020, SalFisher47')
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(InternalName, 'UniGame Launcher Restore')
#pragma compile(OriginalFilename, UniGame_Launcher_two_restore.exe)
Global Const $STDOUT_CHILD = 2
Global Const $STDERR_CHILD = 4
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
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
If Not UBound($aArray) Then Return SetError(4, 0, 0)
Local $vTmp, $iUBound = UBound($aArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
$vTmp = $aArray[$i]
$aArray[$i] = $aArray[$iEnd]
$aArray[$iEnd] = $vTmp
$iEnd -= 1
Next
Return 1
EndFunc
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)
If $iDescending = Default Then $iDescending = 0
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iSubItem = Default Then $iSubItem = 0
If $iPivot = Default Then $iPivot = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
Local $iUBound = UBound($aArray) - 1
If $iUBound = -1 Then Return SetError(5, 0, 0)
If $iEnd = Default Then $iEnd = 0
If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
If $iStart < 0 Or $iStart = Default Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iPivot Then
__ArrayDualPivotSort($aArray, $iStart, $iEnd)
Else
__ArrayQuickSort1D($aArray, $iStart, $iEnd)
EndIf
If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
Case 2
If $iPivot Then Return SetError(6, 0, 0)
Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
If $iDescending Then
$iDescending = -1
Else
$iDescending = 1
EndIf
__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
Case Else
Return SetError(4, 0, 0)
EndSwitch
Return 1
EndFunc
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
If $iEnd <= $iStart Then Return
Local $vTmp
If($iEnd - $iStart) < 15 Then
Local $vCur
For $i = $iStart + 1 To $iEnd
$vTmp = $aArray[$i]
If IsNumber($vTmp) Then
For $j = $i - 1 To $iStart Step -1
$vCur = $aArray[$j]
If($vTmp >= $vCur And IsNumber($vCur)) Or(Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
$aArray[$j + 1] = $vCur
Next
Else
For $j = $i - 1 To $iStart Step -1
If(StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
$aArray[$j + 1] = $aArray[$j]
Next
EndIf
$aArray[$j + 1] = $vTmp
Next
Return
EndIf
Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or(Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or(Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
Else
While(StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While(StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
$vTmp = $aArray[$L]
$aArray[$L] = $aArray[$R]
$aArray[$R] = $vTmp
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort1D($aArray, $iStart, $R)
__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
If $iEnd <= $iStart Then Return
Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($iStep *($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or(Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep *($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or(Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
Else
While($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
For $i = 0 To $iSubMax
$vTmp = $aArray[$L][$i]
$aArray[$L][$i] = $aArray[$R][$i]
$aArray[$R][$i] = $vTmp
Next
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
If $iPivot_Left > $iPivot_Right Then Return
Local $iLength = $iPivot_Right - $iPivot_Left + 1
Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
If $iLength < 45 Then
If $bLeftMost Then
$i = $iPivot_Left
While $i < $iPivot_Right
$j = $i
$iAi = $aArray[$i + 1]
While $iAi < $aArray[$j]
$aArray[$j + 1] = $aArray[$j]
$j -= 1
If $j + 1 = $iPivot_Left Then ExitLoop
WEnd
$aArray[$j + 1] = $iAi
$i += 1
WEnd
Else
While 1
If $iPivot_Left >= $iPivot_Right Then Return 1
$iPivot_Left += 1
If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
WEnd
While 1
$k = $iPivot_Left
$iPivot_Left += 1
If $iPivot_Left > $iPivot_Right Then ExitLoop
$iA1 = $aArray[$k]
$iA2 = $aArray[$iPivot_Left]
If $iA1 < $iA2 Then
$iA2 = $iA1
$iA1 = $aArray[$iPivot_Left]
EndIf
$k -= 1
While $iA1 < $aArray[$k]
$aArray[$k + 2] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 2] = $iA1
While $iA2 < $aArray[$k]
$aArray[$k + 1] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 1] = $iA2
$iPivot_Left += 1
WEnd
$iLast = $aArray[$iPivot_Right]
$iPivot_Right -= 1
While $iLast < $aArray[$iPivot_Right]
$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
$iPivot_Right -= 1
WEnd
$aArray[$iPivot_Right + 1] = $iLast
EndIf
Return 1
EndIf
Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
$iE2 = $iE3 - $iSeventh
$iE1 = $iE2 - $iSeventh
$iE4 = $iE3 + $iSeventh
$iE5 = $iE4 + $iSeventh
If $aArray[$iE2] < $aArray[$iE1] Then
$t = $aArray[$iE2]
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
If $aArray[$iE3] < $aArray[$iE2] Then
$t = $aArray[$iE3]
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
If $aArray[$iE4] < $aArray[$iE3] Then
$t = $aArray[$iE4]
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
If $aArray[$iE5] < $aArray[$iE4] Then
$t = $aArray[$iE5]
$aArray[$iE5] = $aArray[$iE4]
$aArray[$iE4] = $t
If $t < $aArray[$iE3] Then
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
EndIf
Local $iLess = $iPivot_Left
Local $iGreater = $iPivot_Right
If(($aArray[$iE1] <> $aArray[$iE2]) And($aArray[$iE2] <> $aArray[$iE3]) And($aArray[$iE3] <> $aArray[$iE4]) And($aArray[$iE4] <> $aArray[$iE5])) Then
Local $iPivot_1 = $aArray[$iE2]
Local $iPivot_2 = $aArray[$iE4]
$aArray[$iE2] = $aArray[$iPivot_Left]
$aArray[$iE4] = $aArray[$iPivot_Right]
Do
$iLess += 1
Until $aArray[$iLess] >= $iPivot_1
Do
$iGreater -= 1
Until $aArray[$iGreater] <= $iPivot_2
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk > $iPivot_2 Then
While $aArray[$iGreater] > $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
$aArray[$iPivot_Left] = $aArray[$iLess - 1]
$aArray[$iLess - 1] = $iPivot_1
$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
$aArray[$iGreater + 1] = $iPivot_2
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
If($iLess < $iE1) And($iE5 < $iGreater) Then
While $aArray[$iLess] = $iPivot_1
$iLess += 1
WEnd
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
WEnd
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk = $iPivot_2 Then
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iPivot_1
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
EndIf
__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
Else
Local $iPivot = $aArray[$iE3]
$k = $iLess
While $k <= $iGreater
If $aArray[$k] = $iPivot Then
$k += 1
ContinueLoop
EndIf
$iAk = $aArray[$k]
If $iAk < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
Else
While $aArray[$iGreater] > $iPivot
$iGreater -= 1
WEnd
If $aArray[$iGreater] < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $iPivot
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
EndIf
EndFunc
Global Const $FLTA_FILESFOLDERS = 0
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""
$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\"
If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
If $bReturnPath Then $sFullPath = $sFilePath
If $sFilter = Default Then $sFilter = "*"
If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
If Not($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
If @error Then Return SetError(4, 0, 0)
While 1
$sFileName = FileFindNextFile($hSearch)
If @error Then ExitLoop
If($iFlag + @extended = 2) Then ContinueLoop
$sFileList &= $sDelimiter & $sFullPath & $sFileName
WEnd
FileClose($hSearch)
If $sFileList = "" Then Return SetError(4, 0, 0)
Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc
$s7Zip = @OSArch = "x64" ? EnvGet("ProgramW6432") & "\7-Zip" : @ProgramFilesDir & "\7-Zip"
$sResH = @ProgramFilesDir & "\Resource Hacker"
$a1 = _FileListToArray(@ScriptDir, "_*.exe", 1, 0)
Local $a2[1]
For $i = 1 To UBound($a1)-1
If FileExists(@ScriptDir & "\" & StringTrimRight($a1[$i], 4) & ".ini") Then
IniReadSection(@ScriptDir & "\" & StringTrimRight($a1[$i], 4) & ".ini", "Launcher")
If Not @error Then
_ArrayAdd($a2, $a1[$i])
Else
Exit
EndIf
Else
Exit
EndIf
Next
For $j = 1 To UBound($a2)-1
If StringInStr(@ScriptName, "UniGame_Launcher_two_restore") Then
$newIni_only = StringTrimRight(@ScriptName, 12) & ".ini"
$newExe_only = StringTrimRight(@ScriptName, 12) & ".exe"
$newIni = @ScriptDir & "\" & $newIni_only
$newExe = @ScriptDir & "\" & $newExe_only
$oldIni_only = StringTrimRight($a2[$j], 4) & ".ini"
$oldExe_only = $a2[$j]
$oldIni = @ScriptDir & "\" & StringTrimRight($a2[$j], 4) & ".ini"
$oldExe = @ScriptDir & "\" & $a2[$j]
IniWrite($newIni, "Exe", "exe32_run", " " & IniRead($oldIni, "exe", "exe32_run", ""))
IniWrite($newIni, "Exe", "exe32_cmd", " " & IniRead($oldIni, "exe", "exe32_cmd", ""))
IniWrite($newIni, "Exe", "exe32_compat", " " & IniRead($oldIni, "exe", "exe32_compat", ""))
IniWrite($newIni, "Exe", "exe64_run", " " & IniRead($oldIni, "exe", "exe64_run", ""))
IniWrite($newIni, "Exe", "exe64_cmd", " " & IniRead($oldIni, "exe", "exe64_cmd", ""))
IniWrite($newIni, "Exe", "exe64_compat", " " & IniRead($oldIni, "exe", "exe64_compat", ""))
IniWrite($newIni, "Exe", "exe32_run_alt", " " & IniRead($oldIni, "exe", "exe32_run_alt", ""))
IniWrite($newIni, "Exe", "exe32_cmd_alt", " " & IniRead($oldIni, "exe", "exe32_cmd_alt", ""))
IniWrite($newIni, "Exe", "exe32_compat_alt", " " & IniRead($oldIni, "exe", "exe32_compat_alt", ""))
IniWrite($newIni, "Exe", "exe64_run_alt", " " & IniRead($oldIni, "exe", "exe64_run_alt", ""))
IniWrite($newIni, "Exe", "exe64_cmd_alt", " " & IniRead($oldIni, "exe", "exe64_cmd_alt", ""))
IniWrite($newIni, "Exe", "exe64_compat_alt", " " & IniRead($oldIni, "exe", "exe64_compat_alt", ""))
IniWrite($newIni, "exe", "run_next", " " & IniRead($oldIni, "exe", "run_next", " 0"))
If IniRead($oldIni, "exe", "run_first", "") == 1 Then
IniWrite($newIni, "process", "affinity_mask", " 1")
EndIf
If IniRead($oldIni, "process", "end_process", "") <> "" Then
IniWrite($newIni, "process", "end_process", " " & IniRead($oldIni, "process", "end_process", ""))
ElseIf IniRead($oldIni, "launcher", "end_process", "") <> "" Then
IniWrite($newIni, "process", "end_process", " " & IniRead($oldIni, "launcher", "end_process", ""))
EndIf
IniWrite($newIni, "process", "exe32_real", " " & IniRead($oldIni, "process", "exe32_real", ""))
IniWrite($newIni, "process", "exe64_real", " " & IniRead($oldIni, "process", "exe64_real", ""))
If IniRead($oldIni, "savegame", "savegame_dir", "") <> "" Then
If StringLeft(IniRead($oldIni, "savegame", "savegame_dir", ""), 1) == "_" Then
IniWrite($newIni, "Savegame", "savegame_dir", " " & IniRead($oldIni, "savegame", "savegame_dir", ""))
IniWrite($newIni, "Savegame", "savegame_subdir", " " & IniRead($oldIni, "savegame", "savegame_subdir", ""))
Else
IniWrite($newIni, "Savegame", "savegame_dir", " _" & IniRead($oldIni, "savegame", "savegame_dir", "") & "_")
IniWrite($newIni, "Savegame", "savegame_subdir", " " & IniRead($oldIni, "savegame", "savegame_subdir", ""))
EndIf
Else
IniWrite($newIni, "Savegame", "savegame_dir", "")
IniWrite($newIni, "Savegame", "savegame_subdir", "")
EndIf
IniWrite($newIni, "firewall", "exe_block_inbound", " " & IniRead($oldIni, "firewall", "exe_block_inbound", ""))
IniWrite($newIni, "firewall", "exe_block_outbound", " " & IniRead($oldIni, "firewall", "exe_block_outbound", ""))
IniWrite($newIni, "firewall", "exe_block_Reset", " " & IniRead($oldIni, "firewall", "exe_block_Reset", " 0"))
IniWrite($newIni, "firewall", "port_open_TCP", " " & IniRead($oldIni, "firewall", "port_open_TCP", ""))
IniWrite($newIni, "firewall", "port_open_UDP", " " & IniRead($oldIni, "firewall", "port_open_UDP", ""))
IniWrite($newIni, "firewall", "port_open_Reset", " " & IniRead($oldIni, "firewall", "port_open_Reset", " 0"))
IniWrite($newIni, "launcher", "run_admin", " " & IniRead($oldIni, "launcher", "run_admin", " 1"))
IniWrite($newIni, "launcher", "1st_run", " " & IniRead($oldIni, "launcher", "1st_run", " 1"))
If FileExists(@ScriptDir & "\_1st_run.zip") Then FileCopy(@ScriptDir & "\_1st_run.zip", @ScriptDir & "\_launcher_restore\_crack_update\_1st_run.zip", 8)
If FileExists($sResH & "\ResourceHacker.exe") Then
If Not FileExists(@ScriptDir & "\_launcher_restore\_icon_update") Then DirCreate(@ScriptDir & "\_launcher_restore\_icon_update")
FileInstall("_FileInstall\rh_scripts\rh_extract.ini", @ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", 1)
IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", "FILENAMES", "Open", '"' & $oldExe & '"')
IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", "FILENAMES", "Save", '')
IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", "FILENAMES", "Log", '')
RunWait($sResH & '\ResourceHacker.exe -script ' & '"' & @ScriptDir & '\_launcher_restore\_icon_update\_rh_extract.ini"')
FileInstall("_FileInstall\rh_scripts\rh_update.ini", @ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", 1)
IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", "FILENAMES", "Open", '"' & $newExe & '"')
IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", "FILENAMES", "Save", '"' & $newExe & '"')
IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", "FILENAMES", "Log", '')
RunWait($sResH & '\ResourceHacker.exe -script ' & '"' & @ScriptDir & '\_launcher_restore\_icon_update\_rh_update.ini"')
_DirRemoveContent(@ScriptDir & "\_launcher_restore\_icon_update")
Else
MsgBox(16, "Error", "Can't update icon for '" & $a2[$j] & "'" & @CRLF & "Resource Hacker is not installed")
EndIf
FileDelete($oldIni)
FileDelete($oldExe)
FileCopy($newIni, $oldIni, 1)
FileCopy($newExe, $oldExe, 1)
EndIf
Next
For $k = 1 To UBound($a2)-1
If FileExists($s7Zip & "\7z.exe") Then
If FileExists(@ScriptDir & "\" & StringTrimRight($a2[$k], 4) & ".7z") Then
$7zOldDir = @ScriptDir & "\_launcher_restore\_crack_update"
$7zList = _7zList(@ScriptDir & "\" & StringTrimRight($a2[$k], 4) & ".7z", 0)
For $i = 1 To $7zList[0]
FileCopy(@ScriptDir & "\" & $7zList[$i], $7zOldDir & "\" & $7zList[$i], 9)
Next
FileDelete(@ScriptDir & "\" & StringTrimRight($a2[$k], 4) & ".7z")
RunWait($s7Zip & '\7z.exe a "..\..\' & StringTrimRight($a2[$k], 4) & '.7z" -r *.*', $7zOldDir, @SW_HIDE)
_DirRemoveContent($7zOldDir)
EndIf
Else
MsgBox(16, "Error", "Can't repack cracked files to '" & StringTrimRight($a2[$k], 4) & ".7z" & "'" & @CRLF & "7-Zip is not installed")
EndIf
Next
FileDelete(@ScriptDir & "\" & StringTrimRight(@ScriptName, 12) & ".ini")
FileDelete(@ScriptDir & "\" & StringTrimRight(@ScriptName, 12) & ".exe")
_DirRemoveContent(@ScriptDir & "\_launcher_restore")
DirRemove(@ScriptDir & "\_launcher_restore")
ShellExecute(@ComSpec, ' /c TimeOut 1 & Del /F "' & @ScriptFullPath & '"', @TempDir, "", @SW_HIDE)
Func _DirRemoveContent($f_dir)
$f_dir_FILES = _FileListToArray($f_dir, "*", 1)
For $i = 1 To UBound($f_dir_FILES)-1
FileDelete($f_dir & "\" & $f_dir_FILES[$i])
Next
$f_dir_FOLDERS = _FileListToArray($f_dir, "*", 2)
For $j = 1 To UBound($f_dir_FOLDERS)-1
DirRemove($f_dir & "\" & $f_dir_FOLDERS[$j], 1)
Next
EndFunc
Func _7zList($_sArchivePath, $iFolderFlag = 0)
Local $sOutput = "", $sError = ""
Local $iProcessId = Run($s7Zip & '\7z.exe l -r "' & $_sArchivePath & '"', "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
While 1
$sOutput &= StdoutRead($iProcessId)
If @error Then ExitLoop
WEnd
While 1
$sError &= StderrRead($iProcessId)
If @error Then ExitLoop
WEnd
If StringStripWS($sError, 8) <> "" Then Exit MsgBox(4096, "7-Zip Error", $sError)
Local $bStart = False, $aOutput = StringSplit($sOutput, @CRLF), $a7ZArchive[1]
For $i = $aOutput[0] To 1 Step - 1
If StringStripWS($aOutput[$i], 8) = "" Then ContinueLoop
If StringInStr($aOutput[$i], "------------------- ----- ------------ ------------  ------------------------") Then
If $bStart = False Then
$bStart = True
ContinueLoop
ElseIf $bStart = True Then
$bStart = False
ContinueLoop
EndIf
EndIf
If $bStart Then
If $iFolderFlag = 0 And StringInStr(StringStripWS(StringMid($aOutput[$i], 21, 5), 7), "D") Then ContinueLoop
_ArrayAdd($a7ZArchive, StringStripWS(StringMid($aOutput[$i], 54, StringLen($aOutput[$i]) - 53), 7))
EndIf
Next
_ArraySort($a7ZArchive)
$a7ZArchive[0] = UBound($a7ZArchive) - 1
Return $a7ZArchive
EndFunc
