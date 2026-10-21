// Register before C.C. and the damage-absorption wrappers. Their adjusted HP
// damage reaches this boundary before native callbacks and HP subtraction.
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
    q.onDamageReceived = @(__original) function(attacker, hp, armor)
    {
        local a = this.getActor();
        if (a != null && "BVSurvivalFrame" in a.m && a.m.BVSurvivalFrame != null)
            ::$bvvar{namespace}.BlackBeast.claimSurvival(a, hp, a.m.BVSurvivalFrame);
        return __original(attacker, hp, armor);
    }
});
