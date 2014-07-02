private["_canDo","_onLadder","_exitWith"];

_exitWith = nil;

{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                               "You can't build a bike right now."],
    [(player getVariable["combattimeout", 0]) >= time, "Can't build a bike while in combat!"],
    [!(player hasWeapon "ItemToolbox"),                "You need a toolbox to build a bike!"],
    [DZE_BIKE_DEPLOYING,                               "You are already building a bike!"]
];

if(!(isNil "_exitWith")) exitWith {
    taskHint [_exitWith, [0.972549,0.121568,0,1], "taskFailed"];
};

DZE_BIKE_DEPLOYING = true;

_exitWith = [
    [{r_interrupt},                                      "Bike building interrupted!"],
    [{(player getVariable["combattimeout", 0]) >= time}, "Can't build a bike while in combat!"],
    [{!(player hasWeapon "ItemToolbox")},                "Need a toolbox to build a bike!"]
] call fnc_bike_crafting_animation;

if(!(isNil "_exitWith")) exitWith {
    DZE_BIKE_DEPLOYING = false;
    taskHint [_exitWith, [0.972549,0.121568,0,1], "taskFailed"];
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
