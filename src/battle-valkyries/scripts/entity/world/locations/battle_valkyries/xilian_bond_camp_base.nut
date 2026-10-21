this.xilian_bond_camp_base <- this.inherit("scripts/entity/world/location", {
	m = {},

	function getBondStage()
	{
		return 0;
	}

	function getLocationName()
	{
		return "";
	}

	function getLocationDescription()
	{
		return "";
	}

	function getWorldBrush()
	{
		return "world_vampire_coven";
	}

	function getTacticalTemplate()
	{
		return "tactical.ruins";
	}

	function getFortification()
	{
		return this.Const.Tactical.FortificationType.None;
	}

	function getAdditionalRadius()
	{
		return 2;
	}

	function shouldCutDownTrees()
	{
		return false;
	}

	function create()
	{
		this.location.create();
		local stage = this.getBondStage();
		this.m.TypeID = "$bvvar{modId}.location.xilian_bond_" + stage;
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.Name = this.getLocationName();
		this.m.Description = this.getLocationDescription();
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = false;
		this.m.IsSpawningDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.IsDespawningDefenders = true;
		this.m.Resources = ::$bvvar{namespace}.getXilianBondChallengeTier(stage);
		this.m.CombatLocation.Template[0] = this.getTacticalTemplate();
		this.m.CombatLocation.Fortification = this.getFortification();
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.CutDownTrees = this.shouldCutDownTrees();
		this.m.CombatLocation.AdditionalRadius = this.getAdditionalRadius();
	}

	function addTroops( _type, _num, _minibossify = 0 )
	{
		for( local i = 0; i < _num; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = _type
			}, false, _minibossify);
		}
	}

	function populateDefenders()
	{
		if (this.m.Troops.len() != 0)
		{
			return;
		}

		local stage = this.getBondStage();
		this.m.Resources = ::$bvvar{namespace}.getXilianBondChallengeTier(stage);
		::$bvvar{namespace}.populateXilianBondChallengeDefenders(this, stage);
		this.updateStrength();
	}

	function applyPermanentObjectiveHighlight()
	{
		::$bvvar{namespace}.revealXilianBondChallengeLocation(this);
	}

	function onSpawned()
	{
		this.m.Name = this.getLocationName();
		::$bvvar{namespace}.attachXilianBondChallengeFaction(this, this.getBondStage());
		this.location.onSpawned();
		this.populateDefenders();
		this.applyPermanentObjectiveHighlight();
	}

	function onBeforeCombatStarted()
	{
		this.populateDefenders();
		this.location.onBeforeCombatStarted();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		local stage = this.getBondStage();

		if (stage == 60)
		{
			_lootTable.push(this.new("scripts/items/weapons/battle_valkyries/xilian_infinite_oath_bow"));
		}
		else if (stage == 20 || stage == 40 || stage == 80)
		{
			local item = ::$bvvar{namespace}.createXilianBondRandomRedEquipment(stage);

			if (item != null)
			{
				_lootTable.push(item);
			}
		}
	}

	function onCombatLost()
	{
		::$bvvar{namespace}.grantXilianBondChallengeReward(this.getBondStage());
		this.location.onCombatLost();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush(this.getWorldBrush());
	}

	function onAfterInit()
	{
		this.location.onAfterInit();
		this.applyPermanentObjectiveHighlight();
	}

	function onUpdate()
	{
		this.location.onUpdate();

		if (this.hasSprite("selection"))
		{
			this.getSprite("selection").Visible = true;
		}
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.applyPermanentObjectiveHighlight();
	}
});
