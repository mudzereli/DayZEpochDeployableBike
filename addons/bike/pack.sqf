private["_isPackingLocked","_lastPackTime","_exitWith"];

_exitWith = nil;

_lastPackTime = cursorTarget getVariable["lastPackTime",diag_tickTime - 11];
_isPackingLocked = diag_tickTime - _lastPackTime < 10;

{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                               "You can't pack your bike right now."],
    [(player getVariable["combattimeout", 0]) >= time, "Can't build a bike while in combat!"],
    [_isPackingLocked,                                 "Someone just tried to pack that bike! Try again in a few seconds."]
];

if(!(isNil "_exitWith")) exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

cursorTarget setVariable["lastPackTime",diag_tickTime,true];
player removeAction DZE_ACTION_BIKE_PACK;

_exitWith = [
    [{r_interrupt},                                      "Bike packing interrupted!"],
    [{(player getVariable["combattimeout", 0]) >= time}, "Can't pack a bike while in combat!"]
] call fnc_bike_crafting_animation;

if(!(isNil "_exitWith")) exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

player addWeapon "ItemToolbox";
deleteVehicle cursortarget;

taskHint ["You packed your bike back into your toolbox.", DZE_COLOR_PRIMARY, "taskDone"];