# Constructor

A Lua Script for the Stand mod menu for GTA5

Allows for creation of custom vehicles and maps using the in-game props and vehicles, and sharing your creations, and loading others creations.

## Easy Install

1. Download and install [ScriptManager](https://github.com/hexarobi/stand-lua-scriptmanager/raw/main/ScriptManagerInstaller.exe)
2. In game, goto `Stand > Lua Scripts > ScriptManager > Install Scripts > Constructor > Install`

## Manual install

#### Script

Constructor will auto-update itself, so the main script file is all that is needed to install.

1. Download [the script file](https://github.com/hexarobi/stand-lua-constructor/raw/main/Constructor.lua)
2. Copy into your `Stand/Lua Scripts` folder as `Constructor.lua`

#### Full Project

If the above methods fail, you can manually install the entire project using this method.

1. Download [the projects zip archive file](https://github.com/hexarobi/stand-lua-constructor/archive/refs/heads/main.zip).
2. Extract the contents of `stand-lua-constructor-main` into your `Stand/Lua Scripts` folder
2. Run by going to `Stand > Lua Scripts > Constructor`.

## Loading Constructs

1. Select `Load Constructs` from the main menu.
2. If your `Stand/Constructs` folder is empty, then and you will be prompted to download and install a [curated collection of construct files](https://github.com/hexarobi/stand-curated-constructs), including popular vehicles, maps, and player skins. These can also be installed or updated at any time from the `Load Constructs > Options` menu.
3. Browse the curated collection and select a construct to spawn it into the game world and add it to your `Loaded Constructs` menu for editing.
4. Any additional construct files (vehicles, maps, or player skins in either `json`, `xml` or `ini` format) can be saved into your `Stand/Constructs` folder. You can organize this folder, and optional sub-folders, however you wish.

## Creating New Constructs

1. Select `Create New Construct` from the main menu.
2. To create using your current vehicle as the base select `From Current Vehicle`. This will add it to your `Loaded Constructs` menu for editing.
3. Select `Add Attachment > Search` and enter in a search term such as "tree"
4. Browse search results and select a tree to attach to your vehicle
5. Use the `Position` menu to move the tree attachment into an appropriate position
6. Use `Add Attachment` to attach another attachment to the tree attachment, maybe one the curated objects, or try searching "art"
7. Try using `Add Attachment` to attach another vehicle to the base vehicle
8. Continue explopring, building, and having fun
9. Save your construct and share it with others on Dicord! =)


## Updating

The script will check for updates the first time it is run each day. If updates are found they will be auto-downloaded from https://github.com/hexarobi/stand-lua-constructor and auto-installed. You can manually check for updates any time within the Script Meta menu.
