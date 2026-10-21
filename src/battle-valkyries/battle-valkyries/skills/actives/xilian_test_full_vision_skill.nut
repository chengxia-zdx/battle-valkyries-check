this.xilian_test_full_vision_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "active_104";
		this.m.SoundOnUse = ["sounds/combat/hawk_01.wav", "sounds/combat/hawk_02.wav"];
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function isEligibleUser( _actor )
	{
		return _actor != null
			&& !::$bvvar{namespace}.isActorDeadOrDying(_actor)
			&& _actor.isPlayerControlled()
			&& _actor.isPlacedOnMap()
			&& ::$bvvar{namespace}.getActorValkyrieID(_actor) == "xilian"
			&& ::$bvvar{namespace}.isBattleValkyriesTestOrigin();
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable() && this.isEligibleUser(actor);
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.xilian_test_full_vision.tooltip.effect}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.xilian_test_full_vision.tooltip.test_origin}" }
		];
	}

	function onUse( _user, _targetTile )
	{
		if (!this.isEligibleUser(_user)) return false;

		// Use the falcon's faction visibility and discovery behavior on every tile.
		// The engine clears this extra vision at the start of the next round.
		local size = this.Tactical.getMapSize();
		local faction = _user.getFaction();
		for (local x = 0; x < size.X; ++x)
		{
			for (local y = 0; y < size.Y; ++y)
			{
				local tile = this.Tactical.getTileSquare(x, y);
				tile.addVisibilityForFaction(faction);
				if (tile.IsOccupiedByActor) tile.getEntity().setDiscovered(true);
			}
		}

		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
		if (activeEntity != null) activeEntity.updateVisibilityForFaction();
		return true;
	}
});
