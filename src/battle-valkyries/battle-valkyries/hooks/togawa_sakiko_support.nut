::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onTurnStart = @(__original) function() {
		// Snapshot before another effect's onTurnStart/onTurnEnd changes phase.
		::$bvvar{namespace}.beginSakikoTurn(this);
		return __original();
	}
	q.onTurnResumed = @(__original) function() {
		if (::$bvvar{namespace}.sakikoHasConductor()) {
			local t = ::$bvvar{namespace}.sakikoTurn(this);
			t.Normal = !::$bvvar{namespace}.sakikoExtraTurn(this) && t.EndRound != ::$bvvar{namespace}.sakikoRound();
		}
		return __original();
	}
	q.onTurnEnd = @(__original) function() {
		::$bvvar{namespace}.endSakikoTurn(this);
		return __original();
	}
	q.onMovementFinish = @(__original) function(_tile) {
		local ret = __original(_tile);
		if (::$bvvar{namespace}.sakikoHasConductor()) ::$bvvar{namespace}.refreshSakikoRecipients();
		return ret;
	}
	q.onMovementUndo = @(__original) function(_tile, _levelDifference) {
		local ret = __original(_tile, _levelDifference);
		if (::$bvvar{namespace}.sakikoHasConductor()) ::$bvvar{namespace}.refreshSakikoRecipients();
		return ret;
	}
	q.onRemovedFromMap = @(__original) function() {
		local p = ::$bvvar{namespace}.getSakikoPassive(this);
		if (p != null) p.stop();
		local e = this.getSkills().getSkillByID(::$bvvar{namespace}.SakikoSupportID);
		if (e != null) e.removeSelf();
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onFinish = @(__original) function() {
		::$bvvar{namespace}.SakikoTurns = {};
		return __original();
	}
});
