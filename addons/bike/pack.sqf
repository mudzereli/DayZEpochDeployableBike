private["_isPackingLocked","_lastPackTime"];

if(player getVariable["combattimeout", 0] >= time) exitWith {
    taskHint ["Can't pack bike while in combat!", [0.972549,0.121568,0,1], "taskFailed"];
};

_lastPackTime = cursorTarget getVariable["lastPackTime",diag_tickTime - 10];
_isPackingLocked = diag_tickTime - _lastPackTime < 8;
if(_isPackingLocked) exitWith {
    taskHint ["Someone just tried to pack that bike! Try again in a few seconds.", [0.972549,0.121568,0,1], "taskFailed"];
};

cursorTarget setVariable["lastPackTime",diag_tickTime,true];
player removeAction DZE_ACTION_BIKE_PACK;

_dis=10;
_sfx = "repair";
[player,_sfx,0,false,_dis] call dayz_zombieSpeak;
[player,_dis,true,(getPosATL player)] spawn player_alertZombies;

player playActionNow "Medic";

r_interrupt = false;
_isLoopDone = false;
_isAnimationStarted = false;
_isAnimationCompleted = false;
_animationState = animationState player;
_isAnimationActive = false;

while {!_isLoopDone} do {
    _animationState = animationState player;
    _isAnimationActive = ["medic",_animationState] call fnc_inString;
    if (_isAnimationActive) then {
        _isAnimationStarted = true;
    };
    if (_isAnimationStarted and !_isAnimationActive) then {
        _isLoopDone = true;
        _isAnimationCompleted = true;
    };
    if (r_interrupt or (player getVariable["combattimeout", 0] >= time)) then {
        _isLoopDone = true;
        player switchMove "";
        player playActionNow "stop";
    };
    sleep 0.1;
};

if(_isAnimationCompleted) then {
    player addWeapon "ItemToolbox";
    deleteVehicle cursortarget;
    taskHint ["You packed your bike back into your toolbox.", [0.600000,0.839215,0.466666,1], "taskDone"];
} else {
    taskHint ["Bike packing cancelled!", [0.972549,0.121568,0,1], "taskFailed"];
};