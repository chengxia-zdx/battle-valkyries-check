this.ryza_fieldwork_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create()
	{
		this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.ryza_fieldwork";
		// Open native battlefield, with no siege or extra camp decorator.
		this.m.CombatLocation.Template = [null, null]; this.m.CombatLocation.ForceLineBattle = false;
		this.m.CombatLocation.AdditionalRadius = 0;
	},
	function getChapterFactionType() { return this.getFlags().get("BVRyzaFieldDifficulty") == "rescue" ? this.Const.FactionType.Bandits : this.Const.FactionType.Beasts; },
	function configure()
	{
		this.yunki_chapter_location.configure();
		local route = ::$bvvar{namespace}.RyzaFieldwork.difficulty(this.getFlags().get("BVRyzaFieldDifficulty"));
		if (route != null) this.m.Name = route.Name;
		this.m.Description = "$bv{chapter.ryza_fieldwork.location_description}";
	},
	function reinforceDefenders() {},
	function populateDefenders()
	{
		if (this.getFlags().get("BVRyzaFieldPopulated") == true) return;
		local d = ::$bvvar{namespace}.RyzaFieldwork.difficulty(this.getFlags().get("BVRyzaFieldDifficulty"));
		if (d == null) return;
		foreach (group in d.Troops) for (local i = 0; i < group[1]; ++i)
			this.Const.World.Common.addTroop(this, {Type=this.Const.World.Spawn.Troops[group[0]]}, false, 0);
		this.getFlags().set("BVRyzaFieldPopulated", true); this.updateStrength();
	},
	function onEnter()
	{
		local service = ::$bvvar{namespace}.RyzaFieldwork;
		if (service.read("active") != 1 || this.getFlags().get("BVChapterCycle") != service.cycle() || this.getID() != service.read("node_id", -1) || (service.read("entered") != 1 && !service.hasRyza())) return false;
		return this.yunki_chapter_location.onEnter();
	},
	function onBeforeCombatStarted()
	{
		if (!::$bvvar{namespace}.RyzaFieldwork.enter(this)) return;
		this.yunki_chapter_location.onBeforeCombatStarted();
	}
});
