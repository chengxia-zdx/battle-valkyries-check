this.battle_valkyries_bounty_camp <- this.inherit("scripts/entity/world/location", {
	function create()
	{
		this.location.create();
		this.m.TypeID = "location.battle_valkyries_bounty_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsSpawningDefenders = false;
		this.m.IsDespawningDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.IsShowingBanner = false;
		this.getFlags().set("BVBountyCamp", true);
	}
	function onInit()
	{
		this.location.onInit();
		this.addSprite("body").setBrush("world_bandit_camp_01");
	}
	function onSpawned() {} // Dedicated rewards, no generic Named roll from encounter points.
	function createDefenders() {} // Persisted troops remain authoritative after retreat/load.
	function applyBountyTheme()
	{
		local t = ::$bvvar{namespace}.BountyCamps.theme(this.getFlags().get("BVBountyCampTheme"));
		if (t == null) return;
		this.getSprite("body").setBrush(t.Brush);
		this.m.CombatLocation.Template[0] = t.Battlefield;
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = t.Battlefield != null;
		this.setName(t.Name);
	}
	function getDescription() { return "$bv{bounty.camp.description}"; }
	function onDeserialize(_in)
	{
		this.location.onDeserialize(_in);
		this.applyBountyTheme();
	}
});
