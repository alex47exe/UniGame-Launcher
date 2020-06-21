Write-host -ForegroundColor Yellow " _1st_run.ini _example configuration (c) 2020, SalFisher47 "
Write-Host "   "
Write-Host " [copy]"
Write-Host "   "
Write-Host " copy_from1 = _example\save_dir"
Write-Host " copy_to1 = MyDocs(w/o starting & trailing '_' here)\My Games\_example_dir"
Write-Host -ForegroundColor Cyan " --- copied contents of '_GameDir_\_1st_run\_example\save_dir' to ..."
Write-Host -ForegroundColor Cyan " '_MyDocs_\My Games\_example_dir'" 
Write-Host "   "
Write-Host " copy_from2 = _example\game_dir"
Write-Host " copy_to2 = GameDir(w/o starting & trailing '_' here)\_example_dir"
Write-Host -ForegroundColor Cyan " --- copied contents of '_GameDir_\_1st_run\_example\game_dir' to ..."
Write-Host -ForegroundColor Cyan " '_GameDir_\_example_dir'"
Write-Host "   "
Write-Host " [open]"
Write-Host "   "
Write-Host " open_file1 = _example\reg\_merge.reg"
Write-Host -ForegroundColor Cyan " --- replaced 'GameDir' (w/o starting & trailing '_' here) ..."
Write-Host -ForegroundColor Cyan " with '_GameDir_', then silently merged ..."
Write-Host -ForegroundColor Cyan " '_GameDir_\_1st_run\_example\reg\_merge.reg' into registry"
Write-Host "   "
Write-Host " open_file2 = _example\ps1\_run.ps1"
Write-Host -ForegroundColor Cyan " --- replaced 'MyDocs' & 'GameDir' (w/o starting & trailing '_' here) ..."
Write-Host -ForegroundColor Cyan " with '_MyDocs_' & '_GameDir_', then ran ..."
Write-Host -ForegroundColor Cyan " '_GameDir_\_1st_run\_example\ps1\_run.ps1', which generated this window"
Write-Host "   "
Write-host -ForegroundColor Yellow " Press Y to open the '_example_dir' folders or N to delete them."
$ReadHost = Read-Host " Y / N (default) " 
Switch ($ReadHost) 
 { 
   Y {explorer.exe "_MyDocs_\My Games\_example_dir"
      explorer.exe "_GameDir_\_example_dir"
      Write-Host "   "
      Write-host -ForegroundColor Yellow " Press Y to delete the '_example_dir' folders or N to close this window."
      $ReadHost = Read-Host " Y (default) / N " 
      Switch ($ReadHost) 
       { 
        Y {Remove-Item "_MyDocs_\My Games\_example_dir" -Recurse
           Remove-Item "_GameDir_\_example_dir" -Recurse} 
        N {}  
        Default {Write-Host "   "
                 Write-host "No valid answer specified . . ."
                 Remove-Item "_MyDocs_\My Games\_example_dir" -Recurse
                 Remove-Item "_GameDir_\_example_dir" -Recurse} 
        }
       } 
   N {Remove-Item "_MyDocs_\My Games\_example_dir" -Recurse
      Remove-Item "_GameDir_\_example_dir" -Recurse}  
   Default {Write-Host "   "
            Write-host "No valid answer specified . . ."
            Remove-Item "_MyDocs_\My Games\_example_dir" -Recurse
            Remove-Item "_GameDir_\_example_dir" -Recurse} 
 }
 