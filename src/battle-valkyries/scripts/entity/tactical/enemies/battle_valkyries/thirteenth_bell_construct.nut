this.thirteenth_bell_construct <- this.inherit("scripts/entity/tactical/actor", {
	m = { ClockRole = "officer" },
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer; this.m.BloodType = this.Const.BloodType.None;
		this.m.XP = 650; this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.actor.create(); this.m.AIAgent = this.new("scripts/ai/tactical/agents/wardog_agent"); this.m.AIAgent.setActor(this);
	},
	function art() { return this.m.ClockRole == "clock" ? "outer_clock" : "keeper"; },
	function onInit()
	{
		this.actor.onInit(); local b = this.m.BaseProperties, role = this.m.ClockRole;
		b.ActionPoints = role == "clock" ? 0 : 9; b.Hitpoints = role == "keeper" ? 1350 : (role == "clock" ? 220 : (role == "lantern" ? 260 : 550));
		b.Stamina = 200; b.Bravery = 150; b.MeleeSkill = role == "keeper" ? 90 : 80;
		b.MeleeDefense = role == "clock" ? 0 : 15; b.RangedDefense = role == "clock" ? 0 : 10; b.Initiative = role == "keeper" ? 50 : 70;
		b.IsAffectedByNight = false; b.IsAffectedByInjuries = false; b.IsImmuneToBleeding = true; b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true; b.IsImmuneToKnockBackAndGrab = role == "keeper" || role == "clock";
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = role == "keeper" ? 240 : (role == "clock" ? 80 : 120); b.ArmorMax[part] = b.Armor[part]; }
		this.m.ActionPoints = b.ActionPoints; this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost; this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.IsUsingZoneOfControl = role != "clock";
		this.addSprite("socket").setBrush("bust_base_undead"); this.addSprite("body");
		foreach (name in ["armor", "head", "helmet", "injury", "closed_eyes"]) this.addSprite(name).Visible = false;
		this.addDefaultStatusSprites(); this.refreshClockVisual();
		this.m.Items.getAppearance().Body = "bust_bv_thirteenth_bell_" + this.art();
		if (role != "clock") this.m.Skills.add(this.new("scripts/skills/actives/battle_valkyries/thirteenth_bell_strike"));
		this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/thirteenth_bell_controller"));
	},
	function refreshClockVisual()
	{
		if (!this.hasSprite("body")) return;
		local body = this.getSprite("body"); body.setBrush("bust_bv_thirteenth_bell_" + this.art());
		body.Visible = true; body.Scale = 1.0; body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, -15));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshClockVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshClockVisual(); },
	function clearClockWarning()
	{
		local c = this.m.Skills.getSkillByID("$bvvar{modId}.effects.thirteenth_bell"); if (c != null) c.clearWarning();
	},
	function onDeath(killer, skill, tile, fatality)
	{
		this.clearClockWarning();
		if (tile != null) tile.spawnDetail("bust_bv_thirteenth_bell_" + this.art() + "_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer());
		this.dropLoot(tile, this.getLootForTile(killer, []), !this.isAlliedWithPlayer());
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = this.getName(); corpse.Items = this.getItems(); corpse.Tile = tile;
		corpse.IsResurrectable = false;
		if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
		else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); }
		this.actor.onDeath(killer, skill, tile, fatality);
	},
	function removeFromMap() { this.clearClockWarning(); return this.actor.removeFromMap(); },
	function assignRandomEquipment() {}
});
