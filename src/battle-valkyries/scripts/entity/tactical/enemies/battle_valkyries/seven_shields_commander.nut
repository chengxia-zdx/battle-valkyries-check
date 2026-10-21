this.seven_shields_commander <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/black_city_chloe", {
	m = { SevenShieldsRole = "alicia" },
	function profile()
	{
		local profiles = {
			alicia = { HP = 330, Melee = 95, Defense = 30, Initiative = 120, Ranged = 40, Armor = "mail_hauberk", Weapons = ["weapons/noble_sword", "shields/heater_shield"], Caster = false },
			prim = { HP = 280, Melee = 82, Defense = 22, Initiative = 100, Ranged = 40, Armor = "mail_hauberk", Weapons = ["weapons/fighting_spear", "shields/heater_shield"], Caster = false },
			kaguya = { HP = 300, Melee = 55, Defense = 18, Initiative = 95, Ranged = 88, Armor = "wizard_robe", Weapons = [], Caster = true },
			maia = { HP = 370, Melee = 100, Defense = 28, Initiative = 135, Ranged = 45, Armor = "mail_hauberk", Weapons = ["weapons/arming_sword", "shields/kite_shield"], Caster = false },
			luu_luu = { HP = 410, Melee = 100, Defense = 22, Initiative = 85, Ranged = 40, Armor = "mail_hauberk", Weapons = ["weapons/greataxe"], Caster = false },
			claudia = { HP = 460, Melee = 105, Defense = 32, Initiative = 90, Ranged = 40, Armor = "coat_of_plates", Weapons = ["weapons/polehammer"], Caster = false },
			celestine = { HP = 420, Melee = 55, Defense = 22, Initiative = 90, Ranged = 95, Armor = "wizard_robe", Weapons = [], Caster = true }
		};
		return profiles[this.m.SevenShieldsRole];
	},
	function create()
	{
		this.black_city_chloe.create();
		this.getFlags().remove("BVBlackCityOpponent"); this.getFlags().add("BVSevenShieldsOpponent");
		this.m.BlackCityBrush = "bust_bv_" + this.m.SevenShieldsRole + "_skin";
		this.m.BlackCityCaster = this.profile().Caster;
		this.m.XP = this.m.SevenShieldsRole == "celestine" ? 1600 : 1100;
		if (this.m.BlackCityCaster)
		{
			this.m.AIAgent = this.new("scripts/ai/tactical/agents/bandit_ranged_agent"); this.m.AIAgent.setActor(this);
		}
	},
	function onInit()
	{
		this.black_city_chloe.onInit();
		local p = this.profile(), b = this.m.BaseProperties;
		b.Hitpoints = p.HP; b.MeleeSkill = p.Melee; b.MeleeDefense = p.Defense;
		b.Initiative = p.Initiative; b.RangedSkill = p.Ranged; b.RangedDefense = 25;
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		if (p.Caster)
		{
			this.m.Skills.removeByID("actives.quick_shot");
			local spell = this.new("scripts/skills/actives/battle_valkyries/seven_shields_spell");
			spell.m.SevenShieldsRole = this.m.SevenShieldsRole;
			if (this.m.SevenShieldsRole == "celestine")
			{
				spell.m.Icon = "skills/$bvvar{iconPrefix}/celestine_judgment.png";
				spell.m.IconDisabled = "skills/$bvvar{iconPrefix}/celestine_judgment_sw.png";
			}
			this.m.Skills.add(spell);
		}
		this.refreshBlackCityVisual();
	},
	function assignRandomEquipment()
	{
		local p = this.profile();
		foreach (path in p.Weapons) this.m.Items.equip(this.new("scripts/items/" + path));
		this.m.Items.equip(this.new("scripts/items/armor/" + p.Armor));
		// The real armor affects protection; only the adopted outfit is visible.
		this.refreshBlackCityVisual();
	}
});
