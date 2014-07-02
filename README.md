##CONTENTS

###DEPLOYABLE BIKE 1.1.0

#####credits: original concept/code by player2/overhaul by mudzereli

This adds a deploy bike option when right clicking a toolbox. Requires CLICK ACTIONS (below).

###CLICK ACTIONS 1.0.5.1

#####credits: mudzereli

This is used to register right click actions on items. Required by other addons. Is an overwrite so may not be compatible with mods other than Epoch 1.0.5.1. Conflicts with anything else that overwrites ui_selectSlot.sqf (most likely any addon that adds right-click options).

-----

##Installation
 1. extract the **addons** and **overwrites** folder from the downloaded zip file into your mission file root
 2. add these lines to the end of your mission file init.sqf.
   * ```call compile preprocessFileLineNumbers "overwrites\click_actions\init.sqf";```
   * ```call compile preprocessFileLineNumbers "addons\bike\init.sqf";```
 3. optionally edit "addons\bike\config.sqf" to change some options.

-----

##Change Log
* 1.1.0 - configuration options / code optimization
* 1.0.0 - release

-----

##Planned
* 1.2.0 - place deployable in front of player 
* 2.0.0 - support for array construction of variables, allowing the script to handle multiple items/matches
