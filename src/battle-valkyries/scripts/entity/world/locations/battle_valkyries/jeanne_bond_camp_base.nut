this.jeanne_bond_camp_base <- this.inherit("scripts/entity/world/location", {
	m = {},

	function getBondStage() { return 0; }
	function getLocationName() { return ""; }
	function getLocationDescription() { return ""; }
	function getWorldBrush() { return "world_vampire_coven"; }
	function getTacticalTemplate() { return "tactical.ruins"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 2; }
	function shouldCutDownTrees() { return false; }

	function create()
	{
		this.location.create();
		local stage = this.getBondStage();
		this.m.TypeID = "$bvvar{modId}.location.jeanne_bond_" + stage;
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.Name = this.getLocationName();
		this.m.Description = this.getLocationDescription();
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = false;
		this.m.IsSpawningDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.IsDespawningDefenders = true;
		this.m.Resources = ::$bvvar{namespace}.getJeanneBondChallengeTier(stage);
		this.m.CombatLocation.Template[0] = this.getTacticalTemplate();
		this.m.CombatLocation.Fortification = this.getFortification();
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.CutDownTrees = this.shouldCutDownTrees();
		this.m.CombatLocation.AdditionalRadius = this.getAdditionalRadius();
	}

	function addTroops( _type, _num, _minibossify = 0 )
	{
		for( local i = 0; i < _num; i = ++i ) this.Const.World.Common.addTroop(this, { Type = _type }, false, _minibossify);
	}

	function populateDefenders()
	{
		if (this.m.Troops.len() != 0) return;
		local stage = this.getBondStage();
		this.m.Resources = ::$bvvar{namespace}.getJeanneBondChallengeTier(stage);
		::$bvvar{namespace}.populateJeanneBondChallengeDefenders(this, stage);
		this.updateStrength();
	}

	function applyPermanentObjectiveHighlight() { ::$bvvar{namespace}.revealJeanneBondChallengeLocation(this); }

	function onSpawned()
	{
		this.m.Name = this.getLocationName();
		::$bvvar{namespace}.attachJeanneBondChallengeFaction(this, this.getBondStage());
		this.location.onSpawned();
		this.populateDefenders();
		this.applyPermanentObjectiveHighlight();
	}

	function onBeforeCombatStarted() { this.populateDefenders(); this.location.onBeforeCombatStarted(); }

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		if (this.getBondStage() == 20)
		{
			_lootTable.push(this.new("scripts/items/weapons/battle_valkyries/jeanne_eternal_standard"));
		}
	}

	function onCombatLost()
	{
		local stage = this.getBondStage();
		this.location.onCombatLost();
		try { ::$bvvar{namespace}.grantJeanneBondChallengeReward(stage); }
		catch (e) { ::logWarning("[Battle Valkyries] Jeanne challenge stage " + stage + " was cleared, but its reward could not be granted: " + e); }
	}

	function onInit() { this.location.onInit(); this.addSprite("body").setBrush(this.getWorldBrush()); }
	function onAfterInit() { this.location.onAfterInit(); this.applyPermanentObjectiveHighlight(); }
	function onUpdate()
	{
		this.location.onUpdate();
		if (this.hasSprite("selection")) this.getSprite("selection").Visible = true;
	}
	function onDeserialize( _in ) { this.location.onDeserialize(_in); this.applyPermanentObjectiveHighlight(); }
});
