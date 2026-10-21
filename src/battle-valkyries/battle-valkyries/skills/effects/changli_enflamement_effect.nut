this.changli_enflamement_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Count = 0,
		MaxCount = 4
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.changli_enflamement";
		this.m.Name = "$bv{effect.changli_enflamement.name}";
		this.m.Description = "$bv{effect.changli_enflamement.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/changli_delayed_strategy.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/changli_delayed_strategy_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount()
	{
		return this.Math.max(0, this.Math.min(this.m.MaxCount, this.m.Count));
	}

	function setCount( _count )
	{
		this.m.Count = this.Math.max(0, this.Math.min(this.m.MaxCount, _count));
		return this.m.Count;
	}

	function addCount( _amount = 1 )
	{
		return this.setCount(this.m.Count + _amount);
	}

	function clear()
	{
		this.m.Count = 0;
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
				text = "$bv{effect.changli_enflamement.tooltip.count_prefix}" + this.getCount() + "/" + this.m.MaxCount + "$bv{effect.changli_enflamement.tooltip.count_suffix}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{effect.changli_enflamement.tooltip.damage}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{effect.changli_enflamement.tooltip.direct}"
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local count = this.getCount();
		if (count <= 0 || _properties == null || !::$bvvar{namespace}.isActiveWeaponAttack(_skill) || _skill.isRanged())
		{
			return;
		}

		_properties.DamageRegularMult *= 1.0 + count * 0.05;
		_properties.DamageDirectAdd += count * 0.05;
	}

	function onCombatStarted()
	{
		this.clear();
	}

	function onCombatFinished()
	{
		this.clear();
		this.skill.onCombatFinished();
	}
});
