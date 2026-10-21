::$bvvar{namespace}.JeanneRevelationID <- "$bvvar{modId}.effects.jeanne_revelation";
::$bvvar{namespace}.JeanneHolyBannerAuraID <- "$bvvar{modId}.effects.jeanne_holy_banner_aura";
::$bvvar{namespace}.JeanneTrueNameDiscernmentID <- "$bvvar{modId}.effects.jeanne_true_name_discernment";
::$bvvar{namespace}.JeanneBannerRaisedID <- "$bvvar{modId}.effects.jeanne_banner_raised";
::$bvvar{namespace}.JeanneHolyFlagProtectionID <- "$bvvar{modId}.effects.jeanne_holy_flag_protection";
::$bvvar{namespace}.JeanneHolyMaidenBlessingID <- "$bvvar{modId}.effects.jeanne_holy_maiden_blessing";
::$bvvar{namespace}.JeanneBondTraitID <- "$bvvar{modId}.trait.jeanne_bond";

::$bvvar{namespace}.JeanneNegativeEffectIDs <- [
	"effects.stunned",
	"effects.dazed",
	"effects.staggered",
	"effects.disarmed",
	"effects.goblin_poison",
	"effects.spider_poison",
	"effects.bleeding",
	"effects.net",
	"effects.rooted",
	"effects.web",
	"effects.kraken_ensnare",
	"effects.serpent_ensnare",
	"effects.sleeping",
	"effects.horrified",
	"effects.nightmare",
	"effects.distracted",
	"effects.withered",
	"effects.chilled",
	"effects.acid",
	"effects.lindwurm_acid",
	"effects.charmed",
	"effects.overwhelmed",
	"effects.goblin_grunt_potion"
];

::$bvvar{namespace}.getJeanneHolyBannerSkill <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return null;
	}

	return ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, "jeanne_revelation_holy_banner");
};

::$bvvar{namespace}.getJeanneBondTrait <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return null;
	}

	return _actor.getSkills().getSkillByID(::$bvvar{namespace}.JeanneBondTraitID);
};

::$bvvar{namespace}.hasJeanneBondUpgrade <- function( _actor, _stage )
{
	local trait = ::$bvvar{namespace}.getJeanneBondTrait(_actor);
	return trait != null && ("hasUpgrade" in trait) && trait.hasUpgrade(_stage);
};

::$bvvar{namespace}.getJeanneStartingRevelation <- function( _actor )
{
	return ::$bvvar{namespace}.hasJeanneBondUpgrade(_actor, 40) ? 3 : 2;
};

::$bvvar{namespace}.getJeanneAuraFatigueRecovery <- function( _actor )
{
	return ::$bvvar{namespace}.hasJeanneBondUpgrade(_actor, 60) ? 8 : 5;
};

::$bvvar{namespace}.getJeanneBlessingHealing <- function( _actor )
{
	return (::$bvvar{namespace}.hasJeanneBondUpgrade(_actor, 100) ? 15 : 10) + (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(_actor)) ? 10 : 0);
};

::$bvvar{namespace}.getJeanneMainhandItem <- function( _actor )
{
	if (_actor == null || _actor.getItems() == null)
	{
		return null;
	}

	try
	{
		return _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getJeanneWeaponIdentity <- function( _actor )
{
	local item = ::$bvvar{namespace}.getJeanneMainhandItem(_actor);
	if (item == null)
	{
		return null;
	}

	local id = "";
	local categories = "";
	try { id = item.getID(); } catch (e) { id = ""; }
	try { categories = item.m.Categories; } catch (e) { categories = ""; }
	if (typeof id != "string") id = "";
	if (typeof categories != "string") categories = "";

	return {
		Item = item,
		ID = id,
		Categories = categories
	};
};

::$bvvar{namespace}.isJeanneTrueBannerWeapon <- function( _actor )
{
	local identity = ::$bvvar{namespace}.getJeanneWeaponIdentity(_actor);
	return identity != null && (identity.ID.find("banner") != null || identity.ID.find("standard") != null);
};

::$bvvar{namespace}.hasJeanneLegalBannerWeapon <- function( _actor )
{
	local identity = ::$bvvar{namespace}.getJeanneWeaponIdentity(_actor);
	if (identity == null)
	{
		return false;
	}

	return identity.ID.find("banner") != null
		|| identity.ID.find("standard") != null
		|| identity.ID.find("pike") != null
		|| identity.ID.find("billhook") != null
		|| identity.ID.find("hooked_blade") != null
		|| identity.ID.find("warscythe") != null
		|| identity.ID.find("swordlance") != null
		|| identity.ID.find("pitchfork") != null
		|| identity.ID.find("pole") != null
		// Categories is localized display text, not a stable weapon-type enum.
		// Chinese Legends also uses mixed labels such as "砍刀/长柄武器，双手".
		|| identity.Categories.tolower().find("polearm") != null
		|| identity.Categories.find("长柄") != null
		|| identity.Categories.find("長柄") != null;
};

::$bvvar{namespace}.isJeanneNormalTurnStart <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return false;
	}

	local command = _actor.getSkills().getSkillByID("$bvvar{modId}.effects.cerydra_command_turn");
	if (command != null) return false;

	return true;
};

