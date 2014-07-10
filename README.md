###DEPLOYABLE BIKE 2.4.1

#####credits: original concept/code by player2/overhaul by mudzereli

**version 2.4.0 adds multi-part deployables!**

This adds a deploy bike option when right clicking a toolbox. 

Out of the box, it adds a deployable bike with a right click action on a toolbox and a couple other neat deployables.

Really, it can be used to deploy just about anything.

See the **configuration** section below.

For some samples of what it can do, check out this gallery on imgur:

http://imgur.com/a/jH8Lw

-----

##Installation
 1. extract the **addons** and **overwrites** folder from the downloaded zip file into your mission file root
 2. add these lines to the end of your mission file init.sqf.
   * ```call compile preprocessFileLineNumbers "addons\bike\init.sqf";```
 3. edit "addons\bike\config.sqf" to change some options or add different deployables

-----

**warning**: if you are updating this addon from an old version and you have this line in your mission file init.sqf:
```call compile preprocessFileLineNumbers "overwrites\click_actions\init.sqf";```
then **REMOVE** it!

-----

##Change Log
* 2.4.1 - fix deployed saved vehicles spawning in locked
* 2.4.0 - multi-part deployables. yay!
* 2.3.1 - big fix on packing temp objects
* 2.3.0
  - optional saving to database with post-restart memory of deployed items (see warning below about this)
  - configurable damage limits on re-packing, 
  - admin list for packing/deploying instantly & being able to remove all deployables
* 2.2.1 - positioning fix for deployed items
* 2.2.0 - option for clearing cargo of spawned items
* 2.1.0 - change way dependency call is made, only one line needed in init.sqf now for setup
* 2.0.0 - major update, allow multiple deployables, pretty much any class
* 1.1.0 - configuration options / code optimization
* 1.0.0 - release

###Warning:
- due to the way the way arma handles numbers and the way addon is coded, using the save-to-database option may not allow you to re-pack some objects if you have Character ID's over 500,000 (which I don't think will be an issue for 99.99% of people). 

-----

##Planned
* better building placement system (try to use epoch building)

-----

##Configuration
This addon is highly configurable, you can deploy just about anything, not just bikes. Browse to addons\bike\config.sqf and edit the array.

###Config Format:
[**CLASS_TO_CLICK**, **TYPE_OF_CLASS_TO_CLICK**, **DEPLOY_DISTANCE**, **DEPLOY_DIRECTION_OFFSET**, **PACK_DISTANCE**, **DAMAGE_LIMIT**, **ALLOW_PACKING_OTHERS**, **CLEAR_CARGO**, **SAVE_TO_DATABASE**, [**CLASS_TO_DEPLOY**, ...], [**REQUIRED_PART_1**, ...]]

###Hints:
- no comma after last entry in array
- class names must be quoted and match dayz's class names

###Definitions:
- **CLASS_TO_CLICK**             Class name of item that right click action is attached to (i.e. ItemToolbox)
- **TYPE_OF_CLASS_TO_CLICK**     Either CfgWeapons or CfgMagazines (tools are weapons, bandages/food etc are magazines)
- **DEPLOY_DISTANCE**            How far in front of the player should the item spawn? (usually 2-20 should be good)
- **DEPLOY_DIRECTION_OFFSET**    The offset in relation to the players direction. (0-360 -- degrees to turn the object)
- **PACK_DISTANCE**              How close does the player have to be to pack the item? (usually 5-10 is good here)
- **PACK_DAMAGE_LIMIT**          If the damage is higher then this, then the item can't be packed again. (if you always want to be able to pack the item, set 1 here, set -1 to disable packing)
- **ALLOW_PACKING_OTHERS**       Should players be able to pack items other players placed? (true/false)
- **CLEAR_CARGO**                Clear the cargo of the spawned vehicle? (true/false -- usually true)
- **SAVE_TO_DATABASE**           If this is true then the spawned item will be saved permanently to the database (true/false)
- **CLASS_TO_DEPLOY**            Array of CfgVehicle Class names that can be deployed from the clicked item (i.e. MMT_Civ)
- **REQUIRED_PARTS**             Array of parts that are required to build the deployable. these parts are removed from the player's inventory upon creation.


###Sample Config:
```
/* default/sample configuration */
DZE_DEPLOYABLES_CONFIG = [
    // deploy a non-permanent bike from a toolbox right in front of the player that can be re-packed by the owner as long as it's under 10% damage
    ["ItemToolbox","CfgWeapons",2,270,5,0.1,false,false,false,["MMT_Civ"],["ItemToolbox"]],
    // deploy fortifications from etool 3 meters in front of player that are permanent until server restart
    ["ItemEtool","CfgWeapons",3,0,5,-1,false,true,false,["Land_fort_rampart","Fort_StoneWall_EP1"],["ItemEtool"]],
    // deploy a permanent helicopter from ruby 5 meters in front of player that can be re-packed by anyone as long as it's under 10% damage
    ["ItemRuby","CfgMagazines",5,270,7,0.1,true,true,true,["AH6X_DZ","UH1Y_DZ"],["ItemRuby"]],
    // deploy some vehicles in front of the player that have an empty inventory (commented out)
    //["ItemCitrine","CfgMagazines",5,270,7,false,false,false,true,["UralCivil","MTVR","LocalBasicWeaponsBox"]],
    // deploy some vehicles in front of the player that have all the default items in their inventory still (commented out)
    //["ItemSapphire","CfgMagazines",5,270,7,false,false,false,false,["UralCivil","MTVR","LocalBasicWeaponsBox"]],
    // deploy military housing in front of the player that is permanent but can't be re-packed by anyone
    ["ItemEmerald","CfgMagazines",10,0,10,-1,false,false,true,["Barrack2","Land_fortified_nest_small_EP1"],["ItemEmerald"]],
    // deploy some housing items from parts piles in front of the player that are permanent but can be re-packed by anyone
    ["PartGeneric","CfgMagazines",2,0,5,1,true,true,true,["Desk","FoldChair","FoldTable","SmallTable","Barrel1","Garbage_can"],["PartGeneric"]],
    // deploy some housing items from wood piles in front of the player that are permanent but can be re-packed by anyone
    ["PartWoodPile","CfgMagazines",2,90,5,1,true,true,true,["Land_Rack_EP1","Land_Table_EP1","Land_Shelf_EP1","WoodChair","Park_bench2","Park_bench1"],["PartWoodPile"]],
    // deploy concrete barricades from cinderblocks 2m in front of the player, that are permanent and can only be re-packed by the person who placed them
    ["CinderBlocks","CfgMagazines",2,0,5,1,false,true,true,["Land_CncBlock","Land_CncBlock_Stripes"],["CinderBlocks","CinderBlocks"]],
    // deploy a mozzie in front of the player from a rotor/engine/fueltank
    ["ItemToolbox","CfgWeapons",5,270,7,0.1,true,true,true,["CSJ_GyroC"],["PartVRotor","PartEngine","PartFueltank"]]
];
```

