this.yunki_nightmare_lamp <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/yunki_nightmare", {
	function create() { this.yunki_nightmare.create(); this.m.IsYunkiLamp = true; this.m.Name = "$bv{enemy.yunki_lamp.name}"; this.m.XP = 150; }
	function onInit()
	{
		this.yunki_nightmare.onInit(); local b = this.m.BaseProperties;
		b.ActionPoints = 0; b.Hitpoints = 400; b.MeleeDefense = 0; b.RangedDefense = 0; b.Initiative = 0;
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = 100; b.ArmorMax[part] = 100; }
		this.m.Hitpoints = b.Hitpoints; this.m.ActionPoints = 0; this.m.CurrentProperties = clone b;
		this.m.IsUsingZoneOfControl = false;
		this.m.Skills.removeByID("actives.warhound_bite"); this.m.Skills.removeByID("$bvvar{modId}.effects.yunki_nightmare");
	}
});
