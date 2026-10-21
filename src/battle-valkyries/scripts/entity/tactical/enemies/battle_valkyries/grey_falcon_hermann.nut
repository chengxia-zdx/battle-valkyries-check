this.grey_falcon_hermann <- this.inherit("scripts/entity/tactical/enemies/bandit_leader", {
	function create()
	{
		this.bandit_leader.create(); this.m.Name = "$bv{enemy.grey_falcon.hermann.name}"; this.m.XP = 600;
	},
	function onInit()
	{
		this.bandit_leader.onInit();
		local b = this.m.BaseProperties;
		b.Hitpoints = 240; b.Bravery = 100; b.MeleeSkill = 85; b.MeleeDefense = 20; b.RangedDefense = 10;
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.Skills.removeByID("perk.nine_lives");
		this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/grey_falcon_command_effect"));
	},
	function assignRandomEquipment()
	{
		foreach (path in ["weapons/noble_sword", "shields/heater_shield", "armor/coat_of_plates", "helmets/full_helm"])
			this.m.Items.equip(this.new("scripts/items/" + path));
	}
});
