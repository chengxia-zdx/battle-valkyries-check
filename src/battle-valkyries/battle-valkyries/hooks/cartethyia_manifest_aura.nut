::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onUpdate = @(__original) function()
	{
		local ret = __original();
		try
		{
			::$bvvar{namespace}.updateActiveCartethyiaManifestAura();
		}
		catch (e)
		{
			::$bvvar{namespace}.logCartethyiaManifestAura("tactical-update-exception", null, "reason=" + e);
		}
		return ret;
	}
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		::$bvvar{namespace}.stopCartethyiaManifestAura(this, "death");
		return __original(_killer, _skill, _tile, _fatalityType);
	}
});

::$bvvar{namespace}.logCartethyiaManifestAura("hook-installed", null, "target=tactical_state.onUpdate");
