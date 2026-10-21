this.hysilens_tidal_erosion_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {},

	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.hysilens_tidal_erosion.tooltip.apply}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.hysilens_tidal_erosion.tooltip.damage}"
			}
		];
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function addHysilensTidalErosion( _target )
	{
		local actor = this.getActor();

		if (actor == null || _target == null || _target.getSkills() == null || _target.isAlliedWith(actor) || !_target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(actor) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.hysilens_tidal_erosion");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/hysilens_tidal_erosion_effect");
			effect.setupOwner(actor);
			_target.getSkills().add(effect);
		}
		else
		{
			effect.setupOwner(actor);
			effect.onRefresh();
		}

		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local actor = this.getActor();
		if (actor == null || _skill == null || _skill == this || !_skill.isAttack() || _targetEntity == null || _targetEntity.isAlliedWith(actor) || !_targetEntity.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(actor) || ::$bvvar{namespace}.isActorDeadOrDying(_targetEntity))
		{
			return;
		}

		this.addHysilensTidalErosion(_targetEntity);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved" || !("Victim" in _event))
		{
			return;
		}

		local actor = this.getActor();
		local target = _event.Victim;
		if (actor == null || target == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return;
		}

		local skills = target.getSkills();
		if (skills == null)
		{
			return;
		}

		local effect = skills.getSkillByID("$bvvar{modId}.effects.hysilens_tidal_erosion");
		if (effect == null || !("getOwner" in effect) || !("tryApplyBonusDamageFromResolvedEvent" in effect))
		{
			return;
		}

		local owner = effect.getOwner();
		if (owner == null || owner.getID() != actor.getID())
		{
			return;
		}

		effect.tryApplyBonusDamageFromResolvedEvent(_event);
	}
});
