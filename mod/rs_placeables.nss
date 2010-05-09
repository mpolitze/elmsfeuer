//rs_placeables
#include "rs_include"
void main()
{
    //SpawnScriptDebugger();
    object oWP = GetLocalObject(OBJECT_SELF, "WP");
    int iNumSpawned = RS_GetPlaceablesSpawned(oWP);
    int iNumPlaceables;
    int iNumPlaceablesMax = RS_GetNumToSpawnMax(oWP) + 1;
    int iNumPlaceablesMin = RS_GetNumToSpawnMin(oWP);
    int iAreaSpawn = GetLocalInt(oWP, RS_AREA_PLACEABLE);
    int iStatic = RS_GetStatic(oWP);
    int x;
    float fDelay = IntToFloat(d100())/100; //0.01 - 1.0

    iNumPlaceables = Random(iNumPlaceablesMax - iNumPlaceablesMin) + iNumPlaceablesMin;

    //spawn only one if not area spawn otherwise you get multiple placeables in one location
    if(!iAreaSpawn) iNumPlaceables = 1;

    iNumPlaceables -= iNumSpawned;

    int iMaxSpawn = GetLocalInt(oWP, RS_MAX_SPAWN);
    if(iMaxSpawn != 0) SetLocalInt(oWP, "LimitedSpawn", 1);
    int iLimit = GetLocalInt(oWP, "LimitedSpawn");
    if(iLimit == 1)
    {
        if(iMaxSpawn == -1) iMaxSpawn = d100() * d10(); //random amount 1-1000
        iMaxSpawn -= iNumPlaceables;
        if(iMaxSpawn <= 0)//we have spawned the max possible
        {
            iNumPlaceables += iMaxSpawn; //do not spawn too many.
            iMaxSpawn = 0;
        }
        SetLocalInt(oWP, RS_MAX_SPAWN, iMaxSpawn);
    }

    for(x=0;x<iNumPlaceables;x++) RS_SpawnPlaceables(oWP);

    int bSpawnable = RS_GetSpawnable(oWP);
    if(!bSpawnable) if(RS_DESPAWN_PLACEABLES) RS_Despawn(oWP);

    DelayCommand(fDelay, RS_SetNextSpawnTimeLeft(oWP));
    if(iStatic == 1) DelayCommand(fDelay, DestroyObject(oWP, RS_DELAY_CYCLE * 0.5)); //if static, take out WP so no more spawns and less cpu usage
    else if(iMaxSpawn == 0 && iLimit == 1) DelayCommand(fDelay*2, DestroyObject(oWP));
    DelayCommand(fDelay*2.5, DestroyObject(OBJECT_SELF));//delete spawner
}
