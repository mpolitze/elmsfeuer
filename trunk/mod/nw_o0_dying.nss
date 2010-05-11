//------------------------------------------------------------------------------
// == On Player Dying Script ==
// Created: 09.05.2010 by MP
//------------------------------------------------------------------------------

void bleed(object oPC, int iDueHP){
    iDueHP--;
    int iActualHP = GetCurrentHitPoints(oPC);

    if(iActualHP > 0){
        return;
    }

    if(iActualHP < iDueHP){
        effect eModHP =  EffectHeal(iDueHP-iActualHP);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eModHP, oPC);
    }
    else if(iDueHP < iActualHP){
        effect eModHP =  EffectDamage(iActualHP-iDueHP+1, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eModHP, oPC);
    }

    if(iDueHP < -9)
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

    SetLocalInt(oPC,"ELM_PC_DIED",0);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanct, oPC, RoundsToSeconds(2));

    DelayCommand(RoundsToSeconds(1), bleed(oPC, -1));
}
