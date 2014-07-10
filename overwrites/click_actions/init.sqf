if(isServer) exitWith {};

// don't initialize more than once
if(isNil "DZE_CLICK_ACTIONS_BUILD") then {
    diag_log text "CLICK ACTIONS: loading...";
    call compile preprocessFileLineNumbers "overwrites\click_actions\config.sqf";
    player_selectSlot = compile preprocessFileLineNumbers "overwrites\click_actions\ui_selectSlot.sqf";
    DZE_CLICK_ACTIONS_BUILD = 3;
};