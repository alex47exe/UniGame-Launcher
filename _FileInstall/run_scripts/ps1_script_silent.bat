@echo off

set batFileName=%~n0
set batFolderPath=%~dp0

Powershell.exe -ExecutionPolicy ByPass -WindowStyle Hidden -File %batFileName%.ps1