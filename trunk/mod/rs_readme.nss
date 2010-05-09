/* respawn readme.

AmanShadar's Spawn System 2.1

I built this set of scripts as I was unhappy with the respawn options from
other systems. It involves few scripts (4) and can give you varying spawns
from one waypoint, and can also add items to the creatures spawned.

Version 1.1:
added PC level adjustments to level of creatures.
added null appearance, blank script creature to verify locations

Version 1.2:
added ability to spawn within a min to max distance from waypoints
added ability to spawn multiple placeables from one waypoint

Version 1.2a
fixed a bug with the placeables not spawning correctly

Version 1.3
added abillity to spawn at different times of day

Version 1.3a
fixed a bug in the level choosing function
fixed ability to override all settings and spawn creatures at defualt HD,
even if other settings would have changed it.

Version 1.4
added percentage to drop items. (ItemX Drop variable, see readme)
added options for creatures actions after they are spawned

Version 1.5
added ability to add variables to creatures/placeables
changed min creatures/placeables spawned from 1 to 0, for chance encounters

Version 1.6
added option for a maximun number of spawns from a waypoint
i.e. an army that runs out of reinforcements

Version 1.6a
fixed a major bug that stopped backwards compatability as well as default spawns
from spawning due to spawn limit feature introduced in version 1.6

Version 1.7
added cleanup options. Set in rs_include. Defaults are: cleans up creatures
and placeables spawned by system, as well as any items found.

Version 2.0
Added trap and item spawning
fixed several small bugs
made code more efficient

Version 2.1
Added despawn as standard feature
fixed placeable spawning (note, placeable spawning is still in beta)
You will have to add variables using the spawn waypoints to custom placeables,
as they can not be copied from custom placeables.
Also, any script you want to run in the placeable events will have to be set on
the resref of the item as those things also cannot be copied from custom placeables.

////////////////////////////////////////////////////////////////  Setup  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

rs_init
    Add rs_init into the module load event, however that may be for your setup.
    in the case of a default module just make a script called module_load and add
    lines stating:

    void main()
    {
        ExecuteScript("rs_init_c", OBJECT_SELF);
        ExecuteScript("x2_mod_def_load", OBJECT_SELF);
    }

    or add the line:
    ExecuteScript("rs_init_c", OBJECT_SELF);
    to your existing module load script.

    if you use HCR2 add the variable
    OnModuleLoadX       string          rs_init_c
    where X = the next available position

rs_onarea_enter
    Put rs_onarea_enter on any area that has the spawnpoints to spawn
    or add the following line to your existing on area enter script:

    ExecuteScript("rs_onarea_enter", OBJECT_SELF);

    if you use HCR2, add area variable
    OnAreaEnterX        string          rs_onarea_enter
    where X = the next available position

Place Vault             Waypoints / Custom / Waypoints / RS_WAYPOINT_VAULT
    Place a RS_WAYPOINT_VAULT waypoint, located in waypoints / custom  / waypoints
    ONLY PLACE ONE OF THESE IN THE ENTIRE MODULE
    can be placed anywhere. It holds some information for the sytem when it's running.

Place Spawnpoints       Waypoints / Custom / Waypoints / RS_*_RESREF

    Add the RS_*_RESREF waypoints to where you want them and change the
    name, not the tag, to the creature/placeable/item resref of what you wish to spawn.
    or set the name to the tag of the area containing the creatures/placeable/traps/items you wish to spawn.
    You can place different types in one area, (i.e. have creatures and placeables and traps and items in one area to spawn from)

Change the variable on the Waypoints to the values you wish and enjoy your creations.

If you want to add items to creatures or placeables, add variables named ItemX where X is the next available number
Item1 is already on the waypoints for the first item. That value should be the
resref of the item you wish to give them.

ItemDrop is to set the droppable percentage of the item.
If you do not want the item to be droppable (dropped when creature dies) set this to 0.
default = 100   (is 100% droppable)

If items are added to creatures via the creature spawnpoints, the creatures will try to equip them.
if Items are added to creatures via the Item spawnpoints, the creatures may or may not equip them, depending on the AI used.

Variables on spawnpoints:

Script To Run On Spawn
    Script name to run after the creature/placeable/trap/item has spawned.
    OBJECT_SELF in the script will be the creature/placeable/trap/item

ItemX
ItemX Drop:
    the Item resref of an item you wish to have created on the creature.
    Drop is for the percentage chance the item is droppable.
    -2- and 0 = not droppable
    -1 = random percentage (0-100)
    1+ = percentage chance to drop
    anything above 100 will be set to 100 anyway (always droppable)

Stats work similarly, as StatChange1 is already there.
Stats are set as follows.
StatChange1 =
    -1 = random
    0 = None
    1 = Strength
    2 = Dexterity
    3 = Constitution
    4 = Intelligence
    5 = Wisdom
    6 = Charisma

StatChangeVar1Min
StatChangeVar1Max = n  n = the amount by which you wish to adjust the stat1 by.

example.
    StatChange1         2
    StatChangeVar1Min   2
    StatChangeVar1Max   4
        would give a bonus of 2 to 4 to the Dexterity of every creature spawned from this point.

Level Min
    If it is set to 0 no change to the creature will be made, unless SOFT or HARD
    level setting are used.
    if you want to spawn a creature at it's default resref HD while using SOFT or HARD PC LEvel settings
    set min and max to less than -1. (i.e. -2, -3, -4, etc...) it will not matter, as it will just force
    the system to make no change to the creature's HD.
    Level Max can be whatever above Level Min.
    if you scre w up and have a lower Max, than Min, the system will swap them.

Level Max Values:
    -2- = Sets creature to resref default Hit Dice
    -1 = Random 1-40 (can be dangerous to use)
    1+ = level set to this amount.

Respawn Max Values:
    -1 = Random d100  1-100 cycles
    0 = None (can respawn immediately)
    1+= number of cycles between respawns.

Creatures/Placeables/Traps/Items Max Values:
    -1 = Random 1-20 (can be dangerous to use for creatures)
    0+ = number of creatures/placeables/traps/items to have spawned in the area at a time

Area Spawn:
    0 = spawn at location of waypoint
    1 = Spawn randomly throughout area, out of sight of PC if possible
            or within min to max distance.

Distance Min:
    Make sure to set Area Spawn to 1 if you use these.
        0- = no minimum distance (can spawn on spawnpoint)
        1+ = distance from spawnpoint that will not spawn creatures/placeables/traps/items
Distance Max:
    Make sure to set Area Spawn to 1 if you use these.
        0- = no max distance (area wide)
        1+ = up to n distance from spawnpoint that will spawn creatures/placeables/traps/items

Time of Day: 0000
    0000 = all time spawn
    1000 = Dawn Spawn only
    0100 = Day Spawn Only
    0010 = Dusk Spawn only
    0001 = Night Spawn only
    Binary code for time of day spawns. However, 1 = 01 = 001, so for night
    spawns, a value of 1 works.
    11 will spawn at dusk and night.
    0000 and 1111 will spawn at all times.
    if you want to spawn at just dusk and dawn use 1010.
    just night and day use 0101 or 101, etc...

Action
    default and anything not 1-4 or -1 = Random Walk
    -1 = Random choice made
    1 = Random Walk
    2 = Walk Waypoints
    3 = Attack nearest PC
    4 = Do nothing

IntX:
StringX:
FloatX:
    Names of variables to add to creatures/placeables when spawned.
    X = next available number for that variable type.

    IntValX:
    StringValX:
    FloatValX:
            Value of variables.

If you want to add two int variables named "Trash" and "Wandering" with
values of 1 and a float variable named "Interval" with a value of 3.5
you would use:

Int1        Trash
IntVal1     1
Int2        Wandering
IntVal2     1
Float1      Interval
FloatVal1   3.5

Max Number of Spawns:
    -1 = Random (d100 * d10) (10-1000)
    0  = No limit (will always spawn)
    1+ = when this waypoint has spawned this many creatures/placeables/traps/items
               it will be deleted, and therefore spawn no more.

New Name of Creature
    Put  "random" to get a random name for that creature
    You can also put "random" for placeables, traps, and items, but currently
    there is no system for creating random names for those objects.
    However, if you would like to add code for that open "rs_include",
    do a search for RS_RandomName and you will see a section that you can add your
    code for random names for other objects.

Trap Strength
    -1 = random (0-3)
    0 = minor       |  Epic Electrical
    1 = average     |  Epic Fire
    2 = strong      |  Epic Frost
    3 = deadly      |  Epic Sonic
Trap Element
    -1 = random  (0-10) //if you want epic, state it manually
    0 = Spike
    1 = Holy
    2 = Tangle
    3 = Acid
    4 = Fire
    5 = Electrical
    6 = Gas
    7 = Frost
    8 = Negative
    9 = Sonic
    10 = Acid Splash
    11 = Epic
    For random epic you would set element to 11 and strength to -1
Since the epic versions were added on later, they come with different numbers
Basically what this does is get the trap_base_type using a formula
(Element * 4) + strength
so if you have added to the traps.2da, you can get your custom traps as well.

KeyTag
    Tag of key to disarm this trap

Trap Random Object
    0 = No used
    1 = Choose a random object in the area to trap
    If all placeables and doors have been trapped, then the remaining traps will be spawned at random locations.

Container Tag
    Tag of container or creature to spawn item on.

Item on Random Object
    0 = Item spawned at location or in object tagged Container Tag. see above
    1 = Choose a random object in area to spawn items on.

Percent Chance on Creature
Percent Chance on Placeable
    Only used if Item on Random Object is set to 1
    this will be the percentage chance the item is spawned on that type of object.
    if creature percentage + placeable percentage is less than or equal to 100
    then one check is made to find the container, if neither pass, then it is spawned
    at a random location or in the object tagged Container Tag
    Otherwise, it will check individually for the percentages, and again if both fail, will
    spawn at location or in the object tagged Container Tag

example:
    Percent Chance on Creature = 33
    Percent Chance on Placeable = 33
    Container Tag = LootStoreChest
    if the d100 comes up 1-33, the item will spawn on a creature in the area
    if the d100 comes up 34-66, the item will spawn on a placeable in the area
    if the d100 comes up 67-100, the item will spawn at the location of the spawnpoint
        or a random location if area item is used.

Most other variables should be self explanatory.
If I missed any, or you are confused on anything else, post on the forums at NWN Vault or
http://LostBoysLRRP.150m.com under the NWN section.

