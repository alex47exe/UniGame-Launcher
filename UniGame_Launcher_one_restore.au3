#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon_restore.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_one_restore.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher Restore
#AutoIt3Wrapper_Res_Fileversion=1.1.5.47
#AutoIt3Wrapper_Res_ProductVersion=1.1.5.47
#AutoIt3Wrapper_Res_LegalCopyright=2019-2020, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/tl /sf /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** Pragma Compile ****
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
#pragma compile(OriginalFilename, UniGame_Launcher_one_restore.exe)
#EndRegion ;**** Pragma Compile ****

#include <Array.au3>
#include <File.au3>
#include <AutoItConstants.au3>

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

; used for debugging
; _ArrayDisplay($a2)

For $j = 1 To UBound($a2)-1

If StringInStr(@ScriptName, "UniGame_Launcher_one_restore") Then

	$newIni_only = StringTrimRight(@ScriptName, 12) & ".ini"
	$newExe_only = StringTrimRight(@ScriptName, 12) & ".exe"
	$newIni = @ScriptDir & "\" & $newIni_only
	$newExe = @ScriptDir & "\" & $newExe_only
	$oldIni_only = StringTrimRight($a2[$j], 4) & ".ini"
	$oldExe_only = $a2[$j]
	$oldIni = @ScriptDir & "\" & StringTrimRight($a2[$j], 4) & ".ini"
	$oldExe = @ScriptDir & "\" & $a2[$j]

		IniWrite($newIni, "exe", "exe_run", " " & IniRead($oldIni, "exe", "exe_run", ""))
		IniWrite($newIni, "exe", "exe_cmd", " " & IniRead($oldIni, "exe", "exe_cmd", ""))
		IniWrite($newIni, "exe", "exe_compat", " " & IniRead($oldIni, "exe", "exe_compat", ""))
		IniWrite($newIni, "exe", "exe_run_alt", " " & IniRead($oldIni, "exe", "exe_run_alt", ""))
		IniWrite($newIni, "exe", "exe_cmd_alt", " " & IniRead($oldIni, "exe", "exe_cmd_alt", ""))
		IniWrite($newIni, "exe", "exe_compat_alt", " " & IniRead($oldIni, "exe", "exe_compat_alt", ""))
		IniWrite($newIni, "exe", "run_next", " " & IniRead($oldIni, "exe", "run_next", " 0"))
		If IniRead($oldIni, "exe", "run_first", "") == 1 Then
			IniWrite($newIni, "process", "affinity_mask", " 1")
		EndIf
		If IniRead($oldIni, "process", "end_process", "") <> "" Then
			IniWrite($newIni, "process", "end_process", " " & IniRead($oldIni, "process", "end_process", ""))
		ElseIf IniRead($oldIni, "launcher", "end_process", "") <> "" Then
			IniWrite($newIni, "process", "end_process", " " & IniRead($oldIni, "launcher", "end_process", ""))
		EndIf
		IniWrite($newIni, "process", "exe_real", " " & IniRead($oldIni, "process", "exe_real", ""))
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
		IniWrite($newIni, "launcher", "1st_run", " " & IniRead($oldIni, "launcher", "1st_run", " 0"))

		; If IniRead($oldIni, "launcher", "1st_run", " 0") == 1 Then FileCopy(@ScriptDir & "\_1st_run.zip", @ScriptDir & "\_launcher_restore\_crack_update\_1st_run.zip", 8)
		If FileExists(@ScriptDir & "\_1st_run.zip") Then FileCopy(@ScriptDir & "\_1st_run.zip", @ScriptDir & "\_launcher_restore\_crack_update\_1st_run.zip", 8)

		If FileExists($sResH & "\ResourceHacker.exe") Then

			If Not FileExists(@ScriptDir & "\_launcher_restore\_icon_update") Then DirCreate(@ScriptDir & "\_launcher_restore\_icon_update")

			FileInstall("_FileInstall\rh_scripts\rh_extract.ini", @ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", 1)
			IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", "FILENAMES", "Open", '"' & $oldExe & '"')
			IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", "FILENAMES", "Save", '')
			IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini", "FILENAMES", "Log", '')
			RunWait($sResH & '\ResourceHacker.exe -script ' & '"' & @ScriptDir & '\_launcher_restore\_icon_update\_rh_extract.ini"')
			;FileDelete(@ScriptDir & "\_launcher_restore\_icon_update\_rh_extract.ini")

			FileInstall("_FileInstall\rh_scripts\rh_update.ini", @ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", 1)
			IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", "FILENAMES", "Open", '"' & $newExe & '"')
			IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", "FILENAMES", "Save", '"' & $newExe & '"')
			IniWrite(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini", "FILENAMES", "Log", '')
			RunWait($sResH & '\ResourceHacker.exe -script ' & '"' & @ScriptDir & '\_launcher_restore\_icon_update\_rh_update.ini"')
			;FileDelete(@ScriptDir & "\_launcher_restore\_icon_update\_rh_update.ini")

			_DirRemoveContent(@ScriptDir & "\_launcher_restore\_icon_update")

		Else
			; Resource Hacker is not installed
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
			;FileMove(@ScriptDir & "\" & StringTrimRight($a2[$k], 4) & ".7z", @ScriptDir & "\_launcher_restore\" & StringTrimRight($a2[$k], 4) & ".7z" & "_backup.7z", 1)
			FileDelete(@ScriptDir & "\" & StringTrimRight($a2[$k], 4) & ".7z")
			RunWait($s7Zip & '\7z.exe a "..\..\' & StringTrimRight($a2[$k], 4) & '.7z" -r *.*', $7zOldDir, @SW_HIDE)

			_DirRemoveContent($7zOldDir)
		EndIf
	Else
		; 7-Zip is not installed
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

Func _7zList($_sArchivePath, $iFolderFlag = 0) ; 0 = Don't include folders, 1 = Include folders
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
        If StringInStr($aOutput[$i],  "------------------- ----- ------------ ------------  ------------------------") Then
            If $bStart = False Then
                $bStart = True
                ContinueLoop
            ElseIf $bStart = True Then
                $bStart = False
                ContinueLoop
            EndIf
        EndIf
        If $bStart Then
            If  $iFolderFlag = 0 And StringInStr(StringStripWS(StringMid($aOutput[$i], 21, 5), 7), "D") Then ContinueLoop
            _ArrayAdd($a7ZArchive, StringStripWS(StringMid($aOutput[$i], 54, StringLen($aOutput[$i]) - 53), 7))
        EndIf
    Next
    _ArraySort($a7ZArchive)
    $a7ZArchive[0] = UBound($a7ZArchive) - 1
    Return $a7ZArchive
EndFunc ; https://www.autoitscript.com/forum/topic/193612-solved-get-list-file-from-7z-output-list/