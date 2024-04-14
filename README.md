# Constructor

Constructor is a Lua Script for Stand that allows for creating fun vehicles, maps and player skins by combining existing GTA assets. 

## Easy Install

Install from the Stand Lua Script Respository at `Stand > Lua Scripts > Repository > Constructor`. Check the box to install the script.

## How to run Constructor

Within the Stand menu, goto `Stand>Lua Scripts>Constructor>Start Script`

## How to load Constructs

Goto `Stand>Lua Scripts>Constructor>Load Constructs`. This will browse the content of your `Stand/Constructs` folder, as well as your Stand Garage (`Stand/Vehicles`)

Constructor can load many kinds of construct files including JSON, XML, INI, and TXT. Put any files you want to make loadable into `Stand/Constructs`. You may organize with sub-folders as desired.

## How to find more Construct files

Constructor comes with a curated collection of constructs to get started with. You can attempt to auto-install these by going to `Constructor>Load Constructs>Options>Auto-Install Curated Constructs`. If that fails you can manually download and install the [curated collection](https://github.com/hexarobi/stand-curated-constructs).

You can find additional compatible files lots of places:
* Discord - Stand's official discord, as well the Constructor discord (Hexa's Scripts)
* Web - Menyoo XML files are most popular on GTA5-Mods.com
* Other Menus - INI files from PhantomX and 2take1 can be loaded, if you have a source for those files

## How to build your own Constructs

Start by creating a root object. This can be a vehicle, an object, NPC, or player skin. For a vehicle you can choose from your current vehicle, from a list, or entering the model name directly. For a map you can start with a construction cone, or search for any object. For a ped you can start with your current player model, or select from a list, or enter a ped model name.

Once you have created a root construct, you can edit its various options such as position, visibility or collision. Vehicles can modify LS Customs options, as well as things like speed mods. Peds you can change clothes or weapons, or give animations.

Most importantly, you can attach other objects, vehicles, peds to your root object. And then the attach more to them. You can browse some curated attachments, but the full object list is also searchable. You can also browse GTA object online at [PlebMasters](https://forge.plebmasters.de/)

Building a construct is like building with lego bricks. Let your imagination run wild! And don't forget to save and share your creations with others. =)

# Troubleshooting

## Why can’t other players see my construct?

Since constructs only use assets available in the game, they ARE generally visible to other players. Stand blocks World Object Sync for all users by default, so if your friends use Stand make sure they relax that protection.

If your construct is very large it may not network to everyone properly. The exact limits aren’t clear, but usually up to about 50 or so objects, vehicles and peds should be ok. Larger constructs may sync better if you clear the map first (Constuctor>Settings>CleanUp)
