::$bvvar{namespace}.CerydraBannerAuraID <- "$bvvar{modId}.effects.cerydra_banner_aura";
::$bvvar{namespace}.CerydraMilitaryMeritID <- "$bvvar{modId}.effects.cerydra_military_merit";
::$bvvar{namespace}.CerydraPeerageID <- "$bvvar{modId}.effects.cerydra_peerage";
::$bvvar{namespace}.CerydraCommandTurnID <- "$bvvar{modId}.effects.cerydra_command_turn";
::$bvvar{namespace}.CerydraCommandExhaustedID <- "$bvvar{modId}.effects.cerydra_command_exhausted";
::$bvvar{namespace}.CerydraNegativeEffectIDs <- [
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

::$bvvar{namespace}.getCerydraSkillID <- function( _skill )
{
	if (_skill == null)
	{
		return "";
	}

	try
	{
		return _skill.getID();
	}
	catch (e)
	{
		return "";
	}
};

::$bvvar{namespace}.isCerydraNegativeEffectID <- function( _id )
{
	return _id != null && ::$bvvar{namespace}.CerydraNegativeEffectIDs.find(_id) != null;
};

::$bvvar{namespace}.getCerydraWarBannerSkill <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return null;
	}

	return ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, "cerydra_war_banner");
};

::$bvvar{namespace}.getCerydraMilitaryMeritEffect <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return null;
	}

	return _actor.getSkills().getSkillByID(::$bvvar{namespace}.CerydraMilitaryMeritID);
};

::$bvvar{namespace}.getCerydraPeerageEffect <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return null;
	}

	return _actor.getSkills().getSkillByID(::$bvvar{namespace}.CerydraPeerageID);
};

::$bvvar{namespace}.hasCerydraPeerage <- function( _actor )
{
	return ::$bvvar{namespace}.getCerydraPeerageEffect(_actor) != null;
};

::$bvvar{namespace}.clearCerydraRootSprites <- function( _actor )
{
	if (_actor == null)
	{
		return;
	}

	try
	{
		_actor.getSprite("status_rooted").Visible = false;
		_actor.getSprite("status_rooted_back").Visible = false;
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.removeCerydraNegativeEffects <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return;
	}

	local skills = _actor.getSkills();

	foreach( id in ::$bvvar{namespace}.CerydraNegativeEffectIDs )
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

	::$bvvar{namespace}.clearCerydraRootSprites(_actor);
	skills.update();
	_actor.setDirty(true);
};

::$bvvar{namespace}.recordCerydraMeritAttack <- function( _attacker, _skill )
{
	if (_attacker == null || _skill == null || !_skill.isAttack())
	{
		return false;
	}

	local merit = ::$bvvar{namespace}.getCerydraMilitaryMeritEffect(_attacker);

	if (merit == null || !("recordAttack" in merit))
	{
		return false;
	}

	return merit.recordAttack(_skill);
};

