this.olga_corruption_camp_location <- this.inherit("scripts/entity/world/location", {
	function getCorruptionStage() { return this.getFlags().get("BVOlgaCorruptionStage"); }
	function create()
	{
		this.location.create();
		this.m.TypeID = "$bvvar{modId}.location.olga_corruption";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = true; this.m.IsShowingBanner = false;
		this.m.IsSpawningDefenders = false; this.m.IsScalingDefenders = false; this.m.IsDespawningDefenders = false;
		this.m.CombatLocation.Template = ["tactical.ruins", null];
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.ForceLineBattle = true; this.m.CombatLocation.AdditionalRadius = 3;
	}
	function configure(value, owner = null)
	{
		local entry = ::$bvvar{namespace}.OlgaCorruption.stage(value);
		if (entry == null) throw "[Battle Valkyries] Invalid Olga corruption camp stage";
		this.getFlags().set("BVOlgaCorruptionStage", value);
		if (owner != null) this.getFlags().set("BVOlgaCorruptionOwner", owner);
		this.m.TypeID = "$bvvar{modId}.location.olga_corruption_" + value;
		this.m.Name = entry.LocationName; this.m.Description = entry.LocationDescription;
		this.m.CombatLocation.Template = [entry.Template, null];
		this.m.Resources = ::$bvvar{namespace}.getHimekoBondChallengeTier(value);
		if (this.hasSprite("body")) this.getSprite("body").setBrush(entry.Brush);
	}
	function populateDefenders()
	{
		if (this.m.Troops.len() > 0) return;
		local entry = ::$bvvar{namespace}.OlgaCorruption.stage(this.getCorruptionStage());
		local band = ::$bvvar{namespace}.getHimekoBondChallengeBand(this.getCorruptionStage());
		foreach (group in entry.Troops)
		{
			local count = group[1] + (group[2] == 1 ? band : (group[2] == 2 && band >= 2 ? 1 : 0));
			for (local i = 0; i < count; ++i)
				this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops[group[0]] }, false, 0);
		}
		this.updateStrength();
	}
	function onInit() { this.location.onInit(); this.addSprite("body").setBrush("world_bandit_camp_01"); }
	function onSpawned()
	{
		this.location.onSpawned();
		::$bvvar{namespace}.attachHimekoBondChallengeFaction(this, this.getCorruptionStage());
		this.populateDefenders(); ::$bvvar{namespace}.OlgaCorruption.reveal(this);
	}
	function onBeforeCombatStarted()
	{
		this.populateDefenders();
		this.getFlags().set("BVOlgaCorruptionCombatID", ::$bvvar{namespace}.OlgaCorruption.combatID() + 1);
		this.location.onBeforeCombatStarted();
	}
	function onCombatLost()
	{
		if (!::$bvvar{namespace}.OlgaCorruption.completeCamp(this))
		{
			// A victory without the living participant cannot destroy the unique objective.
			this.populateDefenders(); ::$bvvar{namespace}.OlgaCorruption.reveal(this); return;
		}
		if (this.hasSprite("selection")) this.getSprite("selection").Visible = false;
		this.location.onCombatLost();
	}
	function onAfterInit()
	{
		this.location.onAfterInit();
		if (::$bvvar{namespace}.OlgaCorruption.stage(this.getCorruptionStage()) != null) ::$bvvar{namespace}.OlgaCorruption.reveal(this);
	}
	function onUpdate()
	{
		this.location.onUpdate();
		if (this.hasSprite("selection")) this.getSprite("selection").Visible = this.isAlive();
	}
	function onDeserialize(input)
	{
		this.location.onDeserialize(input); this.configure(this.getCorruptionStage()); ::$bvvar{namespace}.OlgaCorruption.reveal(this);
	}
});
