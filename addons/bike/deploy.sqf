private["_canDo","_onLadder","_anim","_loop","_animationState","_isAnimationStarted","_isAnimationCompleted","_isAnimationActive","_isLoopDone","_exitWith"];

if(player getVariable["combattimeout", 0] >= time) exitWith {
    taskHint ["Can't deploy bike while in combat!", [0.972549,0.121568,0,1], "taskFailed"];
};

_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);
if (!_canDo || DZE_BIKE_DEPLOYING) exitWith {
    taskHint ["You can't build a bike right now!", [0.972549,0.121568,0,1], "taskFailed"];
};

DZE_BIKE_DEPLOYING = true;

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
_exitWith = nil;

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
    if(r_interrupt) then {
        _exitWith = "Bike building interrupted!";
    } else if(player getVariable["combattimeout", 0] >= time) then {
        _exitWith = "Can't build a bike while in combat!";
    } else if(!(player hasWeapon "ItemToolbox")) then {
        _exitWith = "You must have a toolbox to build a bike!";
    };
    if (!(isNil "_exitWith")) then {
        _isLoopDone = true;
        player switchMove "";
        player playActionNow "stop";
    };
    sleep 0.3;
};

if(!(isNil "_exitWith")) exitWith {
    DZE_BIKE_DEPLOYING = false;
    taskHint [_exitWith, [0.972549,0.121568,0,1], "taskFailed"];
};

if(!_isAnimationCompleted) exitWith {
    DZE_BIKE_DEPLOYING = false;
    taskHint ["Bike building failed!", [0.972549,0.121568,0,1], "taskFailed"];
};

player removeWeapon "ItemToolbox";
_object = "MMT_Civ" createVehicle (position player);
_object setVariable ["ObjectID", "1", true];
_object setVariable ["ObjectUID", "1", true];
player reveal _object;

taskHint ["You've built a bike!", [0.600000,0.839215,0.466666,1], "taskDone"];

DZE_BIKE_DEPLOYING = false;

sleep 10;

cutText ["Warning: Spawned bikes DO NOT SAVE after server restart!", "PLAIN DOWN"];
