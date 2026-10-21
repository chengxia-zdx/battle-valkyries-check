// Keep temporary enemy control outside roster/inventory UI and restore original
// faction/AI before vanilla combat-finish or retreat code enumerates factions.

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.showCharacterScreen = @(__original) function( _forced = false )
	{
		// Vanilla tactical character data enumerates the whole Player faction.
		// While a controlled enemy is in that faction, block the screen entirely
		// instead of exposing the enemy to player-only UI conversion and actions.
		if (::$bvvar{namespace}.hasValkyrieTemporaryPlayerControls()) return;
		return __original(_forced);
	}

	q.tactical_flee_screen_onFleePressed = @(__original) function()
	{
		if (!::$bvvar{namespace}.resetValkyrieTemporaryPlayerControls("player_retreat_precheck")) return;
		return __original();
	}
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	q.checkCombatFinished = @(__original) function( _forceFinish = false )
	{
		local ready = _forceFinish
			? ::$bvvar{namespace}.resetValkyrieTemporaryPlayerControls("forced_combat_finish_precheck")
			: ::$bvvar{namespace}.releaseValkyrieTemporaryControlsIfLastHostile("combat_finish_precheck");
		if (!ready) return;
		return __original(_forceFinish);
	}

	q.makeAllHostilesRetreat = @(__original) function()
	{
		if (!::$bvvar{namespace}.resetValkyrieTemporaryPlayerControls("enemy_retreat_precheck")) return;
		return __original();
	}
});
