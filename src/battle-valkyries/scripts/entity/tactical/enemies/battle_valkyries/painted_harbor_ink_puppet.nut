this.painted_harbor_ink_puppet <- this.inherit("scripts/entity/tactical/actor", {
	m = { IsPaintedPuppet = true, IsCurator = false, IsArchivist = false, IsPaintedCopy = false, WetOwner = null, WetStarted = false },
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer; this.m.BloodType = this.Const.BloodType.None;
		this.m.XP = 320; this.m.Name = "$bv{enemy.painted_harbor.puppet.name}"; this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.actor.create(); this.m.AIAgent = this.new("scripts/ai/tactical/agents/wardog_agent"); this.m.AIAgent.setActor(this);
	},
	function art() { return this.m.IsCurator || this.m.IsArchivist ? "faceless_curator" : "ink_puppet"; },
	function onInit()
	{
		this.actor.onInit(); local b = this.m.BaseProperties, boss = this.m.IsCurator, elite = this.m.IsArchivist;
		b.ActionPoints = 9; b.Hitpoints = boss ? 2600 : (elite ? 850 : 360); b.Stamina = 250; b.Bravery = 150;
		b.MeleeSkill = boss ? 105 : 85; b.MeleeDefense = boss ? 30 : 15; b.RangedDefense = boss ? 20 : 10; b.Initiative = boss ? 60 : 80;
		b.IsAffectedByNight = false; b.IsAffectedByInjuries = false; b.IsImmuneToBleeding = true; b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true; b.IsImmuneToKnockBackAndGrab = boss;
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = boss ? 350 : (elite ? 220 : 100); b.ArmorMax[part] = b.Armor[part]; }
		this.m.ActionPoints = b.ActionPoints; this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost; this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_undead"); this.addSprite("body");
		foreach (name in ["armor", "head", "helmet", "injury", "closed_eyes"]) this.addSprite(name).Visible = false;
		this.addDefaultStatusSprites(); this.refreshPaintedVisual();
		this.m.Items.getAppearance().Body = "bust_bv_painted_harbor_" + this.art();
		this.m.Skills.add(this.new("scripts/skills/actives/battle_valkyries/painted_harbor_scrape"));
		if (boss || elite) this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/painted_harbor_controller"));
	},
	function refreshPaintedVisual()
	{
		if (!this.hasSprite("body")) return;
		local body = this.getSprite("body"); body.setBrush("bust_bv_painted_harbor_" + this.art()); body.Visible = true;
		body.Scale = 1.0; body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, -15));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshPaintedVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshPaintedVisual(); },
	function onTurnStart() { this.actor.onTurnStart(); if (this.m.WetOwner != null) this.m.WetStarted = true; },
	function onTurnEnd()
	{
		this.actor.onTurnEnd();
		if (this.m.WetStarted) { this.m.WetOwner = null; this.m.WetStarted = false; this.m.Skills.removeByID("$bvvar{modId}.effects.painted_harbor_wet"); }
	},
	function onDeath(killer, skill, tile, fatality)
	{
		local controller = this.m.Skills.getSkillByID("$bvvar{modId}.effects.painted_harbor_controller");
		if (controller != null) controller.clearWarning();
		if (this.m.WetOwner != null && !this.m.IsPaintedCopy)
			foreach (group in ::Tactical.Entities.getAllInstances()) foreach (a in group)
				if (a != null && a.getID() == this.m.WetOwner && a.isAlive() && !a.isDying())
				{
					local c = a.getSkills().getSkillByID("$bvvar{modId}.effects.painted_harbor_controller");
					if (c != null) c.queueCopy(tile);
				}
		this.m.WetOwner = null;
		this.actor.onDeath(killer, skill, tile, fatality);
		if (tile != null) tile.spawnDetail("bust_bv_painted_harbor_" + this.art() + "_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer());
	},
	function assignRandomEquipment() {}
});
