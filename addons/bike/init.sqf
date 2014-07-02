[] spawn {
    
    call compile preprocessFileLineNumbers "addons\bike\config.sqf";
    call compile preprocessFileLineNumbers "addons\bike\wrapper.sqf";

    DZE_DEPLOYABLES = [];
    {
        private["_class","_type","_distance","_deployables","_dirOffset"];
        _class       = _x select 0;
        _type        = _x select 1;
        _distance    = _x select 2;
        _dirOffset   = _x select 3;
        _deployables = _x select 4;
        {
            DZE_DEPLOYABLES set [count DZE_DEPLOYABLES,[_class,_type,_x,_distance,_dirOffset]];
        } forEach _deployables;
    } forEach DZE_DEPLOYABLES_CONFIG;
    if (isServer) exitWith {
        diag_log text "BIKE: waiting for safe vehicle list...";
        waitUntil{!(isNil "DZE_safeVehicle");};
        diag_log text "BIKE: adding bike to safe vehicle list...";
        {DZE_safeVehicle = DZE_safeVehicle + [(_forEachIndex call getDeployableClass)];} forEach DZE_DEPLOYABLES;
    };

    call compile preprocessFileLineNumbers "addons\bike\functions.sqf";

    {DZE_CLICK_ACTIONS = DZE_CLICK_ACTIONS + [[(_forEachIndex call getDeployableKitClass),format["Deploy %1",(_forEachIndex call getDeployableDisplay)],format["%1 execVM 'addons\bike\deploy.sqf';",_forEachIndex]]];} forEach DZE_DEPLOYABLES;
    DZE_DEPLOYING = false;

    DZE_COLOR_PRIMARY = [(51/255),(181/255),(229/255),1];
    DZE_COLOR_SUCCESS = [(153/255),(204/255),0,1];
    DZE_COLOR_DANGER  = [1,(68/255),(68/255),1];

    diag_log text "BIKE: waiting for login...";
    waitUntil{!isNil "PVDZE_plr_LoginRecord"};

    while {true} do {
        if(!isNull player) then {
            {
                if(typeOf cursorTarget == (_forEachIndex call getDeployableClass) and (call fnc_can_do) and ((cursorTarget getVariable["DeployedBy","nil"]) == (getPlayerUID player)) and ((player distance cursorTarget) < 10)) then {
                    if (DZE_ACTION_DEPLOYABLE_PACK < 0) then {
                        DZE_ACTION_DEPLOYABLE_PACK = player addaction["<t color='#33b5e5'>" + format["Pack %1",(_forEachIndex call getDeployableDisplay)] + "</t>","addons\bike\pack.sqf",[_forEachIndex,cursorTarget],0,false,true,"", ""];
                    };
                } else {
                    player removeAction DZE_ACTION_DEPLOYABLE_PACK;
                    DZE_ACTION_DEPLOYABLE_PACK = -1;
                };
                if (DZE_ACTION_DEPLOYABLE_PACK > -1) exitWith {};
            } forEach DZE_DEPLOYABLES;
        };
        sleep 2;
    };

};