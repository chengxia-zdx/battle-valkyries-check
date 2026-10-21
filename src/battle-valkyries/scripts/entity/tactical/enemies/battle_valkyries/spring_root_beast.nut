// Native beast AI and attacks with a complete custom sprite and corpse.
this.spring_root_beast <- this.inherit("scripts/entity/tactical/enemies/unhold", {
	m = { SpringForm = "root_beast" },
	function create() { this.unhold.create(); this.m.Name = "$bv{enemy.spring.root_beast.name}"; this.m.XP = 350; },
	function onInit()
	{
		this.unhold.onInit(); local b = this.m.BaseProperties, boss = this.m.SpringForm == "carrion_bloom_mother", guard = this.m.SpringForm == "root_bound_guard";
		b.Hitpoints = boss ? 2200 : (guard ? 260 : 380); b.MeleeSkill = boss ? 85 : 70;
		b.MeleeDefense = guard ? 20 : 5; b.RangedDefense = guard ? 10 : 0; b.Initiative = boss ? 45 : 60;
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = boss ? 220 : (guard ? 160 : 50); b.ArmorMax[part] = b.Armor[part]; }
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.Skills.removeByID("racial.unhold");
		if (boss) this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/spring_bloom_controller_effect"));
		this.refreshSpringVisual();
	},
	function refreshSpringVisual()
	{
		if (!this.hasSprite("body")) return;
		foreach (name in ["head", "armor", "helmet", "injury", "injury_body", "body_blood", "head_blood", "arms_icon", "shield_icon"])
			if (this.hasSprite(name)) this.getSprite(name).Visible = false;
		local body = this.getSprite("body"); body.setBrush("bust_bv_spring_passes_here_" + this.m.SpringForm);
		body.Visible = true; body.Color = this.createColor("#ffffff"); body.Saturation = 1.0; body.Scale = 1.0;
		body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, -15));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshSpringVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshSpringVisual(); },
	function onUpdateInjuryLayer()
	{
		// The native unhold injury overlay does not fit these complete sprites.
		foreach (name in ["injury", "injury_body", "injury_skin"])
			if (this.hasSprite(name)) this.getSprite(name).Visible = false;
	},
	function onDeath(killer, skill, tile, fatality)
	{
		local controller = this.m.Skills.getSkillByID("$bvvar{modId}.effects.spring_bloom_controller");
		if (controller != null) controller.clearParasites();
		local corpse = this.generateCorpse(tile, fatality, killer);
		if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
		else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); tile.spawnDetail("bust_bv_spring_passes_here_" + this.m.SpringForm + "_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer()); }
		this.actor.onDeath(killer, skill, tile, fatality);
	},
	function generateCorpse(tile, fatality, killer)
	{
		local corpse = this.unhold.generateCorpse(tile, fatality, killer);
		corpse.CorpseName = this.getName(); corpse.IsResurrectable = false; corpse.IsConsumable = false; return corpse;
	}
});
