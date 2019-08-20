### UniGame Launcher v1.4.0

Universal launcher for games, to be placed in game folder. I would say it's best to rename it to something like *_Game Name.exe*, so that it's the first file you see there. It includes two versions:

- *one* - to be used with games that have only 32bit or 64bit executables
- *two* - to be used with games that have both 32bit and 64bit executables

------

**Features:**

- runs as administrator only at first launch, if `run_admin = 1` in *ini* file
- can run game executable with arguments and / or compatibility settings
- can run game executable on the first cpu core, thanks to included [RunFirst.exe](https://www.activeplus.com/products/runfirst) - to be used only on some older games that don't run properly on multi-core cpus
- can run the game through a different executable (e.g. settings launcher) at first launch - if `run_next = 1` in *ini* file, will automatically run the game after the settings launcher / configuration utility is closed
- if specified, can automatically terminate incompatible background processes before starting the game
- if specified, can block executables in firewall, for inbound or outbound connections; when you need to unblock them, use `exe_block_Reset = 1` in *ini* file
- if specified, can open TCP/UDP ports in firewall, for inbound and outbound connections; when you need to close them, use `port_open_Reset = 1` in *ini* file
- if savegame folder is specified, creates a *_savegame.lnk* shortcut to it

------

