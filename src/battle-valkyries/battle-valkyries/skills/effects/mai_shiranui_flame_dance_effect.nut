this.mai_shiranui_flame_dance_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { TurnsLeft = 3 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.mai_shiranui_flame_dance";
		this.m.Name = "$bv{effect.mai_shiranui_flame_dance.name}";
		this.m.Description = "$bv{effect.mai_shiranui_flame_dance.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/mai_shiranui_chou_hissatsu_shinobi_bachi.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/mai_shiranui_chou_hissatsu_shinobi_bachi_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.m.TurnsLeft = 3;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.mai_shiranui_flame_dance.tooltip.turns_prefix}" + this.m.TurnsLeft + "$bv{effect.mai_shiranui_flame_dance.tooltip.turns_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/melee_defense.png", text = "$bv{effect.mai_shiranui_flame_dance.tooltip.defense}" },
			{ id = 5, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.mai_shiranui_flame_dance.tooltip.cost}" },
			{ id = 6, type = "text", icon = "ui/icons/fatigue.png", text = "$bv{effect.mai_shiranui_flame_dance.tooltip.recovery}" }
		];
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		return true;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;
		_properties.FatigueRecoveryRateMult *= 2.0;
	}

	function getSource( _skill )
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		try
		{
			local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(owner, _skill);
			return frame == null ? null : frame.Source;
		}
		catch (e)
		{
			return null;
		}
	}

	function isExcludedSource( _skill )
	{
		local source = this.getSource(_skill);
		return source == "aoo" || source == "riposte" || source == "counter" || source == "followup"
			|| source == "fixed_damage" || source == "damage_over_time";
	}

	function isEligibleReducedAttack( _skill )
	{
		if (_skill == null || this.isExcludedSource(_skill)) return false;
		return ::$bvvar{namespace}.isValkyrieThrowingWeaponAttack(_skill)
			|| (::$bvvar{namespace}.isActiveWeaponAttack(_skill) && !_skill.isRanged());
	}

	function allowsValkyrieRangedWeaponSkillPolicy( _usedSkill )
	{
		return ::$bvvar{namespace}.isValkyrieThrowingWeaponAttack(_usedSkill);
	}

	function getValkyrieWeaponSkillPolicy( _usedSkill )
	{
		if (!this.isEligibleReducedAttack(_usedSkill)) return null;
		return {
			Token = "mai_shiranui_flame_dance",
			APDelta = -2,
			MinimumAPCost = 2
		};
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft = this.Math.max(0, this.m.TurnsLeft - 1);
		if (this.m.TurnsLeft <= 0) this.removeSelf();
	}

	function onCombatFinished()
	{
		this.m.TurnsLeft = 0;
		this.removeSelf();
		this.skill.onCombatFinished();
	}
});
