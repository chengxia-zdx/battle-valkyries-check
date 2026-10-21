// Reuse the shared normal-turn clock; waiting and granted turns do not advance it.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
    q.retreat = @(__original) function()
    {
        local h = ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(this);
        if (h != null && "Olga" in h) return;
        return __original();
    }
    q.onTurnEnd = @(__original) function()
    {
        local f = ::$bvvar{namespace}.Olga, before = f.clock(this).Ends;
        local result = __original();
        if (f.clock(this).Ends > before) f.endNormalTurn(this);
        return result;
    }
    q.onTurnStart = @(__original) function()
    {
        local result = __original();
        if (this.getSkills().hasSkill("$bvvar{modId}.effects.olga_stun")) this.setActionPoints(0);
        ::$bvvar{namespace}.Olga.maintainControls();
        return result;
    }
    q.kill = @(__original) function(killer = null, skill = null, fatality = ::Const.FatalityType.None, silent = false)
    {
        // Restore before vanilla chooses player/enemy death, loot and roster paths.
        ::$bvvar{namespace}.Olga.releaseActor(this);
        local result = __original(killer, skill, fatality, silent);
        ::$bvvar{namespace}.Olga.maintainControls();
        return result;
    }
});

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
    q.tactical_flee_screen_onFleePressed = @(__original) function()
    {
        local active = ::Tactical.TurnSequenceBar.getActiveEntity();
        local h = ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(active);
        if (h != null && "Olga" in h) return;
        return __original();
    }
});
