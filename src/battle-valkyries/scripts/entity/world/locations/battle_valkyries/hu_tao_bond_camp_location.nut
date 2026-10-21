this.hu_tao_bond_camp_location <- this.inherit("scripts/entity/world/location", {
	function getBondStage() { return this.getFlags().get("BVHuTaoBondStage"); }
	function create()
	{
		this.location.create();
		this.m.TypeID = "$bvvar{modId}.location.hu_tao_bond";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = true; this.m.IsShowingBanner = false;
		this.m.IsSpawningDefenders = false; this.m.IsScalingDefenders = false; this.m.IsDespawningDefenders = false;
		// Terrain is selected by getLocalCombatProperties; these slots are camp decorators.
		this.m.CombatLocation.Template = [null, null];
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.ForceLineBattle = true; this.m.CombatLocation.AdditionalRadius = 3;
	}
	function configure(value)
	{
		local entry = ::$bvvar{namespace}.HuTaoBond.stage(value);
		if (entry == null) throw "[Battle Valkyries] Invalid Hu Tao bond camp stage";
		this.getFlags().set("BVHuTaoBondStage", value);
		this.m.TypeID = "$bvvar{modId}.location.hu_tao_bond_" + value;
		this.m.Name = entry.LocationName; this.m.Description = entry.LocationDescription;
		this.m.CombatLocation.Template = [value>=80?"tactical.ruins":null, null];
		this.m.Resources = ::$bvvar{namespace}.getHimekoBondChallengeTier(value);
		if (this.hasSprite("body")) this.getSprite("body").setBrush(entry.Brush);
	}
	function populateDefenders()
	{
		if (this.m.Troops.len() > 0) return;
		local entry = ::$bvvar{namespace}.HuTaoBond.stage(this.getBondStage());
		foreach (group in entry.Troops)
		{
			local count = group[1];
			for (local i = 0; i < count; ++i)
				this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops[group[0]] }, false, 0);
		}
		this.updateStrength();
	}
	function onInit() { this.location.onInit(); this.addSprite("body").setBrush("world_bandit_camp_01"); }
	function onSpawned()
	{
		this.location.onSpawned();
		::$bvvar{namespace}.attachHimekoBondChallengeFaction(this, this.getBondStage() >= 80 ? 100 : 20);
		this.populateDefenders(); ::$bvvar{namespace}.HuTaoBond.reveal(this);
	}
	function onBeforeCombatStarted()
	{
		::$bvvar{namespace}.HuTaoChallenge.prepare(this.getBondStage());
		this.m.Troops.clear(); this.populateDefenders();
		this.getFlags().set("BVHuTaoBondCombatID", ::$bvvar{namespace}.HuTaoBond.combatID() + 1);
		this.location.onBeforeCombatStarted();
	}
	function onCombatLost()
	{
		if (!::$bvvar{namespace}.HuTaoBond.completeCamp(this))
		{
			// A victory without the living participant cannot destroy the unique objective.
			this.populateDefenders(); ::$bvvar{namespace}.HuTaoBond.reveal(this); return;
		}
		if (this.hasSprite("selection")) this.getSprite("selection").Visible = false;
		this.location.onCombatLost();
	}
	function onAfterInit()
	{
		this.location.onAfterInit();
		if (::$bvvar{namespace}.HuTaoBond.stage(this.getBondStage()) != null) ::$bvvar{namespace}.HuTaoBond.reveal(this);
	}
	function onUpdate()
	{
		this.location.onUpdate();
		if (this.hasSprite("selection")) this.getSprite("selection").Visible = this.isAlive();
	}
	function onDeserialize(input)
	{
		this.location.onDeserialize(input); this.configure(this.getBondStage()); ::$bvvar{namespace}.HuTaoBond.reveal(this);
	}
});
