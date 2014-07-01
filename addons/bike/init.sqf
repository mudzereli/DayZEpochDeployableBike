[] spawn {
    if (isServer) exitWith {
        diag_log text "BIKE: waiting for safe vehicle list...";
        waitUntil{!(isNil "DZE_safeVehicle");};
        diag_log text "BIKE: adding bike to safe vehicle list...";
        DZE_safeVehicle = DZE_safeVehicle + ["MMT_Civ"];
    };
    call compile preprocessFileLineNumbers "addons\bike\functions.sqf";
    DZE_CLICK_ACTIONS = DZE_CLICK_ACTIONS + [["ItemToolbox","Deploy Bike","execVM 'addons\bike\deploy.sqf';"]];
    DZE_BIKE_DEPLOYING = false;
    diag_log text "BIKE: waiting for login...";
    waitUntil{!isNil "PVDZE_plr_LoginRecord"};
    while {true} do {
        if(!isNull player) then {
            private["_isBike","_canDo","_onLadder"];
            _onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
            _canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);
            _isBike = typeOf cursorTarget in ["Old_bike_TK_INS_EP1","Old_bike_TK_CIV_EP1","MMT_Civ"];
             
            if(_isBike and _canDo) then {
                if (DZE_ACTION_BIKE_PACK < 0) then {
                    DZE_ACTION_BIKE_PACK = player addaction["<t color='#33b5e5'>Pack Bike</t>","addons\bike\pack.sqf","",0,false,true,"", ""];
                };
            } else {
                player removeAction DZE_ACTION_BIKE_PACK;
                DZE_ACTION_BIKE_PACK = -1;
            };
        };
        sleep 2;
    };
};