// Protection and healing share the recipient's two complete normal turns.
// Refresh does not reset LastTickRound, so it cannot heal/count twice in a round.
::$bvvar{namespace}.resetJeanneHolyBuffDuration <- function( _effect )
{
	_effect.m.TurnsLeft = 2;
	_effect.m.ConsumedThisTurn = false;
};

::$bvvar{namespace}.beginJeanneHolyBuffTurn <- function( _effect )
{
	local actor = _effect.getContainer() == null ? null : _effect.getContainer().getActor();
	if (actor == null || _effect.getOwner() == null || this.isActorDeadOrDying(actor))
	{
		_effect.removeSelf();
		return false;
	}
	if (!this.isJeanneNormalTurnStart(actor)) return false;
	local round = -1;
	// Time is an engine global, not a member of the effect passed to this helper.
	try { round = ::Time.getRound(); } catch (e) { return false; }
	if (round < 0 || _effect.m.LastTickRound == round) return false;
	_effect.m.LastTickRound = round;
	_effect.m.ConsumedThisTurn = true;
	return true;
};

::$bvvar{namespace}.endJeanneHolyBuffTurn <- function( _effect )
{
	if (!_effect.m.ConsumedThisTurn) return;
	local actor = _effect.getContainer() == null ? null : _effect.getContainer().getActor();
	if (!this.isJeanneNormalTurnStart(actor)) return;
	local round = -1;
	try { round = ::Time.getRound(); } catch (e) { return; }
	if (round < 0 || _effect.m.LastTickRound != round) return;
	_effect.m.ConsumedThisTurn = false;
	_effect.m.TurnsLeft--;
	if (_effect.m.TurnsLeft <= 0) _effect.removeSelf();
};

::$bvvar{namespace}.getJeanneTacticalActors <- function()
{
	if (!("Tactical" in getroottable()) || ::Tactical == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null)
	{
		return [];
	}

	try
	{
		return ::Tactical.Entities.getAllInstancesAsArray();
	}
	catch (e)
	{
		return [];
	}
};

::$bvvar{namespace}.clearJeanneRootSprites <- function( _actor )
{
	if (_actor == null) return;
	try
	{
		_actor.getSprite("status_rooted").Visible = false;
		_actor.getSprite("status_rooted_back").Visible = false;
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.removeJeanneNegativeEffects <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return false;
	}

	local skills = _actor.getSkills();
	foreach( id in ::$bvvar{namespace}.JeanneNegativeEffectIDs )
	{
		while (skills.hasSkill(id))
		{
			skills.removeByID(id);
		}
	}
	if (skills.hasSkill("actives.break_free"))
	{
		skills.removeByID("actives.break_free");
	}
	::$bvvar{namespace}.clearJeanneRootSprites(_actor);
	skills.update();
	_actor.setDirty(true);
	return true;
};

::$bvvar{namespace}.improveJeanneMoraleOneStep <- function( _actor )
{
	if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
	{
		return false;
	}

	local current = null;
	try { current = _actor.getMoraleState(); } catch (e) { return false; }
	local next = null;
	if (current == ::Const.MoraleState.Fleeing || current == ::Const.MoraleState.Breaking)
	{
		next = ::Const.MoraleState.Wavering;
	}
	else if (current == ::Const.MoraleState.Wavering)
	{
		next = ::Const.MoraleState.Steady;
	}
	if (next == null)
	{
		return false;
	}

	try
	{
		_actor.setMoraleState(next);
		_actor.setDirty(true);
		return true;
	}
	catch (e)
	{
		return false;
	}
};
