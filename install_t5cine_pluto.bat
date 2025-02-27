@echo off
md "%localappdata%\Plutonium\storage\t5\mods"
xcopy /s "%cd%\mp_t5cine" "%localappdata%\Plutonium\storage\t5\mods\mp_t5cine\"
echo T5Cine (Pluto) installed successfully.
pause