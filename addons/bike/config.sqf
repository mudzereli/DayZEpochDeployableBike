/* this is the updated declaration style */
DZE_DEPLOYABLES_CONFIG = [
    /* 
     * format:
     * [ CLASS_TO_CLICK , TYPE_OF_CLASS_TO_CLICK , DEPLOY_DISTANCE, DEPLOY_DIRECTION_OFFSET, [ CLASS_TO_DEPLOY , ... ] ]
     * 
     * hints:
     * - no comma after last entry
     * - class names must be quoted and match dayz's class names
     * - CLASS_TO_CLICK = Class name of item that right click action is attached to
     * - TYPE_OF_CLASS_TO_CLICK = either CfgWeapons or CfgMagazines (tools are weapons, bandages/food etc are magazines)
     * - DEPLOY_DISTANCE = How far in front of the player should the item spawn?
     * - DEPLOY_DIRECTION_OFFSET = The offset in relation to the players direction.
     * - CLASS_TO_DEPLOY = Any number of CfgVehicle Class names that can be deployed from the clicked item
     */
    ["DMR","CfgWeapons",2,80,["M107"]],
    ["ItemToolbox","CfgWeapons",2,0,["MMT_Civ","SUV_TK_CIV_EP1"]],
    ["ItemRuby","CfgMagazines",5,90,["AH6X_DZ","UH1Y_DZ"]],
    ["ItemRuby","CfgMagazines",20,10,["land_a_hospital","Land_Mil_Barracks_i"]],
    ["M107","CfgWeapons",2,0,["DMR"]]
];

