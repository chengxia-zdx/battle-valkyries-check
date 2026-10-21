// Morgan's state is combat-only. Identity and loadout remain owned by the service.
::$bvvar{namespace}.isMorganNormalTurn <- function( _actor )
{
	return _actor != null && _actor.getSkills().getSkillByID("$bvvar{modId}.effects.cerydra_command_turn") == null;
};

::$bvvar{namespace}.getMorganRound <- function()
{
	return ::Time.getRound();
};

::$bvvar{namespace}.applyMorganEffect <- function( _target, _key, _owner )
{
	if (_target == null || this.isActorDeadOrDying(_target)) return null;
	local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects." + _key);
	if (effect == null)
	{
		effect = ::new("$bvvar{privateFolder}/skills/effects/" + _key + "_effect");
		effect.setMorganOwner(_owner);
		_target.getSkills().add(effect);
	}
	else { effect.setMorganOwner(_owner); effect.onRefresh(); }
	_target.getSkills().update();
	_target.setDirty(true);
	return effect;
};

::$bvvar{namespace}.getMorganBlastTargets <- function( _user, _center )
{
	local ret = [];
	foreach (target in this.getValkyrieEnemyTargetsOnTiles(_user, this.getValkyrieRadiusTiles(_center, 2, true)))
	{
		local tile = target.getTile();
		// Actor occupancy does not block magic; terrain line of sight still does.
		if (tile.ID == _center.ID || _center.hasLineOfSightTo(tile, 2)) ret.push(target);
	}
	return ret;
};
