local previousSync = ::$bvvar{namespace}.syncActorSkills;
foreach(role, definition in ::$bvvar{namespace}.BlackBeastDefinitions)
{
    local stagesKey = "BlackBeastCorruptionStages_" + role, traitKey = "BlackBeastCorruptionTrait_" + role;
    ::$bvvar{namespace}[stagesKey] <- ::$bvvar{namespace}.BlackBeastCorruptionStages[role];
    ::$bvvar{namespace}[traitKey] <- "$bvvar{modId}.trait." + role + "_corruption";
    ::$bvvar{namespace}.ValkyrieNarrativeDetails[role] <- { Type = "corruption", StagesKey = stagesKey, TraitKey = traitKey, Description = "$bv{black_beast.corruption.description}" };
}
::$bvvar{namespace}.syncActorSkills = function(a, reason = "unknown")
{
    ::$bvvar{namespace}.BlackBeastCorruption.ensureTrait(a);
    local result=previousSync(a, reason);
    if(result.Success)::$bvvar{namespace}.BlackBeast.ensureInnateSkills(a);
    return result;
};
::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
    q.create = @(__original) function() { __original(); this.addSpecialEvent("event.battle_valkyries_black_beast_corruption"); }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
    q.onCombatStart = @(__original) function() { ::$bvvar{namespace}.BlackBeastCorruption.startCombat(this); return __original(); }
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
    q.onCombatFinished = @(__original) function()
    {
        local f = ::$bvvar{namespace}.BlackBeastCorruption;
        f.awardCombatCorruption(f.combatID() + 1);
        local result = __original(); f.finishCombat(); return result;
    }
});
