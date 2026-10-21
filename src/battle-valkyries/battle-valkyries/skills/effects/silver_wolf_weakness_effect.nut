this.silver_wolf_weakness_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Count = 1
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.silver_wolf_weakness";
		this.m.Name = "$bv{effect.silver_wolf_weakness.name}";
		this.m.Description = "$bv{effect.silver_wolf_weakness.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/silver_wolf_weakness_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/silver_wolf_weakness_implant_sw.png";
		this.m.IconMini <- "status_effect_74_mini";
		this.m.Overlay <- "status_effect_74";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function getName()
	{
		return this.m.Count <= 1 ? this.m.Name : this.m.Name + " (x" + this.m.Count + ")";
	}

	function getTooltip()
	{
		local penalty = 10 * this.m.Count;
		local damage = 10 * this.m.Count;

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
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + penalty + "[/color] $bv{effect.silver_wolf_weakness.tooltip.melee_skill}"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + penalty + "[/color] $bv{effect.silver_wolf_weakness.tooltip.ranged_skill}"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + penalty + "[/color] $bv{effect.silver_wolf_weakness.tooltip.melee_defense}"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + penalty + "[/color] $bv{effect.silver_wolf_weakness.tooltip.ranged_defense}"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{effect.silver_wolf_weakness.tooltip.damage_prefix}[color=" + this.Const.UI.Color.NegativeValue + "]+" + damage + "%[/color]$bv{effect.silver_wolf_weakness.tooltip.damage_suffix}"
			}
		];
	}

	function onRefresh()
	{
		++this.m.Count;
		this.spawnIcon("status_effect_74", this.getContainer().getActor().getTile());
		this.getContainer().update();
	}

	function onUpdate( _properties )
	{
		local penalty = 10 * this.m.Count;
		_properties.MeleeSkill -= penalty;
		_properties.RangedSkill -= penalty;
		_properties.MeleeDefense -= penalty;
		_properties.RangedDefense -= penalty;
		_properties.DamageReceivedTotalMult *= 1.0 + 0.1 * this.m.Count;
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}
});
