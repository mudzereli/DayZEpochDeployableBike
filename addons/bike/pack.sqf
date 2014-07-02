private["_isPackingLocked","_lastPackTime","_exitWith","_deployable","_cursorTarget"];

_deployable = (_this select 3) select 0;
_cursorTarget = (_this select 3) select 1;

_exitWith = "nil";

// fix this -- use object passing because cursortarget can change
_lastPackTime = _cursorTarget getVariable["lastPackTime",diag_tickTime - 11];
_isPackingLocked = diag_tickTime - _lastPackTime < 10;

{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                               format["You can't pack your %1 right now.",(_deployable call getDeployableDisplay)]],
    [(player getVariable["combattimeout", 0]) >= time, format["Can't pack a %1 while in combat!",(_deployable call getDeployableDisplay)]],
    [_isPackingLocked,                                 format["Someone just tried to pack that %1! Try again in a few seconds.",(_deployable call getDeployableDisplay)]]
];

if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

_cursorTarget setVariable["lastPackTime",diag_tickTime,true];
player removeAction DZE_ACTION_DEPLOYABLE_PACK;

_exitWith = [
    ["r_interrupt",                                      format["Packing %1 interrupted!",(_deployable call getDeployableDisplay)]],
    ["(player getVariable['combattimeout', 0]) >= time", format["Can't pack a %1 while in combat!",(_deployable call getDeployableDisplay)]]
] call fnc_bike_crafting_animation;

if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

if((_deployable call getDeployableKitType) == "CfgWeapons") then {
    player addWeapon (_deployable call getDeployableKitClass);
} else {
    player addMagazine (_deployable call getDeployableKitClass);
};
deleteVehicle _cursorTarget;

taskHint [format["You packed your %1 back into your %2.",(_deployable call getDeployableDisplay),(_deployable call getDeployableKitDisplay)], DZE_COLOR_PRIMARY, "taskDone"];