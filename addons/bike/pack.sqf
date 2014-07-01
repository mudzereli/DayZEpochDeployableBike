private["_isPackingLocked","_lastPackTime","_exitWith"];

if(player getVariable["combattimeout", 0] >= time) exitWith {
    taskHint ["Can't pack a bike while in combat!", [0.972549,0.121568,0,1], "taskFailed"];
};

_lastPackTime = cursorTarget getVariable["lastPackTime",diag_tickTime - 11];
_isPackingLocked = diag_tickTime - _lastPackTime < 10;
if(_isPackingLocked) exitWith {
    taskHint ["Someone just tried to pack that bike! Try again in a few seconds.", [0.972549,0.121568,0,1], "taskFailed"];
};

cursorTarget setVariable["lastPackTime",diag_tickTime,true];
player removeAction DZE_ACTION_BIKE_PACK;

_exitWith = [
    [{r_interrupt},                                     "Bike packing interrupted!"],
    [{(player getVariable["combattimeout", 0] >= time}, "Can't pack a bike while in combat!"]
] call bike_crafting_animation;

if(!(isNil "_exitWith")) exitWith {
    taskHint [_exitWith, [0.972549,0.121568,0,1], "taskFailed"];
};

if(!_isAnimationCompleted) exitWith {
    taskHint ["Bike packing failed!", [0.972549,0.121568,0,1], "taskFailed"];
};

player addWeapon "ItemToolbox";
deleteVehicle cursortarget;

taskHint ["You packed your bike back into your toolbox.", [0.600000,0.839215,0.466666,1], "taskDone"];