private["_exitWith"];

_exitWith = "nil";

{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                                                    format["You can't build a %1 right now.",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [(player getVariable["combattimeout", 0]) >= time,                      format["Can't build a %1 while in combat!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [!(DZE_DEPLOYABLE_BIKE_KIT in ((weapons player) + (magazines player))), format["You need a %1 to build a %2!",DZE_DEPLOYABLE_BIKE_KIT_DISPLAY,DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [DZE_BIKE_DEPLOYING,                                                    format["You are already building a %1!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]]
];

if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

DZE_BIKE_DEPLOYING = true;

_exitWith = [
    [{r_interrupt},                                                           format["%1 building interrupted!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [{(player getVariable["combattimeout", 0]) >= time},                      format["Can't build a %1 while in combat!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]],
    [{!(DZE_DEPLOYABLE_BIKE_KIT in ((weapons player) + (magazines player)))}, format["Need a %1 to build a %2!",DZE_DEPLOYABLE_BIKE_KIT_DISPLAY,DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY]]
] call fnc_bike_crafting_animation;

if(_exitWith != "nil") exitWith {
    DZE_BIKE_DEPLOYING = false;
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

player removeWeapon DZE_DEPLOYABLE_BIKE_KIT;
player removeMagazine DZE_DEPLOYABLE_BIKE_KIT;
_object = DZE_DEPLOYABLE_BIKE_CLASS createVehicle (position player);
_object setVariable ["ObjectID", "1", true];
_object setVariable ["ObjectUID", "1", true];
player reveal _object;

taskHint [format["You've built a %1!",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY], DZE_COLOR_PRIMARY, "taskDone"];

DZE_BIKE_DEPLOYING = false;

sleep 10;

cutText ["Warning: Deployed vehicles DO NOT SAVE after server restart!", "PLAIN DOWN"];
