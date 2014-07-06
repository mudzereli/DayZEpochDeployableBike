/* see github for instructions for more details on how these values work: https://github.com/mudzereli/DayZEpochDeployableBike */
/* [ **CLASS_TO_CLICK** , **TYPE_OF_CLASS_TO_CLICK** , **DEPLOY_DISTANCE** , **DEPLOY_DIRECTION_OFFSET** , **PACK_DISTANCE** , **DAMAGE_LIMIT** , **ALLOW_PACKING_OTHERS** , **CLEAR_CARGO** , **SAVE_TO_DATABASE** , [ **CLASS_TO_DEPLOY** , **CLASS_TO_DEPLOY2** ] ] */
DZE_DEPLOYABLES_CONFIG = [
    // deploy a non-permanent bike from a toolbox right in front of the player that can be re-packed by the owner as long as it's under 10% damage
    ["ItemToolbox","CfgWeapons",2,270,5,0.1,false,false,false,["MMT_Civ"]],
    // deploy fortifications from etool 3 meters in front of player that are permanent until server restart
    ["ItemEtool","CfgWeapons",3,0,5,-1,false,true,false,["Land_fort_rampart","Fort_StoneWall_EP1"]],
    // deploy a permanent helicopter from ruby 5 meters in front of player that can be re-packed by anyone as long as it's under 10% damage
    ["ItemRuby","CfgMagazines",5,270,7,0.1,true,true,true,["AH6X_DZ","UH1Y_DZ"]],
    // deploy some vehicles in front of the player that have an empty inventory (commented out)
    //["ItemCitrine","CfgMagazines",5,270,7,false,false,false,true,["UralCivil","MTVR","LocalBasicWeaponsBox"]],
    // deploy some vehicles in front of the player that have all the default items in their inventory still (commented out)
    //["ItemSapphire","CfgMagazines",5,270,7,false,false,false,false,["UralCivil","MTVR","LocalBasicWeaponsBox"]],
    // deploy military housing in front of the player that is permanent but can't be re-packed by anyone
    ["ItemEmerald","CfgMagazines",10,0,10,-1,false,false,true,["Barrack2","Land_fortified_nest_small_EP1"]],
    // deploy some housing items from parts piles in front of the player that are permanent but can be re-packed by anyone
    ["PartGeneric","CfgMagazines",2,0,5,1,true,true,true,["Desk","FoldChair","FoldTable","SmallTable","Barrel1","Garbage_can"]],
    // deploy some housing items from wood piles in front of the player that are permanent but can be re-packed by anyone
    ["PartWoodPile","CfgMagazines",2,90,5,1,true,true,true,["Land_Rack_EP1","Land_Table_EP1","Land_Shelf_EP1","WoodChair","Park_bench2","Park_bench1"]],
    // deploy concrete barricades from cinderblocks 2m in front of the player, that are permanent and can only be re-packed by the person who placed them
    ["CinderBlocks","CfgMagazines",2,0,5,1,false,true,true,["Land_CncBlock","Land_CncBlock_Stripes"]]
];

DZE_DEPLOYABLE_ADMINS = ["38130182","76561197962680159"];