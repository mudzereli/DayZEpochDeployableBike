private["_exitWith","_position","_display","_object"];

_exitWith = "nil";

// close the gear display when player starts to deploy
disableSerialization;
_display = findDisplay 106;
if(!(isNull _display)) then {
    _display closeDisplay 0;
};

// check these conditions to make sure it's okay to start deploying, if it's not, we'll get a message back
{
    if(_x select 0) exitWith {
        _exitWith = (_x select 1);
    };
} forEach [
    [(getPlayerUID player) in DZE_DEPLOYABLE_ADMINS,                                                                   "admin"],
    [!(call fnc_can_do),                                                                                        format["You can't build a %1 right now.",(_this call getDeployableDisplay)]],
    [(player getVariable["combattimeout", 0]) >= time,                                                          format["Can't build a %1 while in combat!",(_this call getDeployableDisplay)]],
    [!((_this call getDeployableKitClass) in ((weapons player) + (magazines player) + [currentWeapon player])), format["You need a %1 to build a %2!",(_this call getDeployableKitDisplay),(_this call getDeployableDisplay)]],
    [DZE_DEPLOYING,                                                                                                    "You are already building something!"],
    [DZE_PACKING,                                                                                                      "You are already packing something!"]
];

// if we got an error message, show it and leave the script
if(_exitWith != "nil" && _exitWith != "admin") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

// now we're deploying!
DZE_DEPLOYING = true;

// do the crafting animation until we either finish it or one of these conditions is broken
_exitWith = [
    ["(getPlayerUID player) in DZE_DEPLOYABLE_ADMINS",                                                       "admin"],
    ["r_interrupt",                                                                                   format["%1 building interrupted!",(_this call getDeployableDisplay)]],
    ["(player getVariable['combattimeout', 0]) >= time",                                              format["Can't build a %1 while in combat!",(_this call getDeployableDisplay)]],
    [format["!(('%1') in ((weapons player) + (magazines player)))",_this call getDeployableKitClass], format["Need a %1 to build a %2!",(_this call getDeployableKitDisplay),(_this call getDeployableDisplay)]]
] call fnc_bike_crafting_animation;

// if we got an error message, show it and leave the script
if(_exitWith != "nil" && _exitWith != "admin") exitWith {
    DZE_DEPLOYING = false;
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

// take away all the crafting components and spawn our reward!
player removeWeapon (_this call getDeployableKitClass);
player removeMagazine (_this call getDeployableKitClass);
_object = (_this call getDeployableClass) createVehicle (position player);
_object setPos (player modelToWorld [0,(_this call getDeployableDistance),0]);
_object setDir ((getDir player) + (_this call getDeployableDirectionOffset));
if (_this call getPermanent) then {
    PVDZE_veh_Publish = [_object,[getDir _object,getPos _object],(_this call getDeployableClass),true,call fnc_perm_deployable_id];
    publicVariableServer "PVDZE_veh_Publish";
} else {
    _object setVariable ["ObjectID", "1", true];
    _object setVariable ["ObjectUID", "1", true];
    _object call fnc_set_temp_deployable_id;
};
if(_this call getClearCargo) then {
    clearWeaponCargoGlobal _object;
    clearMagazineCargoGlobal _object;
};
DZE_DEPLOYING = false;
player reveal _object;

// congrats!
taskHint [format["You've built a %1!",(_this call getDeployableDisplay)], DZE_COLOR_PRIMARY, "taskDone"];

sleep 10;

// notify of despawn if it's not a permanent vehicle
if (!(_this call getPermanent)) then { 
    cutText ["Warning: Deployed vehicles DO NOT SAVE after server restart!", "PLAIN DOWN"]; 
} else {
    cutText ["This vehicle is permanent and will persist through server restarts!", "PLAIN DOWN"]; 
};
