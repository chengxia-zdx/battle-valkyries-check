this.black_city_chloe <- this.inherit("scripts/entity/tactical/enemies/bandit_leader", {
	m = { BlackCityCaster = false, BlackCityBrush = "bust_bv_chloe_skin" },
	function create()
	{
		this.bandit_leader.create(); this.m.Name = "$bv{chapter.black_city.enemy.chloe}";
		this.m.XP = 900;
		this.getFlags().add("BVBlackCityOpponent");
	},
	function onInit()
	{
		this.bandit_leader.onInit(); local b = this.m.BaseProperties;
		b.ActionPoints = 9; b.Hitpoints = this.m.BlackCityCaster ? 280 : 350;
		b.Stamina = 170; b.Bravery = 100; b.Initiative = this.m.BlackCityCaster ? 80 : 105;
		b.MeleeSkill = this.m.BlackCityCaster ? 55 : 95; b.RangedSkill = this.m.BlackCityCaster ? 85 : 45;
		b.MeleeDefense = this.m.BlackCityCaster ? 15 : 28; b.RangedDefense = 20;
		b.IsAffectedByNight = false; b.Vision = 8;
		this.m.ActionPoints = b.ActionPoints; this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		if (this.m.BlackCityCaster)
		{
			this.m.Skills.removeByID("actives.rotation");
			this.m.Skills.add(this.new("scripts/skills/actives/battle_valkyries/black_city_flame"));
		}
		this.refreshBlackCityVisual();
	},
	function refreshBlackCityVisual()
	{
		if (!this.hasSprite("body")) return;
		::$bvvar{namespace}.hideWholeBustCompatibilitySprites(this, true);
		foreach (name in ["charm_body", "charm_armor", "charm_head", "charm_hair", "armor", "surcoat", "head", "face", "beard", "beard_top", "hair", "helmet", "helmet_damage", "helmet_top", "body_blood", "body_injury", "head_blood", "dirt", "injury_body", "injury", "closed_eyes", "bandage_1", "bandage_2", "bandage_3", "shaft", "quiver", "shield_icon", "arms_icon", "tattoo_body", "tattoo_head", "accessory", "accessory_special"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		local body = this.getSprite("body"); body.setBrush(this.m.BlackCityBrush); body.Visible = true;
		body.Color = this.createColor("#ffffff"); body.Saturation = 1.0; body.Scale = 1.0;
		// All nine Black Beast boss skins already carry the same tactical anchor.
		body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, 0));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshBlackCityVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshBlackCityVisual(); },
	function assignRandomEquipment()
	{
		if (!this.m.BlackCityCaster)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/noble_sword"));
			this.m.Items.equip(this.new("scripts/items/shields/kite_shield"));
		}
		this.m.Items.equip(this.new(this.m.BlackCityCaster ? "scripts/items/armor/wizard_robe" : "scripts/items/armor/mail_hauberk"));
		this.refreshBlackCityVisual();
	},
	function onDeath(killer, skill, tile, fatality)
	{
		// This enemy proxy is defeated; the story actor is recruited separately.
		local loot = this.getLootForTile(killer, this.getItems().getDroppableLoot(killer));
		this.dropLoot(tile, loot, !this.isAlliedWithPlayer());
		local corpse = this.human.generateCorpse(null, this.Const.FatalityType.Unconscious, killer);
		corpse.IsResurrectable = false; corpse.IsConsumable = false; corpse.Tile = tile;
		if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
		else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); tile.spawnDetail(this.m.BlackCityBrush + "_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer()); }
		this.actor.onDeath(killer, skill, tile, this.Const.FatalityType.Unconscious);
	}
});
