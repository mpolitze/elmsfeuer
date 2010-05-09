//rs_spawn
//script that is run on the spawn waypoints
#include "rs_include"
void main()
{
    //SpawnScriptDebugger();
    int iPC = 0;
    float fDelay = RS_DELAY_CYCLE;
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC) && iPC < 1)    //any pc's in here? just need 1
    {
        if(GetArea(oPC) == OBJECT_SELF && !GetIsDM(oPC)) iPC++;
        oPC = GetNextPC();
    }
    int x = 0;        //counter for cycling through the waypoints
    object oCWP = GetObjectByTag(RS_CREATURE_WAYPOINT,x);
    object oPWP = GetObjectByTag(RS_PLACEABLE_WAYPOINT,x);
    object oTWP = GetObjectByTag(RS_TRAP_WAYPOINT,x);
    object oIWP = GetObjectByTag(RS_ITEM_WAYPOINT,x);
    int iTime;
    object oArea;

//set up seperate 'while' loops to spawn in order.
//creatures will spawn first, then placeables, then traps, then items.
//that way, traps and items can be spawned in/on placeables/creatures spawned.
    if(iPC >= 1)              //if PC's found, then spawn, and set to run again
    {
        DelayCommand(fDelay, ExecuteScript("rs_spawn",OBJECT_SELF));//placed here to continue running even if TMI gets encountered from spawning too many spawns
        SetLocalInt(OBJECT_SELF, "Running", 1);

        //cycle through the waypoints and spawn
        while(GetIsObjectValid(oCWP))
        {
            oArea = GetArea(oCWP);
            if (oArea == OBJECT_SELF)
            {
                RS_DecrementSpawnTime(oCWP);
                iTime = RS_GetNextSpawnTimeLeft(oCWP);
                if (iTime <= 0)
                {
                    object oCSO = CreateObject(OBJECT_TYPE_PLACEABLE, "rs_spawner", GetLocation(oCWP));
                    SetLocalObject(oCSO, "WP", oCWP);
                    DelayCommand(fDelay/100, ExecuteScript("rs_creatures", oCSO));
                }
            }
            x++;
            oCWP = GetObjectByTag(RS_CREATURE_WAYPOINT,x);
        }
        x=0;

        while(GetIsObjectValid(oPWP))
        {
            oArea = GetArea(oPWP);
            if (oArea == OBJECT_SELF)
            {
                RS_DecrementSpawnTime(oPWP);
                iTime = RS_GetNextSpawnTimeLeft(oPWP);
                if (iTime <= 0)
                {
                    object oPSO = CreateObject(OBJECT_TYPE_PLACEABLE, "rs_spawner", GetLocation(oPWP));
                    SetLocalObject(oPSO, "WP", oPWP);
                    DelayCommand(fDelay/100, ExecuteScript("rs_placeables", oPSO));
                }
            }
            x++;
            oPWP = GetObjectByTag(RS_PLACEABLE_WAYPOINT, x);
        }
        x=0;

        while(GetIsObjectValid(oTWP))
        {
            oArea = GetArea(oTWP);
            if (oArea == OBJECT_SELF)
            {
                RS_DecrementSpawnTime(oTWP);
                iTime = RS_GetNextSpawnTimeLeft(oTWP);
                if (iTime <= 0 && GetLocalInt(oTWP, "Activated") == 0)
                {
                    object oTSO = CreateObject(OBJECT_TYPE_PLACEABLE, "rs_spawner", GetLocation(oTWP));
                    SetLocalObject(oTSO, "WP", oTWP);
                    DelayCommand(fDelay/25, ExecuteScript("rs_traps", oTSO));
                }
            }
            x++;
            oTWP = GetObjectByTag(RS_TRAP_WAYPOINT,x);
        }
        x=0;

        while(GetIsObjectValid(oIWP))
        {
            oArea = GetArea(oIWP);
            if (oArea == OBJECT_SELF)
            {
                RS_DecrementSpawnTime(oIWP);
                iTime = RS_GetNextSpawnTimeLeft(oIWP);
                if (iTime <= 0 && GetLocalInt(oIWP, "Activated") == 0)
                {
                    object oISO = CreateObject(OBJECT_TYPE_PLACEABLE, "rs_spawner", GetLocation(oIWP));
                    SetLocalObject(oISO, "WP", oIWP);
                    DelayCommand(fDelay/25, ExecuteScript("rs_items", oISO));
                }
            }
            x++;
            oIWP = GetObjectByTag(RS_ITEM_WAYPOINT, x);
        }
    }
    else
    {
        DeleteLocalInt(OBJECT_SELF, "Running");     //if not, stop spawning.
        if(RS_DESTROY_ON_EXIT)
        {
            //Run the cleaner
            RS_Clear_Spawns(OBJECT_SELF);

            //reset the local spawn times.
            while(GetIsObjectValid(oCWP)
                    || GetIsObjectValid(oPWP)
                    || GetIsObjectValid(oTWP)
                    || GetIsObjectValid(oIWP)
                    ) //cycle through the waypoints and reset spawn time
            {
                if(GetIsObjectValid(oCWP))
                {
                    oArea = GetArea(oCWP);
                    if (oArea == OBJECT_SELF) SetLocalInt(oCWP, "SpawnTime", 0);
                }

                if(GetIsObjectValid(oPWP))
                {
                    oArea = GetArea(oPWP);
                    if (oArea == OBJECT_SELF) SetLocalInt(oPWP, "SpawnTime", 0);
                }

                if(GetIsObjectValid(oTWP))
                {
                    oArea = GetArea(oTWP);
                    if (oArea == OBJECT_SELF)
                    {
                        SetLocalInt(oTWP, "SpawnTime", 0);
                        DeleteLocalInt(oTWP, "Activated");
                    }
                }
                if(GetIsObjectValid(oIWP))
                {
                    oArea = GetArea(oIWP);
                    if (oArea == OBJECT_SELF)
                    {
                        SetLocalInt(oIWP, "SpawnTime", 0);
                        DeleteLocalInt(oIWP, "Activated");
                    }
                }
                oCWP = GetObjectByTag(RS_CREATURE_WAYPOINT,x);
                oPWP = GetObjectByTag(RS_PLACEABLE_WAYPOINT, x);
                oTWP = GetObjectByTag(RS_CREATURE_WAYPOINT,x);
                oIWP = GetObjectByTag(RS_PLACEABLE_WAYPOINT, x);
                x++;
            }
        }
    }
}
