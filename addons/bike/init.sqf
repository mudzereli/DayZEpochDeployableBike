[] spawn {

    call compile preprocessFileLineNumbers "addons\bike\config.sqf";

    DZE_DEPLOYABLE_BIKE_KIT_DISPLAY = getText (configFile >> DZE_DEPLOYABLE_BIKE_KIT_TYPE >> DZE_DEPLOYABLE_BIKE_KIT >> "displayName");
    DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY = getText (configFile >> "CfgVehicles" >> DZE_DEPLOYABLE_BIKE_CLASS >> "displayName");

    if (isServer) exitWith {
        diag_log text "BIKE: waiting for safe vehicle list...";
        waitUntil{!(isNil "DZE_safeVehicle");};
        diag_log text "BIKE: adding bike to safe vehicle list...";
        DZE_safeVehicle = DZE_safeVehicle + [DZE_DEPLOYABLE_BIKE_CLASS];
    };

    call compile preprocessFileLineNumbers "addons\bike\functions.sqf";

    DZE_CLICK_ACTIONS = DZE_CLICK_ACTIONS + [[DZE_DEPLOYABLE_BIKE_KIT,format["Deploy %1",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY],"execVM 'addons\bike\deploy.sqf';"]];
    DZE_BIKE_DEPLOYING = false;

    DZE_COLOR_PRIMARY = [(51/255),(181/255),(229/255),1];
    DZE_COLOR_SUCCESS = [(153/255),(204/255),0,1];
    DZE_COLOR_DANGER  = [1,(68/255),(68/255),1];



    diag_log text "BIKE: waiting for login...";
    waitUntil{!isNil "PVDZE_plr_LoginRecord"};

    while {true} do {
        if(!isNull player) then {
            if(typeOf cursorTarget in DZE_DEPLOYABLE_BIKE_MATCH and (call fnc_can_do)) then {
                if (DZE_ACTION_BIKE_PACK < 0) then {
                    DZE_ACTION_BIKE_PACK = player addaction["<t color='#33b5e5'>" + format["Pack %1",DZE_DEPLOYABLE_BIKE_CLASS_DISPLAY] + "</t>","addons\bike\pack.sqf","",0,false,true,"", ""];
                };
            } else {
                player removeAction DZE_ACTION_BIKE_PACK;
                DZE_ACTION_BIKE_PACK = -1;
            };
        };
        sleep 2;
    };

};