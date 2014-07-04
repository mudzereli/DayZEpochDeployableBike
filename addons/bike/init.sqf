[] spawn {
    DZE_DEPLOYABLE_VERSION = "2.1.0";
    DZE_CRV_DEPLOYABLE = 2;

    diag_log text format["BIKE: loading version %1 ...",DZE_DEPLOYABLE_VERSION];

    // call dependency
    call compile preprocessFileLineNumbers "overwrites\click_actions\init.sqf";
    if (!(isServer) && {isNil "DZE_CLICK_ACTIONS_BUILD"}) exitWith {
        diag_log text "BIKE: ERROR -- Click Actions Handler missing!";
    };
    if (!(isServer) && {DZE_CLICK_ACTIONS_BUILD != DZE_CRV_DEPLOYABLE}) exitWith {
        diag_log text format["BIKE: ERROR -- Click Actions Handler loaded build #%1! Required build #%2!",DZE_CLICK_ACTIONS_BUILD,DZE_CRV_DEPLOYABLE];
    };


    // included compiles
    call compile preprocessFileLineNumbers "addons\bike\config.sqf";
    call compile preprocessFileLineNumbers "addons\bike\wrapper.sqf";
    call compile preprocessFileLineNumbers "addons\bike\functions.sqf";

    // inflate deployables
    DZE_DEPLOYABLES = [];
    {
        private["_class","_type","_distance","_deployables","_dirOffset","_packDist","_packAny","_packOthers","_packWorld"];
        _class       = _x select 0;
        _type        = _x select 1;
        _distance    = _x select 2;
        _dirOffset   = _x select 3;
        _packDist    = _x select 4;
        _packAny     = _x select 5;
        _packOthers  = _x select 6;
        _packWorld   = _x select 7;
        _deployables = _x select 8;
        {
            DZE_DEPLOYABLES set [count DZE_DEPLOYABLES,[_class,_type,_distance,_dirOffset,_packDist,_packAny,_packOthers,_packWorld,_x]];
        } forEach _deployables;
    } forEach DZE_DEPLOYABLES_CONFIG;

    // if server then we only need to define the safe vehicles for each deployable
    if (isServer) exitWith {
        diag_log text "BIKE: waiting for safe vehicle list...";
        waitUntil{!(isNil "DZE_safeVehicle");};
        diag_log text "BIKE: adding bike to safe vehicle list...";
        {DZE_safeVehicle = DZE_safeVehicle + [(_forEachIndex call getDeployableClass)];} forEach DZE_DEPLOYABLES;

    };

    // register actions with the click actions handler
    {DZE_CLICK_ACTIONS = DZE_CLICK_ACTIONS + [[(_forEachIndex call getDeployableKitClass),format["Deploy %1",(_forEachIndex call getDeployableDisplay)],format["%1 execVM 'addons\bike\deploy.sqf';",_forEachIndex]]];} forEach DZE_DEPLOYABLES;
    DZE_DEPLOYING      = false;
    DZE_PACKING        = false;
    
    // colors for formatting messages
    DZE_COLOR_PRIMARY = [(51/255),(181/255),(229/255),1];
    DZE_COLOR_SUCCESS = [(153/255),(204/255),0,1];
    DZE_COLOR_DANGER  = [1,(68/255),(68/255),1];

    // wait for login before we start checking actions
    diag_log text "BIKE: waiting for login...";
    waitUntil{!isNil "PVDZE_plr_LoginRecord"};

    while {true} do {
        if(!isNull player) then {
            {   
                //make sure all of these conditions pass before adding any actions -- shouldn't be too laggy since it's called every 2s rather than every frame like normal actions
                if(!(isNull cursorTarget) && {_forEachIndex call getDeployablePackAny} && {typeOf cursorTarget == (_forEachIndex call getDeployableClass)} && {call fnc_can_do} && {(cursorTarget getVariable["DeployedBy","nil"] == (getPlayerUID player)) || ((cursorTarget getVariable["DeployedBy","nil"] != "nil") && (_forEachIndex call getDeployablePackOthers)) || (_forEachIndex call getDeployablePackWorld)} && {(player distance cursorTarget) < (_forEachIndex call getDeployablePackDistance)}) then {
                    if ((_forEachIndex call getActionId) < 0) then {
                        [_forEachIndex,player addaction["<t color='#33b5e5'>" + format["Pack %1",(_forEachIndex call getDeployableDisplay)] + "</t>","addons\bike\pack.sqf",[_forEachIndex,cursorTarget],0,false,true,"", ""]] call setActionId;
                    };
                } else {
                    player removeAction (_forEachIndex call getActionId);
                    [_forEachIndex,-1] call setActionId;
                };
                if((_forEachIndex call getActionId) > -1) exitWith {};
            } forEach DZE_DEPLOYABLES;
        };
        sleep 2.5;
    };

};