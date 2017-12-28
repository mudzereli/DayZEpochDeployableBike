/*
    DayZ Base Building
    Made for DayZ Epoch please ask permission to use/edit/distrubute email vbawol@veteranbastards.com.
*/
private ["_location","_dir","_classname","_item","_hasrequireditem","_missing","_hastoolweapon","_cancel","_reason","_started","_finished","_animState","_isMedic","_dis","_sfx","_hasbuilditem","_tmpbuilt","_onLadder","_require","_text","_offset","_IsNearPlot","_isOk","_location1","_location2","_counter","_limit","_proceed","_num_removed","_position","_object","_canBuildOnPlot","_friendlies","_nearestPole","_ownerID","_findNearestPoles","_findNearestPole","_distance","_classnametmp","_ghost","_isPole","_needText","_lockable","_zheightchanged","_rotate","_combination_1","_combination_2","_combination_3","_combination_4","_combination","_combination_1_Display","_combinationDisplay","_zheightdirection","_abort","_isNear","_need","_needNear","_vehicle","_inVehicle","_requireplot","_objHDiff","_isLandFireDZ","_isTankTrap"];

if(dayz_actionInProgress) exitWith { localize "str_epoch_player_40" call dayz_rollingMessages; };
dayz_actionInProgress = true;

// disallow building if too many objects are found within 30m
_buildables = DZE_maintainClasses + DZE_LockableStorage + ["DZ_buildables","DZ_storage_base"];
if (count (nearestObjects [getPosATL player,_buildables,30]) >= DZE_BuildingLimit) exitWith {dayz_actionInProgress = false; format[localize "str_epoch_player_41",30] call dayz_rollingMessages;};

