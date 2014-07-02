private["_exitWith"];

_exitWith = "nil";

{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                                                               format["You can't build a %1 right now.",(_this call getDeployableDisplay)]],
    [(player getVariable["combattimeout", 0]) >= time,                                 format["Can't build a %1 while in combat!",(_this call getDeployableDisplay)]],
    [!((_this call getDeployableKitClass) in ((weapons player) + (magazines player))), format["You need a %1 to build a %2!",(_this call getDeployableKitDisplay),(_this call getDeployableDisplay)]],
    [DZE_DEPLOYING,                                                                    format["You are already building a %1!",(_this call getDeployableDisplay)]]
];

if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

DZE_DEPLOYING = true;

_exitWith = [
    ["r_interrupt",                                                                                   format["%1 building interrupted!",(_this call getDeployableDisplay)]],
    ["(player getVariable['combattimeout', 0]) >= time",                                              format["Can't build a %1 while in combat!",(_this call getDeployableDisplay)]],
    [format["!(('%1') in ((weapons player) + (magazines player)))",_this call getDeployableKitClass], format["Need a %1 to build a %2!",(_this call getDeployableKitDisplay),(_this call getDeployableDisplay)]]
] call fnc_bike_crafting_animation;

if(_exitWith != "nil") exitWith {
    DZE_DEPLOYING = false;
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

player removeWeapon (_this call getDeployableKitClass);
player removeMagazine (_this call getDeployableKitClass);
_object = (_this call getDeployableClass) createVehicle (position player);
_object setVariable ["ObjectID", "1", true];
_object setVariable ["ObjectUID", "1", true];
_object setVariable ["DeployedBy",getPlayerUID player,true];
player reveal _object;

taskHint [format["You've built a %1!",(_this call getDeployableDisplay)], DZE_COLOR_PRIMARY, "taskDone"];

DZE_DEPLOYING = false;

sleep 10;

cutText ["Warning: Deployed vehicles DO NOT SAVE after server restart!", "PLAIN DOWN"];
