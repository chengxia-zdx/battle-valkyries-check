this.phoebe_absolution_litany_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function isAbsolutionTarget( _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local skills = _target.getSkills();
		return skills != null && (skills.hasSkill("effects.dazed") || skills.hasSkill("effects.staggered"));
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties == null || _targetEntity == null || !::$bvvar{namespace}.isDirectAttack(_skill))
		{
			return;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (::$bvvar{namespace}.isActorDeadOrDying(actor) || ::$bvvar{namespace}.isActorDeadOrDying(_targetEntity))
		{
			return;
		}

		try
		{
			if (_targetEntity.isAlliedWith(actor))
			{
				return;
			}
		}
		catch (e)
		{
			return;
		}

		_properties.MeleeSkill += 10;
		_properties.RangedSkill += 10;

		if (this.isAbsolutionTarget(_targetEntity))
		{
			_properties.DamageRegularMult *= 1.25;
			_properties.DamageDirectAdd += 0.30;
		}
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.phoebe_absolution_litany.tooltip.hit}" },
			{ id = 4, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.phoebe_absolution_litany.tooltip.absolution}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.phoebe_absolution_litany.tooltip.condition}" }
		];
	}
});
