void main()
{
    if(GetIsOpen(OBJECT_SELF)){
        AssignCommand(GetLastUsedBy(),
            ActionJumpToObject(GetObjectByTag("dj02_wp_kanaIn")));

   /*     JumpToObject(GetWaypointByTag("dj02_wp_kanaIn"));
        ActionJumpToObject(GetWaypointByTag("dj02_wp_kanaIn"));

ActionJumpToObject(GetObjectByTag("dj02_wp_kanaIn"));
  ActionJumpToObject(GetNearestObjectByTag("dj02_wp_kanaIn"));  */
    }

    ExecuteScript("crpp_secdoor_use",OBJECT_SELF);
}
