this.yunki_nightmare_phantom <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/yunki_nightmare", {
	function create() { this.yunki_nightmare.create(); this.m.IsYunkiPhantom = true; this.m.Name = "$bv{enemy.yunki_phantom.name}"; this.m.XP = 100; }
	function onInit()
	{
		this.yunki_nightmare.onInit(); local b = this.m.BaseProperties;
		b.Hitpoints = 260; b.MeleeSkill = 85; b.MeleeDefense = 15;
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = 80; b.ArmorMax[part] = 80; }
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.Skills.removeByID("$bvvar{modId}.effects.yunki_nightmare");
		this.getSprite("body").Alpha = 155;
	}
});
