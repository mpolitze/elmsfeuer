//Spawn zu 75% einen Zombie beim Oeffnen eines Sargs
//Respawn nach 20 Minuten

void main()
{
    if(!GetIsOpen(OBJECT_SELF))
    {
        PlayAnimation(ANIMATION_PLACEABLE_OPEN);
        location lSelf=GetLocation(OBJECT_SELF);

        int iProp=d4();
        if(iProp>2)
            CreateObject(OBJECT_TYPE_CREATURE,"nw_zombie01",lSelf,FALSE);
        else if(iProp==2)
            CreateObject(OBJECT_TYPE_CREATURE,"dj03_gespenst",lSelf,TRUE);
    }

    DelayCommand(1200.,PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
}
