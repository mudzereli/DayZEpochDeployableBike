/* this sqf file is used to manipulate the deployable array to work more like a class than an array */

/* this gets the item that makes the deployable */
getDeployableKitClass = {
    ((DZE_DEPLOYABLES select _this) select 1) select 0
};

/* this gets what type of item the kit is*/
getDeployableKitType = {
    ((DZE_DEPLOYABLES select _this) select 1) select 1
};

/* this gets the display name of the kit */
getDeployableKitDisplay = {
    private["_display"];
    //diag_log text format["BIKE: trying to get display of %1",_this call getDeployableKitClass];
    _display = getText (configFile >> (_this call getDeployableKitType) >> (_this call getDeployableKitClass) >> "displayName");
    //diag_log text format["BIKE: post config lookup: display = %1",_display];
    if((isNil "_display")||_display == "") then {
        _display = (_this call getDeployableKitClass);
    };
    diag_log text format["BIKE: post patch check: display = %1",_display];
    _display
};

/* this gets the class of the deployable */
getDeployableClass = {
    ((DZE_DEPLOYABLES select _this) select 0) select 0
};

/* this gets the comparable (same) classes of the deployable */
getDeployableMatchClasses = {
    ((DZE_DEPLOYABLES select _this) select 0) select 1
};

/* this gets the display name of the deployable */
getDeployableDisplay = {
    private["_display"];
    //diag_log text format["BIKE: trying to get display of %1",_this call getDeployableClass];
    _display = getText (configFile >> "CfgVehicles" >> (_this call getDeployableClass) >> "displayName");
    //diag_log text format["BIKE: post config lookup: display = %1",_display];
    if((isNil "_display")||_display == "") then {
        _display = (_this call getDeployableClass);
    };
    diag_log text format["BIKE: post patch check: display = %1",_display];
    _display
};