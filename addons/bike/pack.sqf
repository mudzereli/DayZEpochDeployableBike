private["_isPackingLocked","_lastPackTime","_exitWith"];

_exitWith = "nil";

_lastPackTime = cursorTarget getVariable["lastPackTime",diag_tickTime - 11];
_isPackingLocked = diag_tickTime - _lastPackTime < 10;

{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                               format["You can't pack your %1 right now.",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [(player getVariable["combattimeout", 0]) >= time, format["Can't build a %1 while in combat!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [_isPackingLocked,                                 format["Someone just tried to pack that %1! Try again in a few seconds.",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]]
];

if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

cursorTarget setVariable["lastPackTime",diag_tickTime,true];
player removeAction DZE_ACTION_BIKE_PACK;

_exitWith = [
    [{r_interrupt},                                      format["Packing %1 interrupted!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [{(player getVariable["combattimeout", 0]) >= time}, format["Can't pack a %1 while in combat!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]]
] call fnc_bike_crafting_animation;

if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

if(DZE_DEPLOYABLE_BIKE_KIT_TYPE == "CfgWeapons") then {
    player addWeapon DZE_DEPLOYABLE_BIKE_KIT;
} else {
    player addMagazine DZE_DEPLOYABLE_BIKE_KIT;
};
deleteVehicle cursortarget;

taskHint [format["You packed your %1 back into your %2.",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY,DZE_DEPLOYABLE_BIKE_KIT_DISPLAY], DZE_COLOR_PRIMARY, "taskDone"];