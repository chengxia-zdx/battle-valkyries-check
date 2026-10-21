::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onSerialize = @(__original) function( _out )
	{
		// Migrate a skin selected before the persistent skin flag was introduced.
		// The runtime trait is deliberately not serialized, so capture it first.
		::$bvvar{namespace}.persistActorValkyrieSkinTrait(this);
		return __original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		// Battle-only transformations are deliberately nonserialized. A tactical
		// save may retain the visual flag, while its runtime effect is absent after
		// load; clear that stale flag before rehydrating persistent Valkyrie skills.
		if ("clearActorTemporaryValkyrieSkin" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(this);
		}

		::$bvvar{namespace}.applyValkyrieIdentityMetadata(this);
		::$bvvar{namespace}.syncActorSkills(this, "player.onDeserialize");

		// Rebuild from the persisted skin identity, not only from ValkyrieIDFlag:
		// ordinary mercenaries may legitimately wear a Valkyrie skin item.
		local template = ::$bvvar{namespace}.getActorValkyrieSkinTemplate(this);
		if (::$bvvar{namespace}.addValkyrieSkinTraitIfMissing(this, template, null) > 0)
		{
			this.getSkills().update();
			this.setDirty(true);
		}
	}

	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.LilyCombatRetreated = false;
		::$bvvar{namespace}.applyValkyrieIdentityMetadata(this);
		::$bvvar{namespace}.syncActorSkills(this, "player.onCombatStart");
		if ("removeLilyForbiddenCombatSkills" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.removeLilyForbiddenCombatSkills(this);
		}
		__original();
		if ("removeLilyForbiddenCombatSkills" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.removeLilyForbiddenCombatSkills(this);
		}
	}
});

::$bvvar{namespace}.LilyCombatRetreated <- false;

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.tactical_flee_screen_onFleePressed = @(__original) function()
	{
		::$bvvar{namespace}.LilyCombatRetreated = true;
		return __original();
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		local ret = __original();
		if ("finalizeSwordMaidenHuntProgress" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.finalizeSwordMaidenHuntProgress();
		}
		if ("finalizeLilyPurificationProgress" in ::$bvvar{namespace})
		{
			if (::$bvvar{namespace}.LilyCombatRetreated)
			{
				local lily=::$bvvar{namespace}.findValkyrieInRoster("lily");
				local record=::$bvvar{namespace}.getLilySpiritRecord(lily);
				if(record!=null)record.discardPendingProgress();
			}
			else ::$bvvar{namespace}.finalizeLilyPurificationProgress();
			::$bvvar{namespace}.LilyCombatRetreated = false;
		}
		::$bvvar{namespace}.repairAllActorSkills("world_state.onCombatFinished");

		if ("clearAllTemporaryValkyrieSkins" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.clearAllTemporaryValkyrieSkins("world_state.onCombatFinished.temporarySkins");
		}

		if ("reapplyAllRosterSkins" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.reapplyAllRosterSkins("world_state.onCombatFinished.skins");
		}

		return ret;
	}
});
