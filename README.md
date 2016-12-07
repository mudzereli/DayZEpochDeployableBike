####DEPLOYABLE BIKE 2.8.2

**version 2.8.1 updates the code for Epoch Mod 1.0.6. Thanks @ebaydayz!**

**version 2.8.0 adds options for conditional display of actions & options for clearing ammo from vehicles**

Out of the box, it adds a deployable bike with a right click action on a toolbox and a couple other neat deployables.

Really, it can be used to deploy **just about anything**. See the [configuration](#configuration) section below.

For more samples of what it can do, check out this [gallery on imgur](http://imgur.com/a/jH8Lw "imgur gallery")

-----

####Table of Contents

* [Features](#features)
* [Planned](#planned)
* [Installation](#installation)
* [Configuration](#configuration)
* [Frequently Asked Questions](#faq)
* [Change Log](#change-log)

-----

####Features

* deploy cars/vehicles/props
* optional database saving
* Epoch building system
* optional part requirements
* configurable repacking for each object based on damage limit/owner/etc
* optional plot requirements for each item
* optionally require nearby items like epoch (fire/fueltank/workshop)

-----

####Planned
* even better positioning when deploying
* possible ui overhaul

-----

####Installation

 1. [download the files](https://github.com/mudzereli/DayZEpochDeployableBike/archive/master.zip "download files")
 2. extract the **addons** and **overwrites** folder from the downloaded zip file into **your mission file root**
 3. find this line in your mission file **init.sqf** (**warning**: if you have a custom compiles file, find that line instead of the one below!)
   * ```call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";```
 4. place this line directly after the line you found
   * ```call compile preprocessFileLineNumbers "addons\bike\init.sqf";```
 4. edit **addons\bike\config.sqf** to change some options or add different deployables ([see configuration section for more info](#configuration))

#####Warning:
- due to the way the way arma handles numbers and the way addon is coded, using the save-to-database option may not allow you to re-pack some objects if you have Character ID's over 500,000 (which I don't think will be an issue for 99.99% of people). 

-----

####Configuration

This addon is highly configurable, you can deploy just about anything, not just bikes. 

open **addons\bike\config.sqf** and edit the array.

#####DZE_DEPLOYABLES_CONFIG array

format (note no comma after last array entry)
```
 DZE_DEPLOYABLES_CONFIG = [
     [_clickItem,_deployOffset,_packDistance,_damageLimit,_packAny,_cargo,_ammo,_hive,_plot,_simulation,_road,_deployables,_near,_parts,_condition],
     [_clickItem,_deployOffset,_packDistance,_damageLimit,_packAny,_cargo,_ammo,_hive,_plot,_simulation,_road,_deployables,_near,_parts,_condition],
     [...more stuff here...]
 ];
```

array parameters

 parameter    | description                                                         |  type  | example
--------------|---------------------------------------------------------------------|--------|--------
_clickItem    | class name of the item to click on                                  | string | "ItemToolbox"
_deployOffset | [_side,_front,_up] array to offset the deployable when buiding      | array  | [0,2,1]
_packDistance | how close does the packer need to be to pack the object?            | number | 5
_damageLimit  | item can't be repacked if damage is > this. (-1 = no re-packing)    | number | 0.1
_packAny      | can anyone repack the deployable?                                   | bool   | false
_cargo        | clear the cargo of the deployable?                                  | bool   | false
_ammo         | should vehicle ammo be cleared? (does not persist through restart)  | bool   | true
_hive         | write deployable to database?                                       | bool   | false
_plot         | require a plot from the owner to build the deployable?              | bool   | false
_simulation   | enable simulation (movement/damage) for the object? (true for cars) | bool   | true
_road         | enable road building for this object?                               | bool   | true
_deployables  | array of class names that can be deployed with this method          | array  | ["MMT_Civ"]
_near         | array of items required nearby to build (workshop/fire/fueltank)    | array  | []
_parts        | array of parts required to build (will be taken from player)        | array  | ["ItemToolbox"]
_condition    | string of code to evaluate to determine whether action is shown     | string | "!(isNull player) && {(getPlayerUID player) in DZE_DEPLOYABLE_ADMINS}"

#####DZE_DEPLOYABLE_NAME_MAP array
 
format (note no comma after last array entry)

```
 DZE_DEPLOYABLE_NAME_MAP = [
     [_class,_name],
     [_class,_name],
     [... more ...]
 ];
 ```
 array parameters
 
 parameter    | description                                                         |  type  | example
--------------|---------------------------------------------------------------------|--------|--------
_class        | class name of the item you want to replace the name of              | string | "Notebook"
_name         | new name to display when right clicking                             | string | "Macbook Pro"

-----

####FAQ

1) People are getting kicked for createvehicle restriction when building things, what do I do?

Either edit the config file and change the items that are built, or open your battleye filter **createvehicle.txt** and find the associated line and add an entry for the building.

**Example for adding the Stone Wall that is deployed from the E-Tool (the class names can be found in the config)**
>
> open createvehicle.txt
>
> find this
>
> ```5 "Fort_" !="Fort_RazorWire" !="Fort_RazorWirePreview"```
>
> change it to to this:
>
> ```5 "Fort_" !="Fort_RazorWire" !="Fort_RazorWirePreview" != "Fort_StoneWall_EP1"```

-----

####Change Log

version | change
--------|-------
 2.8.2  | updates for Epoch Mod 1.0.6. **Thanks @ebaydayz!**
 2.8.1  | fix from SchwEde that should fix bike not moving. **Thanks SchwEde!!!**
 2.8.0  | option to clear vehicle ammo
 2.7.1  | better exit reasons
 2.7.0  | option to add condition for showing action in config
 2.6.1  | fix for unrideable bikes
 2.6.0  | road building options, deployable name mapping
 2.5.1  | fix bug where preview item could sometimes disappear before building
 2.5.0  | now uses a modified epoch building system to deploy the objects
 2.4.3  | better click actions build conflict detection
 2.4.2  | updated for new click actions handler build
 2.4.1  | fixed deployables spawning in locked after restart
 2.4.0  | multi-part deployables. yay!
 2.3.1  | big fix on packing temp objects
 2.3.0  | optional saving to database with post-restart memory of deployed items (see warning below about this) <br> configurable damage limits on re-packing <br> admin list for packing/deploying instantly & being able to remove all deployables
 2.2.1  | positioning fix for deployed items
 2.2.0  | option for clearing cargo of spawned items
 2.1.0  | change way dependency call is made, only one line needed in init.sqf now for setup
 2.0.0  | major update, allow multiple deployables, pretty much any class
 1.1.0  | configuration options / code optimization
 1.0.0  | release
