this.silver_wolf_weakness_implant_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
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
				text = "$bv{skill.silver_wolf_weakness_implant.tooltip}"
			}
		];
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local user = this.getContainer().getActor();
		if (_skill == null || !_skill.isAttack() || user == null || ::$bvvar{namespace}.isActorDeadOrDying(user))
		{
			return;
		}

		if (_targetEntity == null || _targetEntity.isAlliedWith(user) || ::$bvvar{namespace}.isActorDeadOrDying(_targetEntity) || !_targetEntity.isAttackable())
		{
			return;
		}

		_targetEntity.getSkills().add(this.new("$bvvar{privateFolder}/skills/effects/silver_wolf_weakness_effect"));
	}
});
