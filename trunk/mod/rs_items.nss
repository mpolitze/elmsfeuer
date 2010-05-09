//rs_items
#include "rs_include"
void main()
{
    //SpawnScriptDebugger();
    object oWP = GetLocalObject(OBJECT_SELF, "WP");
    int iNumItemsSpawned = RS_GetItemsSpawned(oWP);
    int iNumToSpawnMax = RS_GetNumToSpawnMax(oWP);
    int iNumToSpawnMin = RS_GetNumToSpawnMin(oWP);
    int iNumToSpawn;
    int x;
    float fDelay = IntToFloat(d100())/100; //0.01 - 1.0

    iNumToSpawn = Random(iNumToSpawnMax - iNumToSpawnMin) + iNumToSpawnMin;
    iNumToSpawn = iNumToSpawn - iNumItemsSpawned;

    int iMaxSpawn = GetLocalInt(oWP, RS_MAX_SPAWN);
    if(iMaxSpawn != 0) SetLocalInt(oWP, "LimitedSpawn", 1);
    int iLimit = GetLocalInt(oWP, "LimitedSpawn");
    if(iLimit == 1)
    {
        if(iMaxSpawn == -1) iMaxSpawn = d100() * d10(); //random amount 1-1000
        iMaxSpawn -= iNumToSpawn;
        if(iMaxSpawn <= 0)//we have spawned the max possible
        {
            iNumToSpawn += iMaxSpawn; //do not spawn too many.
            iMaxSpawn = 0;
        }
        SetLocalInt(oWP, RS_MAX_SPAWN, iMaxSpawn);
    }

    //SpawnScriptDebugger();
    for(x=1;x<=iNumToSpawn;x++) DelayCommand(fDelay, RS_SpawnItems(oWP));

    //deactivate till PC's leave. We don't want items randomly apearing while
    //PC's are already in the area.
    //Toggle in rs_include
    if(!RS_ITEM_SPAWN_WITH_PC_IN_AREA) SetLocalInt(oWP, "Activated", 1);

    int bSpawnable = RS_GetSpawnable(oWP);
    if(!bSpawnable) if(RS_DESPAWN_PLACEABLES) RS_Despawn(oWP);

    DelayCommand(fDelay, RS_SetNextSpawnTimeLeft(oWP));
    if(iMaxSpawn == 0 && iLimit == 1) DelayCommand(fDelay*2, DestroyObject(oWP));
    DelayCommand(fDelay*2.5, DestroyObject(OBJECT_SELF));//delete spawner
}