_onLadder =     (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_cancel = false;
_reason = "";
_canBuildOnPlot = false;

_vehicle = vehicle player;
_inVehicle = (_vehicle != player);

DZE_Q = false;
DZE_Z = false;

DZE_Q_alt = false;
DZE_Z_alt = false;

DZE_Q_ctrl = false;
DZE_Z_ctrl = false;

DZE_5 = false;
DZE_4 = false;
DZE_6 = false;

DZE_cancelBuilding = false;

call gear_ui_init;
closeDialog 1;

if (dayz_isSwimming) exitWith {dayz_actionInProgress = false; localize "str_player_26" call dayz_rollingMessages;};
if (_inVehicle) exitWith {dayz_actionInProgress = false; localize "str_epoch_player_42" call dayz_rollingMessages;};
if (_onLadder) exitWith {dayz_actionInProgress = false; localize "str_player_21" call dayz_rollingMessages;};
if (player getVariable["combattimeout",0] >= diag_tickTime) exitWith {dayz_actionInProgress = false; localize "str_epoch_player_43" call dayz_rollingMessages;};

_item = _this;

// Need Near Requirements
_abort = false;
_reason = "";

//### BEGIN MODIFIED CODE: player_deploy
//_needNear =     getArray (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "neednearby");
private["_index"];
_index = _this call getDeployableIndex;
_needNear = _index call getDeployableNeedNearBy;
//### END MODIFIED CODE: player_deploy

{
    switch(_x) do{
        case "fire":
        {
            _distance = 3;
            _isNear = {inflamed _x} count (getPosATL player nearObjects _distance);
            if(_isNear == 0) then {
                _abort = true;
                _reason = "fire";
            };
        };
        case "workshop":
        {
            _distance = 3;
            _isNear = count (nearestObjects [player, ["Wooden_shed_DZ","WoodShack_DZ","WorkBench_DZ"], _distance]);
            if(_isNear == 0) then {
                _abort = true;
                _reason = "workshop";
            };
        };
        case "fueltank":
        {
            _distance = 30;
            _isNear = count (nearestObjects [player, dayz_fuelsources, _distance]);
            if(_isNear == 0) then {
                _abort = true;
                _reason = "fuel tank";
            };
        };
    };
} forEach _needNear;


if(_abort) exitWith {
    format[localize "str_epoch_player_135",_reason,_distance] call dayz_rollingMessages;
    dayz_actionInProgress = false;
};

//### BEGIN MODIFIED CODE: player_deploy
//_classname =    getText (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "create");
//_classnametmp = _classname;
//_require =  getArray (configFile >> "cfgMagazines" >> _this >> "ItemActions" >> "Build" >> "require");
//_text =         getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
//_ghost = getText (configFile >> "CfgVehicles" >> _classname >> "ghostpreview");
_classname      = _index call getDeployableClass;
_classnametmp   = _classname;
_require        = [];
_text           = _index call getDeployableDisplay;
_ghost          = "";
//### END MODIFIED CODE: player_deploy

_lockable = 0;
if(isNumber (configFile >> "CfgVehicles" >> _classname >> "lockable")) then {
    _lockable = getNumber(configFile >> "CfgVehicles" >> _classname >> "lockable");
};

_requireplot = 1;
if(isNumber (configFile >> "CfgVehicles" >> _classname >> "requireplot")) then {
    _requireplot = getNumber(configFile >> "CfgVehicles" >> _classname >> "requireplot");
};
//### BEGIN MODIFIED CODE: player_deploy
if(_index call getDeployableRequirePlot) then {_requireplot = 1;} else {_requireplot = 0;};
//### END MODIFIED CODE: player_deploy

_isAllowedUnderGround = 1;
if(isNumber (configFile >> "CfgVehicles" >> _classname >> "nounderground")) then {
    _isAllowedUnderGround = getNumber(configFile >> "CfgVehicles" >> _classname >> "nounderground");
};

_offset =   getArray (configFile >> "CfgVehicles" >> _classname >> "offset");
if((count _offset) <= 0) then {
    _offset = [0,1.5,0];
};
//### BEGIN MODIFIED CODE: player_deploy
_offset = _index call getDeployableDistanceOffset;
//### END MODIFIED CODE: player_deploy

_isPole = (_classname == "Plastic_Pole_EP1_DZ");
_isLandFireDZ = (_classname == "Land_Fire_DZ");

_distance = DZE_PlotPole select 0;
_needText = localize "str_epoch_player_246";

if(_isPole) then {
    _distance = DZE_PlotPole select 1;
};

// check for near plot
_findNearestPoles = nearestObjects [(vehicle player), ["Plastic_Pole_EP1_DZ"], _distance];
_findNearestPole = [];

{
    if (alive _x) then {
        _findNearestPole set [(count _findNearestPole),_x];
    };
} count _findNearestPoles;

_IsNearPlot = count (_findNearestPole);

// If item is plot pole && another one exists within 45m
if(_isPole && _IsNearPlot > 0) exitWith {  dayz_actionInProgress = false; cutText [(localize "str_epoch_player_44") , "PLAIN DOWN"]; };

private["_exitWith"];
if(_IsNearPlot == 0) then {

    // Allow building of plot
    if(_requireplot == 0 || _isLandFireDZ) then {
        _canBuildOnPlot = true;
    } else {
        _exitWith = (localize "STR_EPOCH_PLAYER_135");
    };

} else {
    // Since there are plots nearby we check for ownership && then for friend status

    // check nearby plots ownership && then for friend status
    _nearestPole = _findNearestPole select 0;

    // Find owner
    _ownerID = _nearestPole getVariable ["CharacterID","0"];

    // diag_log format["DEBUG BUILDING: %1 = %2", dayz_characterID, _ownerID];

    // check if friendly to owner
    if(dayz_characterID == _ownerID) then {  //Keep ownership
        // owner can build anything within his plot except other plots
        if(!_isPole) then {
            _canBuildOnPlot = true;
        } else {
            _exitWith = "You can't build a plot within your plot!";
        };

    } else {
        // disallow building plot
        if(!_isPole) then {
            _friendlies     = player getVariable ["friendlyTo",[]];
            // check if friendly to owner
            if(_ownerID in _friendlies) then {
                _canBuildOnPlot = true;
            } else {
                _exitWith = "You can't build on someone else's plot!";
            };
        };
    };
};

// _message
if(!_canBuildOnPlot) exitWith {  dayz_actionInProgress = false; cutText [format[_exitWith,_needText,_distance] , "PLAIN DOWN"]; };

_missing = "";
_hasrequireditem = true;
{
    _hastoolweapon = _x in weapons player;
    if(!_hastoolweapon) exitWith { _hasrequireditem = false; _missing = getText (configFile >> "cfgWeapons" >> _x >> "displayName"); };
} count _require;
//### BEGIN MODIFIED CODE player_deploy
    _hastoolweapon = (_index call getDeployableKitClass) in ((weapons player) + (magazines player));
    if(!_hastoolweapon) then { _hasrequireditem = false; _missing = (_index call getDeployableKitDisplay); };
//### END MODIFIED CODE: player_deploy

//### BEGIN MODIFIED CODE player_deploy
//_hasbuilditem = _this in magazines player;
//if (!_hasbuilditem) exitWith {dayz_actionInProgress = false; cutText [format[(localize "str_player_31"),_text,"build"] , "PLAIN DOWN"]; };
_hasbuilditem = [player,_index] call getHasDeployableParts;
if (!_hasbuilditem) exitWith {dayz_actionInProgress = false; cutText [format[(localize "str_player_31"),str (_index call getDeployableParts),"build"] , "PLAIN DOWN"]; };
//### END MODIFIED CODE: player_deploy

if (!_hasrequireditem) exitWith {dayz_actionInProgress = false; cutText [format[(localize "str_epoch_player_137"),_missing] , "PLAIN DOWN"]; };
if (_hasrequireditem) then {

    _dir = getdir player;
    _location = getPos player;
    _location = [(_location select 0)+8*sin(_dir),(_location select 1)+8*cos(_dir),0]; 
    //maybe adjust the hight? [x,y,z(0)]
    
    _isOk = true;

    // get inital players position
    _location1 = getPosATL player;
    //_dir = getDir player;

    // if ghost preview available use that instead
    if (_ghost != "") then {
        _classname = _ghost;
    };

    _object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
    //### BEGIN MODIFIED CODE player_deploy
    _object setVariable["ObjectUID","1",true];

    _object attachTo [player,_offset];

	_position = getPosATL _object;
	
	//_dir = 0;
    _object setDir _dir;
    //### END MODIFIED CODE: player_deploy

    cutText [(localize "str_epoch_player_45"), "PLAIN DOWN"];

    _objHDiff = 0;

    while {_isOk} do {

        _zheightchanged = false;
        _zheightdirection = "";
        _rotate = false;

        if (DZE_Q) then {
            DZE_Q = false;
            _zheightdirection = "up";
            _zheightchanged = true;
        };
        if (DZE_Z) then {
            DZE_Z = false;
            _zheightdirection = "down";
            _zheightchanged = true;
        };
        if (DZE_Q_alt) then {
            DZE_Q_alt = false;
            _zheightdirection = "up_alt";
            _zheightchanged = true;
        };
        if (DZE_Z_alt) then {
            DZE_Z_alt = false;
            _zheightdirection = "down_alt";
            _zheightchanged = true;
        };
        if (DZE_Q_ctrl) then {
            DZE_Q_ctrl = false;
            _zheightdirection = "up_ctrl";
            _zheightchanged = true;
        };
        if (DZE_Z_ctrl) then {
            DZE_Z_ctrl = false;
            _zheightdirection = "down_ctrl";
            _zheightchanged = true;
        };
        if (DZE_4) then {
            _rotate = true;
            DZE_4 = false;
            //###BEGIN MODIFIED CODE: player deploy
            //_dir = 0;
            _dir = _dir + 30;
            //###END MODIFIED CODE: player deploy
        };
        if (DZE_6) then {
            _rotate = true;
            DZE_6 = false;
            //###BEGIN MODIFIED CODE: player deploy
            //_dir = 180;
            _dir = _dir - 30;
            //###END MODIFIED CODE: player deploy
        };

        if(_rotate) then {
            _object setDir _dir;
            _object setPosATL _position;
            //diag_log format["DEBUG Rotate BUILDING POS: %1", _position];
        };

        if(_zheightchanged) then {
            detach _object;

            _position = getPosATL _object;

            if(_zheightdirection == "up") then {
                _position set [2,((_position select 2)+0.1)];
                _objHDiff = _objHDiff + 0.1;
            };
            if(_zheightdirection == "down") then {
                _position set [2,((_position select 2)-0.1)];
                _objHDiff = _objHDiff - 0.1;
            };

            if(_zheightdirection == "up_alt") then {
                _position set [2,((_position select 2)+1)];
                _objHDiff = _objHDiff + 1;
            };
            if(_zheightdirection == "down_alt") then {
                _position set [2,((_position select 2)-1)];
                _objHDiff = _objHDiff - 1;
            };

            if(_zheightdirection == "up_ctrl") then {
                _position set [2,((_position select 2)+0.01)];
                _objHDiff = _objHDiff + 0.01;
            };
            if(_zheightdirection == "down_ctrl") then {
                _position set [2,((_position select 2)-0.01)];
                _objHDiff = _objHDiff - 0.01;
            };

            //###BEGIN MODIFIED CODE: player deploy
            //_object setDir (getDir _object);
            //###END MODIFIED CODE: player deploy

            if((_isAllowedUnderGround == 0) && ((_position select 2) < 0)) then {
                _position set [2,0];
            };

            _object setPosATL _position;

            //diag_log format["DEBUG Change BUILDING POS: %1", _position];

            _object attachTo [player];

            //### BEGIN MODIFIED CODE player_deploy
            _object setDir _dir;
            //### END MODIFIED CODE: player_deploy

        };

        sleep 0.5;

        _location2 = getPosATL player;

        if(DZE_5) exitWith {
            _isOk = false;
            detach _object;
            _dir = getDir _object;
            _position = getPosATL _object;
            //diag_log format["DEBUG BUILDING POS: %1", _position];
            _object setPos[0,0,0];
            deleteVehicle _object;
        };

        if(_location1 distance _location2 > 5) exitWith {
            _isOk = false;
            _cancel = true;
            _reason = "You've moved to far away from where you started building (within 5 meters)";
            detach _object;
            _object setPos[0,0,0];
            deleteVehicle _object;
        };

        if(abs(_objHDiff) > 5) exitWith {
            _isOk = false;
            _cancel = true;
            _reason = "Cannot move up || down more than 5 meters";
            detach _object;
            _object setPos[0,0,0];
            deleteVehicle _object;
        };

        if (player getVariable["inCombat",false]) exitWith {
            _isOk = false;
            _cancel = true;
            _reason = (localize "str_epoch_player_43");
            detach _object;
            _object setPos[0,0,0];
            deleteVehicle _object;
        };

        if (DZE_cancelBuilding) exitWith {
            _isOk = false;
            _cancel = true;
            _reason = "Cancelled building.";
            detach _object;
            _object setPos[0,0,0];
            deleteVehicle _object;
        };
    };

    //### END MODIFIED CODE: road building
    //No building on roads unless toggled
    //if (!DZE_BuildOnRoads) then {
    if (!(_index call getDeployableBuildOnRoad)) then {
    //### END MODIFIED CODE: road building
        if (isOnRoad [_position select 0, _position select 1, 0]) then { _cancel = true; _reason = "Cannot build on a road."; };
    };

    // No building in trader zones
    if(!canbuild) then { _cancel = true; _reason = "Cannot build in a city."; };

    if(!_cancel) then {

        _classname = _classnametmp;

        // Start Build
        _tmpbuilt = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];

        //### BEGIN MODIFIED CODE: player deploy
        if (!(_index call getDeployableSimulation)) then {
            _tmpbuilt enableSimulation false;
        };
        _tmpbuilt setVariable ["ObjectUID", "1", true];
        //### END MODIFIED CODE: player deploy

        _tmpbuilt setdir _dir;

        // Get position based on object
        _location = _position;

        if((_isAllowedUnderGround == 0) && ((_location select 2) < 0)) then {
            _location set [2,0];
        };

        _tmpbuilt setPosATL _location;


        cutText [format[(localize "str_epoch_player_138"),_text], "PLAIN DOWN"];

        _limit = 3;

        if (DZE_StaticConstructionCount > 0) then {
            _limit = DZE_StaticConstructionCount;
        }
        else {
            if (isNumber (configFile >> "CfgVehicles" >> _classname >> "constructioncount")) then {
                _limit = getNumber(configFile >> "CfgVehicles" >> _classname >> "constructioncount");
            };
        };

        _isOk = true;
        _proceed = false;
        _counter = 0;

        while {_isOk} do {

            ["Working",0,[100,15,10,0]] call dayz_NutritionSystem;
            player playActionNow "Medic";

            _dis=20;
            _sfx = "repair";
            [player,_sfx,0,false,_dis] call dayz_zombieSpeak;
            [player,_dis,true,(getPosATL player)] spawn player_alertZombies;

            r_interrupt = false;
            r_doLoop = true;
            _started = false;
            _finished = false;

            while {r_doLoop} do {
                _animState = animationState player;
                _isMedic = ["medic",_animState] call fnc_inString;
                if (_isMedic) then {
                    _started = true;
                };
                if (_started && !_isMedic) then {
                    r_doLoop = false;
                    _finished = true;
                };
                if (r_interrupt || (player getVariable["inCombat",false])) then {
                    r_doLoop = false;
                };
                if (DZE_cancelBuilding) exitWith {
                    r_doLoop = false;
                };
                sleep 0.1;
            };
            r_doLoop = false;


            if(!_finished) exitWith {
                _isOk = false;
                _proceed = false;
            };

            if(_finished) then {
                _counter = _counter + 1;
            };

            cutText [format[(localize "str_epoch_player_139"),_text, _counter,_limit], "PLAIN DOWN"];

            if(_counter == _limit) exitWith {
                _isOk = false;
                _proceed = true;
            };

        };

        if (_proceed) then {

            //###BEGIN MODIFIED CODE
            //_num_removed = ([player,_item] call BIS_fnc_invRemove);
            //if(_num_removed == 1) then {
            if([player,_index] call getHasDeployableParts) then {
                [player,_index] call removeDeployableParts;
            //###BEGIN MODIFIED CODE

                cutText [format[localize "str_build_01",_text], "PLAIN DOWN"];

                if (_isPole) then {
                    [] spawn player_plotPreview;
                };

                _tmpbuilt setVariable ["OEMPos",_location,true];

                if(_lockable > 1) then {

                    _combinationDisplay = "";

                    switch (_lockable) do {

                        case 2: { // 2 lockbox
                            _combination_1 = (floor(random 3)) + 100; // 100=red,101=green,102=blue
                            _combination_2 = floor(random 10);
                            _combination_3 = floor(random 10);
                            _combination = format["%1%2%3",_combination_1,_combination_2,_combination_3];
                            dayz_combination = _combination;
                            if (_combination_1 == 100) then {
                                _combination_1_Display = "Red";
                            };
                            if (_combination_1 == 101) then {
                                _combination_1_Display = "Green";
                            };
                            if (_combination_1 == 102) then {
                                _combination_1_Display = "Blue";
                            };
                            _combinationDisplay = format["%1%2%3",_combination_1_Display,_combination_2,_combination_3];
                        };

                        case 3: { // 3 combolock
                            _combination_1 = floor(random 10);
                            _combination_2 = floor(random 10);
                            _combination_3 = floor(random 10);
                            _combination = format["%1%2%3",_combination_1,_combination_2,_combination_3];
                            dayz_combination = _combination;
                            _combinationDisplay = _combination;
                        };

                        case 4: { // 4 safe
                            _combination_1 = floor(random 10);
                            _combination_2 = floor(random 10);
                            _combination_3 = floor(random 10);
                            _combination_4 = floor(random 10);
                            _combination = format["%1%2%3%4",_combination_1,_combination_2,_combination_3,_combination_4];
                            dayz_combination = _combination;
                            _combinationDisplay = _combination;
                        };
                    };

                    _tmpbuilt setVariable ["CharacterID",_combination,true];

					if (DZE_permanentPlot) then {
						_tmpbuilt setVariable ["ownerPUID",dayz_playerUID,true];
						PVDZ_obj_Publish = [_combination,_tmpbuilt,[_dir,_location,dayz_playerUID],[],player,dayz_authKey];
					} else {
						PVDZ_obj_Publish = [_combination,_tmpbuilt,[_dir,_location],[],player,dayz_authKey];
					};
					
					publicVariableServer "PVDZ_obj_Publish";
                    cutText [format[(localize "str_epoch_player_140"),_combinationDisplay,_text], "PLAIN DOWN", 5];
                } else {
                    //_tmpbuilt setVariable ["CharacterID",dayz_characterID,true];
                    //### BEGIN MODIFIED CODE: player deploy
                    // fire?
                    //if(_tmpbuilt isKindOf "Land_Fire_DZ") then {
                    //    _tmpbuilt spawn player_fireMonitor;
                    //} else {
                    //    PVDZ_obj_Publish = [dayz_characterID,_tmpbuilt,[_dir,_location],_classname];
                    //    publicVariableServer "PVDZ_obj_Publish";
                    //};
                    if (_index call getPermanent) then {
                        _tmpbuilt call fnc_set_temp_deployable_id;
                        if(_index call getDeployableSimulation) then {
                            PVDZE_veh_Publish2 = [[_dir,_position],(_index call getDeployableClass),true,call fnc_perm_deployable_id,player,dayz_authKey];
                            publicVariableServer "PVDZE_veh_Publish2";
                        } else {
							if (DZE_permanentPlot) then {
								_tmpbuilt setVariable ["ownerPUID",dayz_playerUID,true];
								PVDZ_obj_Publish = [call fnc_perm_deployable_id,_tmpbuilt,[_dir,_position,dayz_playerUID],[],player,dayz_authKey];
							} else {
								PVDZ_obj_Publish = [call fnc_perm_deployable_id,_tmpbuilt,[_dir,_position],[],player,dayz_authKey];
							};
							publicVariableServer "PVDZ_obj_Publish";
                        };
                    } else {
                        _tmpbuilt call fnc_set_temp_deployable_id;
                    };
                    if(_index call getClearCargo) then {
                        clearWeaponCargoGlobal _tmpbuilt;
                        clearMagazineCargoGlobal _tmpbuilt;
                    };
                    if(_index call getDeployableClearAmmo) then {
                        _tmpbuilt setVehicleAmmo 0;
                    };
                    player reveal _tmpbuilt;
                    DZE_DEPLOYING_SUCCESSFUL = true;
                    //### END MODIFIED CODE: player deploy
                };
            } else {
                _tmpbuilt setPos[0,0,0];
                deleteVehicle _tmpbuilt;
                cutText [(localize "str_epoch_player_46") , "PLAIN DOWN"];
            };

        } else {
            r_interrupt = false;
            if (vehicle player == player) then {
                [objNull, player, rSwitchMove,""] call RE;
                player playActionNow "stop";
            };

            _tmpbuilt setPos[0,0,0];
            deleteVehicle _tmpbuilt;

            cutText [(localize "str_epoch_player_46") , "PLAIN DOWN"];
        };

    } else {
        cutText [format[(localize "str_epoch_player_47"),_text,_reason], "PLAIN DOWN"];
    };
};

dayz_actionInProgress = false;