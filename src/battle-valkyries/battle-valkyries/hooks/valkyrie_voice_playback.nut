::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		local bv = ::$bvvar{namespace};
		if (!bv.VoiceRuntime.Active || !bv.isValkyrieVoiceActor(this)) return __original(_attacker, _skill, _hitInfo);
		local state = bv.getValkyrieVoiceState(this);
		local before = this.getHitpoints();
		state.DamageDepth++;
		local ret;
		try { ret = __original(_attacker, _skill, _hitInfo); }
		catch (e) { state.DamageDepth--; throw e; }
		state.DamageDepth--;
		if (state.DamageDepth == 0)
		{
			try { bv.onValkyrieVoiceDamage(this, before); }
			catch (e) { ::logWarning("[Battle Valkyries] Voice damage feedback failed: " + e); }
		}
		return ret;
	}
});

// Observe the actual result, never call the survival roll a second time.
::$bvvar{namespace}.MH.hookTree("scripts/entity/tactical/human", function(q) {
	q.isReallyKilled = @(__original) function( _fatalityType )
	{
		local ret = __original(_fatalityType);
		if (::$bvvar{namespace}.isValkyrieVoiceActor(this))
			::$bvvar{namespace}.getValkyrieVoiceState(this).ReallyDead = ret;
		return ret;
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieVoices(true);
		return __original();
	}
	q.onFinish = @(__original) function()
	{
		local bv = ::$bvvar{namespace};
		try
		{
			foreach (actor in bv.getValkyrieActors())
			{
				local id = actor.getID();
				if (id in bv.VoiceRuntime.Actors && bv.VoiceRuntime.Actors[id].WasHurt
					&& bv.playValkyrieVoiceSafe(actor, "recovery", ::Const.Sound.Volume.Actor)) break;
			}
		}
		catch (e) { ::logWarning("[Battle Valkyries] Voice recovery feedback failed: " + e); }
		bv.resetValkyrieVoices(false);
		return __original();
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.resetValkyrieVoices(false);
		return __original(_in);
	}
});
