this.seven_shields_spell <- this.inherit("scripts/skills/actives/battle_valkyries/black_city_flame", {
	m = { SevenShieldsRole = "kaguya" },
	function create()
	{
		this.black_city_flame.create();
		this.m.Name = "$bv{chapter.seven_shields.spell.name}"; this.m.Description = "$bv{chapter.seven_shields.spell.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/kaguya_talisman.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/kaguya_talisman_sw.png";
	},
	function onAnySkillUsed(skill, target, properties)
	{
		if (skill != this) return;
		local stronger = this.m.SevenShieldsRole == "celestine", shrine = this.m.SevenShieldsRole == "kaguya";
		properties.DamageRegularMin = stronger ? 65 : (shrine ? 55 : 45);
		properties.DamageRegularMax = stronger ? 85 : (shrine ? 75 : 65);
		properties.DamageArmorMult = 1.0;
	}
});
