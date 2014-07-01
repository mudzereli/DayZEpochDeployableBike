if(isServer) exitWith {};
diag_log text "CLICK ACTIONS: loading...";
DZE_CLICK_ACTIONS = [];
player_selectSlot = compile preprocessFileLineNumbers "overwrites\click_actions\ui_selectSlot.sqf";