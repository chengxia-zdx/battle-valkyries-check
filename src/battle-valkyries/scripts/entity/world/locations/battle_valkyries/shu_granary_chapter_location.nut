this.shu_granary_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create()
	{
		this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.shu_granary";
		// Open native battlefield, with no siege or extra camp decorator.
		this.m.CombatLocation.Template = [null, null]; this.m.CombatLocation.ForceLineBattle = false;
		this.m.CombatLocation.AdditionalRadius = 0;
	},
	function getChapterFactionType() { return this.Const.FactionType.Bandits; },
	function configure()
	{
		this.yunki_chapter_location.configure(); this.m.Description = "$bv{chapter.shu_granary.location_description}";
	},
	function reinforceDefenders() {},
	function populateDefenders()
	{
		if (this.getFlags().get("BVGranaryPopulated") == true) return;
		local d = ::$bvvar{namespace}.ShuGranary.difficulty(this.getFlags().get("BVGranaryDifficulty"));
		if (d == null) return;
		foreach (group in d.Troops) for (local i = 0; i < group[1]; ++i)
			this.Const.World.Common.addTroop(this, {Type=this.Const.World.Spawn.Troops[group[0]]}, false, 0);
		this.getFlags().set("BVGranaryPopulated", true); this.updateStrength();
	},
	function onEnter()
	{
		local service = ::$bvvar{namespace}.ShuGranary;
		if (service.read("active") != 1 || this.getID() != service.read("node_id", -1) || (service.read("entered") != 1 && !service.hasShu())) return false;
		return this.yunki_chapter_location.onEnter();
	},
	function onBeforeCombatStarted()
	{
		if (!::$bvvar{namespace}.ShuGranary.enter(this)) return;
		this.yunki_chapter_location.onBeforeCombatStarted();
	}
});
