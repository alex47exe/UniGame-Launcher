### UniGame Launcher v1.5.1

Universal launcher for games, to be placed in game folder. I would say it's best to rename it to something like *_Game Name.exe*, so that it's the first file you see there. It includes two versions:

- *one* - to be used with games that have only 32bit or 64bit executables
- *two* - to be used with games that have both 32bit and 64bit executables

------

**What UniGame_Launcher_restore.exe can do...**

- can replace old version of the old, already configured launcher, reusing its *ini* settings and icon for the new launcher (requires *Resource Hacker*); if a *_Game Name.exe.7z* is found, will automatically repack the cracked files and the updated launcher (requires *7-Zip*). To do this, simply copy *UniGame_Launcher.exe*, *ini* and *UniGame_Launcher_restore.exe* in the folder containing the old version of the launcher, already configured for your game, then run *UniGame_Launcher_restore.exe* - take note that it only works properly if the existing launcher name starts with undescore ( _ ), as recommended in the description, otherwise it will simply self delete

**What UniGame_Launcher.exe can do...**

- can run as administrator only at first launch, if `run_admin = 1` in *ini* file, which should have the same name as the launcher
- can unpack files from *_1st_run.zip* to various locations at first launch, if  `1st_run = 1` in *ini* file - useful to automatically copy certain files to game / savegame or configuration folders at first launch; *_1st_run.lnk* pointing to a savegame folder backup will be created first in savegame folder, if it's not empty (only with `_SaveDir_` - the other variables will just overwrite the contents of the folder, which may already exist and be different from savegame folder)
- can run *bat*, *ps1*, *au3* or *exe* files with arguments, open various other supported files from *_1st_run.zip*, and / or merge *reg* files from *_1st_run.zip* - take note that for *bat*, *ps1*, *reg* and *au3* files it's recommended to replace the full paths with the *launcher friendly variables*, ensuring the scripts will work on every PC
- can automatically terminate incompatible background processes before starting the game
- can create a *_savegame.lnk* shortcut pointing to savegame folder, if specified in *ini* file
- can run the game through a different executable (e.g. settings launcher) at first launch - if `run_next = 1` in *ini* file, will automatically run the game after the settings launcher / configuration utility is closed
- can run game executable with arguments and / or compatibility settings, if they are specified in *ini* file
- can run game executable on specified CPU cores - useful to run some older games that don't run properly on multi-core CPUs, or to simulate a less powerful CPU (refer to the *ini* file on how to set `affinity_mask`)
- can block executables in firewall, for inbound or outbound connections; if you need to unblock them, use `exe_block_Reset = 1` in *ini* file
- can open TCP/UDP ports in firewall, for inbound and outbound connections; if you need to close them, use `port_open_Reset = 1` in *ini* file

------

