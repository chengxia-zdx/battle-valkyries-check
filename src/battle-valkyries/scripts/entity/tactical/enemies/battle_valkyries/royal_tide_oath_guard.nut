this.royal_tide_oath_guard <- this.inherit("scripts/entity/tactical/enemies/skeleton_heavy", {
	m = { RoyalTideBrush = "bust_bv_royal_banner_returning_tide_tide_oath_guard" },
	function create()
	{
		this.skeleton_heavy.create(); this.m.Name = "$bv{enemy.royal_tide.guard.name}"; this.m.XP = 350;
		this.m.IsResurrectable = false; this.getFlags().add("BVRoyalTideOathGuard");
	},
	function onInit()
	{
		this.skeleton_heavy.onInit(); local b = this.m.BaseProperties;
		b.Hitpoints = 200; b.MeleeSkill = 85; b.MeleeDefense = 20; b.RangedDefense = 10;
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b; this.refreshRoyalTideVisual();
	},
	function refreshRoyalTideVisual()
	{
		if (!this.hasSprite("body")) return;
		// Keep Legends' layered equipment from covering the faction-facing bust.
		::$bvvar{namespace}.hideWholeBustCompatibilitySprites(this, true);
		foreach (name in ["charm_body", "charm_armor", "charm_head", "charm_hair"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		foreach (name in ["armor", "surcoat", "head", "face", "beard", "beard_top", "hair", "helmet", "helmet_damage", "helmet_top", "body_blood", "body_injury", "head_blood", "dirt", "injury_body", "injury", "closed_eyes", "bandage_1", "bandage_2", "bandage_3", "shaft", "quiver", "shield_icon", "arms_icon", "tattoo_body", "tattoo_head", "accessory", "accessory_special"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		local body = this.getSprite("body"); body.setBrush(this.m.RoyalTideBrush); body.Visible = true;
		body.Color = this.createColor("#ffffff"); body.Saturation = 1.0; body.Scale = 1.0;
		body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, -15));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshRoyalTideVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshRoyalTideVisual(); },
	function assignRandomEquipment() { this.skeleton_heavy.assignRandomEquipment(); this.refreshRoyalTideVisual(); },
	function onDeath(killer, skill, tile, fatality)
	{
		local controller = this.m.Skills.getSkillByID("$bvvar{modId}.effects.royal_tide_fortified_oath");
		if (controller != null) controller.clearAnchor();
		local loot = this.getLootForTile(killer, this.getItems().getDroppableLoot(killer));
		this.dropLoot(tile, loot, !this.isAlliedWithPlayer());
		// Preserve the skeleton's native loot and corpse contract, but render the
		// complete custom corpse without vanilla armor or detached head layers.
		local corpse = this.skeleton.generateCorpse(tile, fatality, killer); corpse.IsResurrectable = false;
		if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
		else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); tile.spawnDetail(this.m.RoyalTideBrush + "_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer()); }
		this.actor.onDeath(killer, skill, tile, fatality);
	}
});
