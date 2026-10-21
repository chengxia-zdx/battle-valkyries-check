this.septium_overseer <- this.inherit("scripts/entity/tactical/enemies/bandit_leader",{
 function create(){this.bandit_leader.create();this.m.Name="$bv{orbment.enemy.overseer}";this.m.XP=700;this.m.IsResurrectable=false;this.getFlags().set("BVSeptiumRole","overseer");},
 function onInit(){
  this.bandit_leader.onInit();local b=this.m.BaseProperties;
  b.Hitpoints=450;b.MeleeSkill=85;b.RangedSkill=80;b.MeleeDefense=20;b.RangedDefense=10;b.Bravery=100;
  local p=::Tactical.State.getStrategicProperties();this.getFlags().set("BVSeptiumElement",p!=null&&"BVSeptiumElement" in p?p.BVSeptiumElement:"earth");
  b.IsImmuneToBleeding=true;b.IsImmuneToPoison=true;this.m.Hitpoints=b.Hitpoints;this.m.CurrentProperties=clone b;
  this.m.Skills.removeByID("perk.nine_lives");this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/septium_protocol_effect"));
  this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/actives/septium_blast_skill"));
  this.refreshSeptiumVisual();
 },
	function refreshSeptiumVisual()
	{
		if (!this.hasSprite("body")) return;
		// Keep Legends' layered equipment from covering the faction-facing bust.
		::$bvvar{namespace}.hideWholeBustCompatibilitySprites(this, true);
		foreach (name in ["body_injury", "charm_body", "charm_armor", "charm_head", "charm_hair"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		foreach (name in ["armor", "surcoat", "head", "face", "beard", "beard_top", "hair", "helmet", "helmet_damage", "helmet_top", "body_blood", "head_blood", "dirt", "injury_body", "injury", "closed_eyes", "bandage_1", "bandage_2", "bandage_3", "shaft", "quiver", "shield_icon", "arms_icon", "tattoo_body", "tattoo_head", "accessory", "accessory_special"])
			if (this.hasSprite(name)) { this.getSprite(name).Visible = false; this.getSprite(name).Alpha = 0; }
		local body = this.getSprite("body"); body.setBrush("bust_bv_septium_overseer"); body.Visible = true;
		body.Color = this.createColor("#ffffff"); body.Saturation = 1.0; body.Scale = 1.0;
		body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.setSpriteOffset("body", this.createVec(0, -15));
	},
	function onAppearanceChanged(appearance, dirty = true) { this.actor.onAppearanceChanged(appearance, false); this.refreshSeptiumVisual(); if (dirty) this.setDirty(true); },
	function onFactionChanged() { this.actor.onFactionChanged(); this.refreshSeptiumVisual(); },
	function onDeath(killer, skill, tile, fatality)
	{
		// Keep vanilla loot/corpse bookkeeping while drawing only the complete custom corpse.
		local loot = this.getLootForTile(killer, this.getItems().getDroppableLoot(killer));
		if (fatality != this.Const.FatalityType.Unconscious) this.dropLoot(tile, loot, !this.isAlliedWithPlayer());
		local corpse = this.human.generateCorpse(null, fatality, killer);
		corpse.IsResurrectable = false; corpse.Tile = tile;
		if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
		else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); }
		if (tile != null) tile.spawnDetail("bust_bv_septium_overseer_dead", this.Const.Tactical.DetailFlag.Corpse, !this.isAlliedWithPlayer());
		this.actor.onDeath(killer, skill, tile, fatality);
	},
 function assignRandomEquipment(){
  foreach(path in ["weapons/arming_sword", "shields/heater_shield", "armor/mail_hauberk", "helmets/closed_mail_coif"])this.m.Items.equip(this.new("scripts/items/"+path));
  this.refreshSeptiumVisual();
 }
});
