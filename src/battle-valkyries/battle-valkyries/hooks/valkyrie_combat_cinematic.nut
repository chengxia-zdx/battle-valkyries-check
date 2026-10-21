::$bvvar{namespace}.MH.hook("scripts/ui/screens/tactical/tactical_screen", function(q) {
	q.onBattleValkyrieCinematicPlaying <- function( _data )
	{
		local bv = ::$bvvar{namespace};
		if (_data == null || !("Token" in _data) || bv.CombatCinematic.Screen != this) return false;
		return bv.startValkyrieCombatCinematicAudio(_data.Token);
	}
	q.onBattleValkyrieCinematicFinished <- function( _data )
	{
		local runtime = ::$bvvar{namespace}.CombatCinematic;
		if (_data == null || !("Token" in _data) || runtime.Screen != this) return false;
		return ::$bvvar{namespace}.closeValkyrieCombatCinematic(_data.Token);
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieCombatCinematic();
		return __original();
	}
	q.onFinish = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieCombatCinematic();
		return __original();
	}
	q.onUpdate = @(__original) function()
	{
		local bv = ::$bvvar{namespace};
		if (bv.CombatCinematic.Active)
		{
			if (::Time.getRealTimeF() < bv.CombatCinematic.Deadline) return;
			bv.closeValkyrieCombatCinematic();
		}
		return __original();
	}
	// Own a separate input gate; never overwrite another mod's pause/busy flags.
	q.isInputLocked = @(__original) function()
	{
		return ::$bvvar{namespace}.CombatCinematic.Active || __original();
	}
	q.onKeyInput = @(__original) function( _key )
	{
		if (::$bvvar{namespace}.CombatCinematic.Active) return true;
		return __original(_key);
	}
	q.onMouseInput = @(__original) function( _mouse )
	{
		if (::$bvvar{namespace}.CombatCinematic.Active) return true;
		return __original(_mouse);
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.resetValkyrieCombatCinematic();
		return __original(_in);
	}
});
