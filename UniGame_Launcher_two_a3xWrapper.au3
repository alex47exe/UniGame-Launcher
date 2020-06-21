#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher_two.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.5.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.5.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2017-2020, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Au3Stripper=n
#Au3Stripper_Parameters=/tl /sf /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** Pragma Compile ****
#pragma compile(Console, False)
#pragma compile(x64, False)
#pragma compile(ExecLevel, AsInvoker)
#pragma compile(Compatibility, Win10)
#pragma compile(AutoItExecuteAllowed, True)
#pragma compile(InputBoxRes, True)
#pragma compile(Stripper, False)
#pragma compile(FileVersion, 1.5.0.47)
#pragma compile(ProductVersion, 1.5.0.47)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2017-2020, SalFisher47')
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(OriginalFilename, UniGame_Launcher_two.exe)
#EndRegion ;**** Pragma Compile ****

FileInstall("UniGame_Launcher_one.a3x", StringTrimRight(@ScriptFullPath, 3) & "a3x", 1)
ShellExecute(@ScriptName, ' /AutoIt3ExecuteScript ' & '"' & StringTrimRight(@ScriptFullPath, 3) & "a3x" & '"', @ScriptDir)




