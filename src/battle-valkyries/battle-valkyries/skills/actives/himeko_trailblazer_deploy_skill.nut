this.himeko_trailblazer_deploy_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = [ "sounds/combat/dlc6/daze_bomb_01.wav", "sounds/combat/dlc6/daze_bomb_02.wav" ];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getSummoner()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return ::$bvvar{namespace}.getHimekoTrailblazerSummonerEquipped(actor);
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local summoner = this.getSummoner();
		return this.skill.isUsable()
			&& actor != null
			&& ::$bvvar{namespace}.getActorValkyrieID(actor) == "himeko"
			&& summoner != null
			&& !summoner.isDeployedThisBattle();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile)
			&& _targetTile != null
			&& _targetTile.IsEmpty;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/health.png", text = "$bv{skill.himeko_trailblazer_deploy.tooltip.health}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_body.png", text = "$bv{skill.himeko_trailblazer_deploy.tooltip.armor}" },
			{ id = 6, type = "text", icon = "ui/icons/melee_skill.png", text = "$bv{skill.himeko_trailblazer_deploy.tooltip.combat}" },
			{ id = 7, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.himeko_trailblazer_deploy.tooltip.attack}" }
		];
		local summoner = this.getSummoner();

		if (summoner != null && summoner.isDeployedThisBattle())
		{
			ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.himeko_trailblazer_deploy.tooltip.spent}" });
		}

		return ret;
	}

	function onDelayedTrailblazerVisualRefresh( _data )
	{
		if (_data == null || !("Entity" in _data))
		{
			return;
		}

		local entity = _data.Entity;

		if (entity == null || ::$bvvar{namespace}.isActorDeadOrDying(entity))
		{
			return;
		}

		entity.refreshTrailblazerAppearancePipeline("deploy.delayed");

		try
		{
			if (entity.isPlacedOnMap() && this.Tactical != null && this.Tactical.TurnSequenceBar != null)
			{
				this.Tactical.TurnSequenceBar.updateEntity(entity.getID());
			}
		}
		catch (e)
		{
		}
	}

	function onUse( _user, _targetTile )
	{
		local summoner = this.getSummoner();

		if (summoner == null || summoner.isDeployedThisBattle() || _targetTile == null || !_targetTile.IsEmpty)
		{
			return false;
		}

		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/himeko_trailblazer_mech", _targetTile.Coords.X, _targetTile.Coords.Y);

		if (entity == null)
		{
			return false;
		}

		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.setItem(summoner);
		summoner.markDeployed(entity);
		entity.refreshTrailblazerAppearancePipeline("deploy.immediate");
		this.Time.scheduleEvent(this.TimeUnit.Real, 10, this.onDelayedTrailblazerVisualRefresh.bindenv(this), {
			Entity = entity
		});
		return true;
	}
});
