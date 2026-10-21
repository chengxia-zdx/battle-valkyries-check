this.himeko_trailblazer_mech_attack <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "actives.warhound_bite";
		this.m.Name = "$bv{skill.himeko_trailblazer_mech_attack.name}";
		this.m.Description = "$bv{skill.himeko_trailblazer_mech_attack.description}";
		this.m.KilledString = "$bv{skill.himeko_trailblazer_mech_attack.killed}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/himeko_trailblazer_mech_attack.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/himeko_trailblazer_mech_attack_sw.png";
		this.m.Overlay = "";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingActorPitch = true;
		this.m.DirectDamageMult = 0.45;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 10;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 120;
		_properties.DamageRegularMax += 150;
		_properties.DamageArmorMult *= 1.75;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/damage_dealt.png", text = "$bv{skill.himeko_trailblazer_mech_attack.tooltip.damage}" },
			{ id = 5, type = "text", icon = "ui/icons/ranged_skill.png", text = "$bv{skill.himeko_trailblazer_mech_attack.tooltip.range}" },
			{ id = 6, type = "text", icon = "ui/icons/fatigue.png", text = "$bv{skill.himeko_trailblazer_mech_attack.tooltip.fatigue}" }
		];
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}
});
