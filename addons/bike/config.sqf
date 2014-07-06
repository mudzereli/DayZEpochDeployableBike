/* see github for instructions for more details on how these values work: https://github.com/mudzereli/DayZEpochDeployableBike */
/* [ **CLASS_TO_CLICK** , **TYPE_OF_CLASS_TO_CLICK** , **DEPLOY_DISTANCE** , **DEPLOY_DIRECTION_OFFSET** , **PACK_DISTANCE** , **DAMAGE_LIMIT** , **ALLOW_PACKING_OTHERS** , **CLEAR_CARGO** , **SAVE_TO_DATABASE** , [ **CLASS_TO_DEPLOY** , **CLASS_TO_DEPLOY2** ] ] */
DZE_DEPLOYABLES_CONFIG = [
    // deploy bike from toolbox 2 meters in front of player at 270 degree rotation that can be repacked
    ["ItemToolbox","CfgWeapons",2,270,5,0.1,true,false,false,["MMT_Civ"]],
    // deploy fortifications from etool 3 meters in front of player that can be repacked
    ["ItemEtool","CfgWeapons",3,0,5,-1,true,true,false,["Land_fort_rampart","Fort_StoneWall_EP1"]],
    // deploy helicopter from ruby 5 meters in front of player that can't be repacked
    ["ItemRuby","CfgMagazines",5,270,7,0.1,false,true,true,["AH6X_DZ","UH1Y_DZ"]],
    // deploy some stuff in front of the player that does have its cargo cleared
    // ["ItemCitrine","CfgMagazines",5,270,7,false,false,false,true,["UralCivil","MTVR","LocalBasicWeaponsBox"]],
    // deploy some stuff in front of the player that doesnt have its cargo cleared
    // ["ItemSapphire","CfgMagazines",5,270,7,false,false,false,false,["UralCivil","MTVR","LocalBasicWeaponsBox"]],
    // deploy military housing from emerald 10 meters in front of the player that can't be repacked
    ["ItemEmerald","CfgMagazines",10,0,10,-1,false,false,true,["Barrack2","Land_fortified_nest_small_EP1"]],
    // deploy house stuff from generic parts 2m in front of the player, can be repacked by anyone
    ["PartGeneric","CfgMagazines",2,0,5,1,false,false,true,["Desk","FoldChair","FoldTable","SmallTable","Barrel1","Garbage_can"]],
    // deploy house stuff from wood piles 2m in front of the player, can be repacked by anyone
    ["PartWoodPile","CfgMagazines",2,90,5,1,false,false,true,["Land_Rack_EP1","Land_Table_EP1","Land_Shelf_EP1","WoodChair","Park_bench2","Park_bench1"]],
    // deploy concrete stuff from cinderblocks 2m in front of the player, can be repacked by anyone
    ["CinderBlocks","CfgMagazines",2,0,5,1,true,false,true,["Land_CncBlock","Land_CncBlock_Stripes"]]
];

DZE_DEPLOYABLE_ADMINS = ["38130182","76561197962680159"];