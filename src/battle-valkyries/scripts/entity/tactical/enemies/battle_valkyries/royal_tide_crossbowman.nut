// Ancient skeleton physiology with the existing ranged AI and equipment pipeline.
this.royal_tide_crossbowman <- this.inherit("scripts/entity/tactical/enemies/skeleton_heavy", {
	function create()
	{
		this.skeleton_heavy.create(); this.m.Name = "$bv{enemy.royal_tide.crossbowman.name}"; this.m.XP = 250;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_ranged_agent"); this.m.AIAgent.setActor(this);
		this.m.IsResurrectable = false;
	},
	function onInit()
	{
		this.skeleton_heavy.onInit(); local b = this.m.BaseProperties;
		b.Hitpoints = 120; b.MeleeSkill = 55; b.RangedSkill = 75; b.MeleeDefense = 5; b.RangedDefense = 10;
		b.IsSpecializedInCrossbows = true; b.Vision = 8;
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
	},
	function assignRandomEquipment()
	{
		foreach (path in ["weapons/crossbow", "ammo/quiver_of_bolts", "armor/ancient/ancient_mail", "helmets/ancient/ancient_legionary_helmet"])
			this.m.Items.equip(this.new("scripts/items/" + path));
		this.m.Items.addToBag(this.new("scripts/items/weapons/ancient/ancient_sword"));
	}
});
