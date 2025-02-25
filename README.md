<div align="center"> 
    
[![T5Cine](https://raw.githubusercontent.com/dtpln/codcine/main/assets/img/t5cine_new.png 'T5Cine')](https://github.com/dtpln/t5cine)
### A features-rich cinematic mod for Call of Duty: Black Ops

<a href="https://github.com/dtpln/t5cine/releases"><img src="https://img.shields.io/github/v/release/dtpln/t5cine?label=Latest%20release&style=flat-square&color=46baba"></a>　
<a href="https://discord.gg/wgRJDJJ"><img src="https://img.shields.io/discord/617736623412740146?label=Join%20the%20IW4Cine%20Discord!&style=flat-square&color=46baba"></a>　
<a href="https://github.com/dtpln/t5cine/releases/latest"><img src="https://img.shields.io/github/downloads/dtpln/t5cine/total?color=46baba&label=Downloads&style=flat-square"></a>
</div>
<br/><br/>

This is a port of [Sass' Cinematic Mod](https://github.com/sortileges/iw4cine) for **Call of Duty: Black Ops**, designed for video editors to create cinematics shots in-game.

This mod creates new dvars combined as player commands. They are all associated to script functions that are triggered when the dvar doesn't equal it's default value, meaning these functions will all independently stay idle until they get notified to go ahead.

This mod was also designed as a Multiplayer mod only. It will not work in Singleplayer or Zombies.

<br/><br/>
## Requirements

In order to use the latest version of this mod directly from the repo, you'll need a copy of **Call of Duty®: Black Ops** with or without the **[Plutonium](https://plutonium.pw)** client installed. This mod was written on the Steam version of World at War.

<br/><br/>
## Installation

Simply download the mod through [this link](https://github.com/dtpln/t5cine/releases/latest). Scroll down and click on "Source code (zip)" to download the archive.

Once the mod is downloaded, open the ZIP file and drag the "mp_t5cine" folder into your `Call of Duty Black Ops/mods` folder.

<br/>

```
X:/
└── .../
    └── Call of Duty Black Ops/
        └── mods/
            └── mp_t5cine/
```
- Plutonium full path: `%localappdata%\Plutonium\storage\t5`
- Steam full path: `Steam/Call of Duty Black Ops`

Then, open your game, and click on the "Mods" tab; "mp_t5cine" should appear in the list. Click on it once and then click on "Launch" to restart your game with the mod on.

You can also create a shortcut of your client's executable and add the following parameter to the target line : `+set fs_game "mods/mp_t5cine"`. This will automatically launch the mod when you open the game.

Alternatively, you can edit the included `.bat` file to run the game with the mod loaded automatically for Plutonium.

<br/><br/>
## How to use

The link below contains a HTML file that explains every command from the [latest release](https://github.com/sortileges/iw4cine/releases/latest) in details. The HTML file will open a new browser tab when you click on it. 
- **[sortileges.github.io/iw4cine/help](https://sortileges.github.io/iw4cine/help)**.

**It is not up-to-date with what's in the master branch,** although everything should still work as intended. Just don't be surprised if something is missing or not working as expected!

Once [Sass](https://github.com/sortileges) finishes the mod's rewrite, the HTML file will be updated accordingly.


<br/><br/>
## Features
**PLANNED FEATURES**

    - [ ]    Better holdgun system
    - [ ]    Better bot model system
    - [ ]    Allow the score to be edited.


<br/><br/>
## Credits
- **Sass** - Created the original IW4Cine mod. All the code was written by him, I just edited it to work on this game.
- **Antiga** - Helped rewrite the mod and fix things that I couldn't.
- **JaZn** - Beta tester. 