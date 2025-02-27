@echo off
set gamepath=PATHTOFOLDER
cd /D %LOCALAPPDATA%\Plutonium
start /wait /abovenormal bin\plutonium-bootstrapper-win32.exe t5mp "%gamepath%" -lan +set developer 0 +name "PLAYERNAME" +set fs_game "mods/mp_t5cine" 