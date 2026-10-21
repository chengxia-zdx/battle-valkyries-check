this.scarlet_shadow_flyflower_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		LastCountedSkillCounter = -1
	},

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
				text = "$bv{skill.scarlet_shadow_flyflower.tooltip.layers}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.scarlet_shadow_flyflower.tooltip.stages}"
			}
		];
	}

	function getFlyflowerEffect()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || actor.getSkills() == null)
		{
			return null;
		}

		local effect = actor.getSkills().getSkillByID("$bvvar{modId}.effects.scarlet_shadow_flyflower");

		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/scarlet_shadow_flyflower_effect");
			actor.getSkills().add(effect);
		}

		return effect;
	}

	function isOrdinaryMeleeAttack( _skill, _targetEntity )
	{
		if (_skill == null || !_skill.isAttack() || !_skill.m.IsWeaponSkill || _skill.isRanged())
		{
			return false;
		}

		local skillKey = "getBattleValkyriesSkillKey" in _skill ? _skill.getBattleValkyriesSkillKey() : null;
		if (skillKey == "scarlet_shadow_flower_shadow_trinity" || skillKey == "scarlet_shadow_fading_blossom")
		{
			return false;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || _targetEntity == null || _targetEntity.isAlliedWith(actor))
		{
			return false;
		}

		return true;
	}

	function addFlyflowerLayerOnce( _skill, _targetEntity )
	{
		if (!this.isOrdinaryMeleeAttack(_skill, _targetEntity))
		{
			return;
		}

		local counter = this.Const.SkillCounter;
		if (counter == this.m.LastCountedSkillCounter)
		{
			return;
		}

		this.m.LastCountedSkillCounter = counter;
		local effect = this.getFlyflowerEffect();

		if (effect != null)
		{
			effect.addLayer(1);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.addFlyflowerLayerOnce(_skill, _targetEntity);
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.addFlyflowerLayerOnce(_skill, _targetEntity);
	}

	function onCombatStarted()
	{
		this.m.LastCountedSkillCounter = -1;
		local effect = this.getFlyflowerEffect();

		if (effect != null)
		{
			effect.clearAllStages();
		}
	}

	function onCombatFinished()
	{
		this.m.LastCountedSkillCounter = -1;
		this.skill.onCombatFinished();
	}
});
