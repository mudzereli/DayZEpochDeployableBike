##CONTENTS

###DEPLOYABLE BIKE 2.0.0

#####credits: original concept/code by player2/overhaul by mudzereli

This adds a deploy bike option when right clicking a toolbox. Can also be used to deploy just about anything (see config section below). Requires CLICK ACTIONS (below).

###CLICK ACTIONS 1.0.5.1

#####credits: mudzereli

This is used to register right click actions on items. Required by other addons. Is an overwrite so may not be compatible with mods other than Epoch 1.0.5.1. Conflicts with anything else that overwrites ui_selectSlot.sqf (most likely any addon that adds right-click options).

-----

##Installation
 1. extract the **addons** and **overwrites** folder from the downloaded zip file into your mission file root
 2. add these lines to the end of your mission file init.sqf.
   * ```call compile preprocessFileLineNumbers "overwrites\click_actions\init.sqf";```
   * ```call compile preprocessFileLineNumbers "addons\bike\init.sqf";```
 3. optionally edit "addons\bike\config.sqf" to change some options.

-----

##Change Log
* 1.1.0 - configuration options / code optimization
* 1.0.0 - release

-----

##Planned
* save damage when packed/deployed

-----

##Configuration
This addon is highly configurable, you can deploy just about anything, not just bikes. Browse to addons\bike\config.sqf and edit the array.


###Format:
[ **CLASS_TO_CLICK** , **TYPE_OF_CLASS_TO_CLICK** , **DEPLOY_DISTANCE** , **DEPLOY_DIRECTION_OFFSET** , **PACK_DISTANCE** , **ALLOW_PACKING** , **ALLOW_PACKING_OTHERS** , **ALLOW_PACKING_WORLD** , [ **CLASS_TO_DEPLOY** , **CLASS_TO_DEPLOY2** ] ]

###Hints:
- no comma after last entry
- class names must be quoted and match dayz's class names

###Definitions:
- CLASS_TO_CLICK             Class name of item that right click action is attached to (i.e. ItemToolbox)
- TYPE_OF_CLASS_TO_CLICK     Either CfgWeapons or CfgMagazines (tools are weapons, bandages/food etc are magazines)
- DEPLOY_DISTANCE            How far in front of the player should the item spawn? (usually 2-20 should be good)
- DEPLOY_DIRECTION_OFFSET    The offset in relation to the players direction. (0-360 -- degrees to turn the object)
- PACK_DISTANCE              How close does the player have to be to pack the item? (usually 5-10 is good here)
- ALLOW_PACKING              If this is false, item can not be repacked no matter what. It is permanent until server restart. (true/false)
- ALLOW_PACKING_OTHERS       Should players be able to pack items other players placed? (true/false)
- ALLOW_PACKING_WORLD        Should players be able to pack items not placed by them or other players? (true/false -- usually false)
- CLASS_TO_DEPLOY            Any number of CfgVehicle Class names that can be deployed from the clicked item (i.e. MMT_Civ)

###Sample Config:
```
/* this is the updated declaration style */
DZE_DEPLOYABLES_CONFIG = [
    ["ItemToolbox","CfgWeapons",2,270,5,true,true,true,["MMT_Civ"]],
    ["ItemEtool","CfgWeapons",3,0,5,true,true,false,["Land_fort_rampart","Fort_StoneWall_EP1"]],
    ["ItemRuby","CfgMagazines",5,270,7,true,false,false,["AH6X_DZ","UH1Y_DZ"]],
    ["ItemEmerald","CfgMagazines",17,0,10,false,false,false,["Land_a_stationhouse","Land_Mil_Barracks","Land_Mil_Barracks_i"]],
    ["PartGeneric","CfgMagazines",2,0,5,true,true,false,["Desk","FoldChair","FoldTable","SmallTable","Barrel1","Garbage_can"]],
    ["PartWoodPile","CfgMagazines",2,90,5,true,true,false,["Land_Rack_EP1","Land_Table_EP1","Land_Shelf_EP1","LocalBasicWeaponsBox","WoodChair","Park_bench2","Park_bench1"]],
    ["CinderBlocks","CfgMagazines",2,0,5,true,true,false,["Land_CncBlock","Land_CncBlock_Stripes"]]
];
```

