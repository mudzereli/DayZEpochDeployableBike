// this baby only runs client side
if(isServer) exitWith {};
// only let this dependency be instantiated once
if(isNil "DZE_CLICK_ACTIONS_BUILD") then {
    diag_log text "CLICK ACTIONS: loading...";
    // our fancy array of registered actions
    DZE_CLICK_ACTIONS = [];
    // overwrite the selectslot function with our hooked version
    player_selectSlot = compile preprocessFileLineNumbers "overwrites\click_actions\ui_selectSlot.sqf";
    // let other addons know we're loaded
    DZE_CLICK_ACTIONS_BUILD = 2;
};