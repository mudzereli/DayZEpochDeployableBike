/* this is the updated declaration style */
DZE_DEPLOYABLES = [
    /* 
     * format:
     * [[ CLASS_TO_SPAWN ,[ MATCHING_CLASSES_FOR_PACKING ]],[ CLASS_TO_CLICK, TYPE_OF_ITEM_TO_CLICK ]],
     * 
     * hints:
     * - no comma after last entry
     * - class names must be quoted and match dayz's class names
     * - TYPE_OF_ITEM_TO_CLICK can be CfgWeapons or CfgMagazines (tools are weapons, bandages/food etc are magazines)
     *
     * sample records:
     * - 1st record would deploy a bike from a toolbox, 2nd record would deploy a suv from a bandage
     * [["MMT_Civ",["Old_bike_TK_INS_EP1","Old_bike_TK_CIV_EP1","MMT_Civ"]],["ItemToolbox","CfgWeapons"]],
     * [["SUV_TK_CIV_EP1",["SUV_TK_CIV_EP1"]],["ItemBandage","CfgMagazines"]]
     */
    [["MMT_Civ",["Old_bike_TK_INS_EP1","Old_bike_TK_CIV_EP1","MMT_Civ"]],["ItemRuby","CfgMagazines"]],
    [["SUV_TK_CIV_EP1",["SUV_TK_CIV_EP1"]],["ItemRuby","CfgMagazines"]],
    [["land_a_hospital",["land_a_hospital"]],["ItemRuby","CfgMagazines"]],
    [["Land_Mil_Barracks_i",["Land_Mil_Barracks_i"]],["ItemRuby","CfgMagazines"]]
];