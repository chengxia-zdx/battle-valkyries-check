::$bvvar{namespace}.CipherOldPatronEffectID <- "$bvvar{modId}.effects.cipher_old_patron";

::$bvvar{namespace}.getCipherOldPatronEffect <- function( _target )
{
	if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
	{
		return null;
	}

	local skills = _target.getSkills();
	return skills == null ? null : skills.getSkillByID(::$bvvar{namespace}.CipherOldPatronEffectID);
};

::$bvvar{namespace}.isCipherOldPatronOwnedBy <- function( _effect, _owner )
{
	if (_effect == null || _owner == null || !("isOwnedBy" in _effect))
	{
		return false;
	}

	return _effect.isOwnedBy(_owner);
};

::$bvvar{namespace}.clearCipherOldPatron <- function( _owner )
{
	local root = getroottable();

	if (_owner == null || !("Tactical" in root) || ::Tactical.Entities == null)
	{
		return;
	}

	local actors = ::Tactical.Entities.getAllInstancesAsArray();

	foreach( actor in actors )
	{
		local effect = ::$bvvar{namespace}.getCipherOldPatronEffect(actor);

		if (::$bvvar{namespace}.isCipherOldPatronOwnedBy(effect, _owner))
		{
			effect.removeSelf();
		}
	}
};

::$bvvar{namespace}.getCipherOldPatronRecord <- function( _owner )
{
	local root = getroottable();

	if (_owner == null || !("Tactical" in root) || ::Tactical.Entities == null)
	{
		return null;
	}

	local actors = ::Tactical.Entities.getAllInstancesAsArray();

	foreach( actor in actors )
	{
		local effect = ::$bvvar{namespace}.getCipherOldPatronEffect(actor);

		if (::$bvvar{namespace}.isCipherOldPatronOwnedBy(effect, _owner))
		{
			return {
				Actor = actor,
				Effect = effect
			};
		}
	}

	return null;
};

::$bvvar{namespace}.assignCipherOldPatron <- function( _owner, _target )
{
	if (_owner == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_owner) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
	{
		return null;
	}

	if (_target.isAlliedWith(_owner) || !_target.isAttackable())
	{
		return null;
	}

	::$bvvar{namespace}.clearCipherOldPatron(_owner);

	local effect = ::new("$bvvar{privateFolder}/skills/effects/cipher_old_patron_effect");
	effect.setupOwner(_owner);
	_target.getSkills().add(effect);
	_target.getSkills().update();

	if (_target.isPlacedOnMap())
	{
		effect.spawnIcon("status_effect_53", _target.getTile());
	}

	return effect;
};

::$bvvar{namespace}.recordCipherOldPatronAttack <- function( _attacker, _skill, _target )
{
	if (_attacker == null || _skill == null || _target == null || !_skill.isAttack())
	{
		return false;
	}

	local effect = ::$bvvar{namespace}.getCipherOldPatronEffect(_target);

	if (effect == null || !("recordAttack" in effect))
	{
		return false;
	}

	return effect.recordAttack(_attacker, _skill);
};

::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
	q.onTargetHit = @(__original) function( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		::$bvvar{namespace}.recordCipherOldPatronAttack(this.m.Actor, _caller, _targetEntity);
	}

	q.onTargetMissed = @(__original) function( _caller, _targetEntity )
	{
		__original(_caller, _targetEntity);
		::$bvvar{namespace}.recordCipherOldPatronAttack(this.m.Actor, _caller, _targetEntity);
	}
});