::$bvvar{namespace}.applyCerydraPeerageFixedDamage <- function( _owner, _attacker, _skill, _target, _options = null )
{
	if (_owner == null || _attacker == null || _skill == null || !_skill.isAttack() || _target == null || _target.isAlliedWith(_attacker) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
	{
		return false;
	}

	local peerage = ::$bvvar{namespace}.getCerydraPeerageEffect(_attacker);

	if (peerage == null || !("isOwnedBy" in peerage) || !peerage.isOwnedBy(_owner) || !("applyFixedDamage" in peerage))
	{
		return false;
	}

	return peerage.applyFixedDamage(_attacker, _skill, _target, _options);
};

::$bvvar{namespace}.reloadCerydraTurnBar <- function( _bar )
{
	if (_bar == null || _bar.m == null || _bar.m.JSHandle == null)
	{
		return;
	}

	_bar.m.JSHandle.call("clear", null);
	local maxVisibleIndex = ::Math.min(_bar.m.CurrentEntities.len(), _bar.m.MaxVisibleEntities);

	for( local i = 0; i < maxVisibleIndex; i = ++i )
	{
		_bar.m.JSHandle.call("addEntity", _bar.convertEntityToUIData(_bar.m.CurrentEntities[i], i == maxVisibleIndex - 1));
	}
};

::$bvvar{namespace}.findCerydraTurnIndex <- function( _entities, _target )
{
	if (_entities == null || _target == null)
	{
		return null;
	}

	for( local i = 0; i < _entities.len(); i = ++i )
	{
		if (_entities[i] != null && _entities[i].getID() == _target.getID())
		{
			return i;
		}
	}

	return null;
};

::$bvvar{namespace}.insertCerydraCommandTurn <- function( _target )
{
	if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target) || !("Tactical" in getroottable()) || ::Tactical.TurnSequenceBar == null)
	{
		return null;
	}

	local bar = ::Tactical.TurnSequenceBar;
	local current = bar.m.CurrentEntities;

	if (current == null || current.len() == 0)
	{
		return null;
	}

	local existingIndex = ::$bvvar{namespace}.findCerydraTurnIndex(current, _target);

	if (existingIndex != null)
	{
		if (existingIndex == 0)
		{
			return null;
		}

		current.remove(existingIndex);
	}

	local insertIndex = current.len() == 0 ? 0 : 1;
	current.insert(insertIndex, _target);
	_target.m.IsTurnDone = false;
	_target.m.IsSkippingTurn = false;
	_target.m.IsTurnStarted = false;
	_target.setWaitActionSpent(false);
	_target.setActionPoints(_target.getActionPointsMax());
	_target.setDirty(true);
	::$bvvar{namespace}.reloadCerydraTurnBar(bar);

	return {
		RestoreNormalTurn = true
	};
};

::$bvvar{namespace}.restoreCerydraNormalTurn <- function( _target )
{
	if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target) || !("Tactical" in getroottable()) || ::Tactical.TurnSequenceBar == null)
	{
		return false;
	}

	local bar = ::Tactical.TurnSequenceBar;
	local current = bar.m.CurrentEntities;

	if (current == null || ::$bvvar{namespace}.findCerydraTurnIndex(current, _target) != null)
	{
		return false;
	}

	_target.m.IsTurnDone = false;
	_target.m.IsSkippingTurn = false;
	_target.m.IsTurnStarted = false;
	_target.setActionPoints(_target.getActionPointsMax());
	_target.setDirty(true);

	local insertIndex = 0;
	current.insert(insertIndex, _target);
	::$bvvar{namespace}.reloadCerydraTurnBar(bar);
	return true;
};

::$bvvar{namespace}.grantCerydraCommandTurn <- function( _owner, _target )
{
	if (_owner == null || _target == null || _owner == _target || !_target.isAlliedWith(_owner) || ::$bvvar{namespace}.isActorDeadOrDying(_owner) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
	{
		return false;
	}

	if (_target.getSkills().hasSkill(::$bvvar{namespace}.CerydraCommandTurnID) || _target.getSkills().hasSkill(::$bvvar{namespace}.CerydraCommandExhaustedID))
	{
		return false;
	}

	local result = ::$bvvar{namespace}.insertCerydraCommandTurn(_target);

	if (result == null)
	{
		return false;
	}

	local effect = ::new("$bvvar{privateFolder}/skills/effects/cerydra_command_turn_effect");
	effect.setupCommand(_owner, result.RestoreNormalTurn);
	_target.getSkills().add(effect);
	_target.getSkills().update();

	if (_target.isPlacedOnMap())
	{
		effect.spawnIcon("status_effect_34", _target.getTile());
	}

	return true;
};

::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
	q.add = @(__original) function( _skill, _order = 0 )
	{
		if (::$bvvar{namespace}.hasCerydraPeerage(this.m.Actor))
		{
			local id = ::$bvvar{namespace}.getCerydraSkillID(_skill);

			if (::$bvvar{namespace}.isCerydraNegativeEffectID(id))
			{
				if (this.m.Actor != null && this.m.Actor.isPlacedOnMap())
				{
					_skill.spawnIcon("status_effect_34", this.m.Actor.getTile());
				}

				return;
			}
		}

		return __original(_skill, _order);
	}

	q.onTargetHit = @(__original) function( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		::$bvvar{namespace}.recordCerydraMeritAttack(this.m.Actor, _caller);
	}

	q.onTargetMissed = @(__original) function( _caller, _targetEntity )
	{
		__original(_caller, _targetEntity);
		::$bvvar{namespace}.recordCerydraMeritAttack(this.m.Actor, _caller);
	}
});
