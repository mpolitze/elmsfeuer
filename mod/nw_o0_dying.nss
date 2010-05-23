//------------------------------------------------------------------------------
// == On Player Dying Script ==
// Created: 09.05.2010 by MP
//------------------------------------------------------------------------------

void bleed(object oPC, int iDueHP){
    int iActualHP = GetCurrentHitPoints(oPC);

    if(iActualHP > 0){
        SetLocalInt(oPC,"ELM_PC_DIED",0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
        return;
    }

    if(iDueHP > iActualHP){
        effect eModHP =  EffectDamage(iDueHP-iActualHP+1, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eModHP, oPC);
        iActualHP = GetCurrentHitPoints(oPC);
    }

    if(iActualHP > -9){
        FloatingTextStringOnCreature("Verbluten: " + IntToString(-iDueHP) + "(" + IntToString(-iActualHP) + ")/9", oPC);
        effect eModHP =  EffectDamage(1, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eModHP, oPC);
        iDueHP = iActualHP-1;
        DelayCommand(RoundsToSeconds(1), bleed(oPC, iDueHP));
    }
    else
    {
        int nRnd = Random(GetHitDice(oPC));
        if(nRnd == 0)
        {
            FloatingTextStringOnCreature("Stabilisiert!", oPC);
            effect eHeal =  EffectHeal(11);

            effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            effect eDaze = EffectDazed();
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

            effect eLink = EffectLinkEffects(eMind, eDaze);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(3));

            SetLocalInt(oPC,"ELM_PC_DIED",0);
        }
        else
        {
            FloatingTextStringOnCreature("Verblutet!", oPC);
            SetLocalInt(oPC,"ELM_PC_DIED",1);
            effect eDeath = EffectDeath();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
        }
    }
}

void main()
{
    object oPC = GetLastPlayerDying();
    int iHP = GetCurrentHitPoints(oPC);
    effect eHeal = EffectHeal(-iHP);
    effect eSanct = EffectSanctuary(100);

    FloatingTextStringOnCreature("Ausser Gefecht!", oPC);



    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanct, oPC, RoundsToSeconds(2));

    if(GetLocalInt(oPC,"ELM_PC_DIED") == 0){
        SetLocalInt(oPC,"ELM_PC_DIED",-1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
        DelayCommand(RoundsToSeconds(1), bleed(oPC, -1));
    }
}
