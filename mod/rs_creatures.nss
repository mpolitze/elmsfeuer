//rs_creatures
#include "rs_include"
void main()
{
    //SpawnScriptDebugger();
    object oWP = GetLocalObject(OBJECT_SELF, "WP");
    int x;
    int iNumCMin = RS_GetNumToSpawnMin(oWP);
    int iNumCMax = RS_GetNumToSpawnMax(oWP)+1;
    int iNumCreatures = Random(iNumCMax - iNumCMin) + iNumCMin;
    int iNumCSpawned = RS_GetNumCreaturesSpawned(oWP);
    float fDelay = IntToFloat(d100())/100; //0.01 - 1.0

    //Added Percent chance to spawn critters.
    float fPercent = GetLocalFloat(OBJECT_SELF, RS_PERCENT_CHANCE_TO_SPAWN);
    fPercent = (fPercent == 0.0 ? 100.0 : fPercent);  //backwards compatability, if you set it to 0.0, what is the point of setting up the spawn point?
    int bPercent = ((IntToFloat(Random(1001))/10 <= fPercent) ? TRUE : FALSE);

    iNumCreatures = iNumCreatures - iNumCSpawned;

    int iMaxSpawn = GetLocalInt(oWP, RS_MAX_SPAWN);
    if(iMaxSpawn != 0) SetLocalInt(oWP, "LimitedSpawn", 1);
    int iLimit = GetLocalInt(oWP, "LimitedSpawn");
    if(iLimit == 1)
    {
        if(iMaxSpawn == -1) iMaxSpawn = d100() * d10(); //random amount 1-1000
        iMaxSpawn -= iNumCreatures;
        if(iMaxSpawn <= 0)//we have spawned the max possible
        {
            iNumCreatures += iMaxSpawn; //do not spawn too many.
            iMaxSpawn = 0;
        }
        SetLocalInt(oWP, RS_MAX_SPAWN, iMaxSpawn);
    }
    int bSpawnable = RS_GetSpawnable(oWP);
    if(!bSpawnable) if(RS_DESPAWN_CREATURES) RS_Despawn(oWP);

    if(bPercent)for(x=0;x<iNumCreatures;x++)DelayCommand(fDelay, RS_SpawnCreatures(oWP));
    DelayCommand(fDelay, RS_SetNextSpawnTimeLeft(oWP));
    if(iMaxSpawn == 0 && iLimit == 1) DelayCommand(fDelay*2, DestroyObject(oWP));
    DelayCommand(fDelay*2.5, DestroyObject(OBJECT_SELF));//delete spawner
}
