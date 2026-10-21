this.yunki_nightmare <- this.inherit("scripts/entity/tactical/actor", {
	m = { IsYunkiLamp = false, IsYunkiPhantom = false },
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer; this.m.BloodType = this.Const.BloodType.None; this.m.XP = 1800;
		this.m.Name = "$bv{enemy.yunki_nightmare.name}"; this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.actor.create(); this.m.AIAgent = this.new("scripts/ai/tactical/agents/wardog_agent"); this.m.AIAgent.setActor(this);
	}
	function onInit()
	{
		this.actor.onInit(); local b = this.m.BaseProperties;
		b.ActionPoints = 9; b.Hitpoints = 3000; b.Stamina = 250; b.Bravery = 150;
		b.MeleeSkill = 105; b.MeleeDefense = 30; b.RangedDefense = 20; b.Initiative = 75;
		b.IsAffectedByNight = false; b.IsAffectedByInjuries = false; b.IsImmuneToBleeding = true; b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true; b.IsImmuneToKnockBackAndGrab = true;
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = 450; b.ArmorMax[part] = 450; }
		this.m.ActionPoints = b.ActionPoints; this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost; this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_undead"); this.addSprite("body").setBrush("bust_bv_yunki_nightmare");
		foreach (name in ["armor", "head", "helmet", "injury", "closed_eyes"]) this.addSprite(name).Visible = false;
		this.addDefaultStatusSprites();
		this.refreshYunkiVisual();
		this.m.Items.getAppearance().Body = this.m.IsYunkiLamp ? "bust_bv_yunki_nightmare_lamp" : "bust_bv_yunki_nightmare";
		this.m.Skills.add(this.new("scripts/skills/actives/battle_valkyries/yunki_nightmare_claw"));
		this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/yunki_nightmare_controller"));
	}
	function onAppearanceChanged(appearance, dirty = true)
	{
		this.actor.onAppearanceChanged(appearance, false);
		this.refreshYunkiVisual();
		if (dirty) this.setDirty(true);
	}
	function refreshYunkiVisual()
	{
		if (!this.hasSprite("body")) return;
		local body = this.getSprite("body");
		body.setBrush(this.m.IsYunkiLamp ? "bust_bv_yunki_nightmare_lamp" : "bust_bv_yunki_nightmare");
		body.Visible = true;
		// Align the opaque lower edge with the socket rim (world Y about -18).
		// Absolute transforms keep refresh/load from accumulating displacement.
		body.Scale = this.m.IsYunkiLamp ? 0.82 : 1.0;
		local offsetY = this.m.IsYunkiLamp ? -9 : -15;
		this.setSpriteOffset("body", this.createVec(0, offsetY));
		this.refreshYunkiFacing();
	}
	function refreshYunkiFacing()
	{
		// The source bust faces right; actor only flips status/equipment layers.
		if (this.hasSprite("body")) this.getSprite("body").setHorizontalFlipping(!this.isAlliedWithPlayer());
	}
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		this.refreshYunkiFacing();
	}
	function onDeath(killer, skill, tile, fatality)
	{
		local controller = this.m.Skills.getSkillByID("$bvvar{modId}.effects.yunki_nightmare");
		if (controller != null) controller.clearWarning();
		// The apparition dissipates; no human corpse/loot or player identity is created.
		this.actor.onDeath(killer, skill, tile, fatality);
	}
	function assignRandomEquipment() {}
});
