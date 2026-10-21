this.blackgold_weiss <- this.inherit("scripts/entity/tactical/enemies/bandit_leader", {
	function create()
	{
		this.bandit_leader.create(); this.m.Name = "$bv{chapter.blackgold.weiss.name}"; this.m.XP = 900;
	},
	function onInit()
	{
		this.bandit_leader.onInit(); local b = this.m.BaseProperties;
		b.Hitpoints = 900; b.ActionPoints = 9; b.Stamina = 180; b.Bravery = 100; b.MeleeSkill = 105; b.MeleeDefense = 30; b.RangedDefense = 15;
		this.m.Hitpoints = b.Hitpoints; this.m.ActionPoints = b.ActionPoints; this.m.CurrentProperties = clone b;
		this.m.Skills.removeByID("perk.nine_lives");
		this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/blackgold_weiss_controller"));
		this.refreshBlackgoldVisual();
	},
	function refreshBlackgoldVisual()
	{
		if (!this.hasSprite("body")) return;
		// Keep Legends' layered equipment from covering the faction-facing bust.
		::$bvvar{namespace}.hideWholeBustCompatibilitySprites(this, true);
		foreach (name in ["body_injury", "charm_body", "charm_armor", "charm_head", "charm_hair"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		foreach (name in ["armor", "surcoat", "head", "face", "beard", "beard_top", "hair", "helmet", "helmet_damage", "helmet_top", "body_blood", "head_blood", "dirt", "injury_body", "injury", "closed_eyes", "bandage_1", "bandage_2", "bandage_3", "shaft", "quiver", "shield_icon", "arms_icon", "tattoo_body", "tattoo_head", "accessory", "accessory_special"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		local body = this.getSprite("body"); body.setBrush("bust_bv_blackgold_thirteenth_lot_weiss"); body.Visible = true;
		body.Color = this.createColor("#ffffff"); body.Saturation = 1.0; body.Scale = 1.0;
		body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, -15));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshBlackgoldVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshBlackgoldVisual(); },
	function onDeath(killer, skill, tile, fatality)
	{
		local controller = this.m.Skills.getSkillByID("$bvvar{modId}.effects.blackgold_weiss_controller");
		if (controller != null) controller.clearBid();
		// Keep vanilla loot/corpse bookkeeping while drawing only the complete custom corpse.
		local loot = this.getLootForTile(killer, this.getItems().getDroppableLoot(killer));
		if (fatality != this.Const.FatalityType.Unconscious) this.dropLoot(tile, loot, !this.isAlliedWithPlayer());
		local corpse = this.human.generateCorpse(null, fatality, killer);
		corpse.IsResurrectable = false; corpse.Tile = tile;
		if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
		else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); }
		if (tile != null) tile.spawnDetail("bust_bv_blackgold_thirteenth_lot_weiss_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer());
		this.actor.onDeath(killer, skill, tile, fatality);
	},
	function assignRandomEquipment()
	{
		foreach (path in ["weapons/noble_sword", "shields/heater_shield", "armor/coat_of_plates", "helmets/full_helm"])
		{
			local item = this.new("scripts/items/" + path);
			if (item.getSlotType() == this.Const.ItemSlot.Body || item.getSlotType() == this.Const.ItemSlot.Head) { item.m.Condition = 450; item.m.ConditionMax = 450; }
			this.m.Items.equip(item);
		}
		this.refreshBlackgoldVisual();
	}
});
