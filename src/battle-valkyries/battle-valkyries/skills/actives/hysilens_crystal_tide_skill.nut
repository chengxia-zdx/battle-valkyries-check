this.hysilens_crystal_tide_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = ["sounds/combat/dlc6/daze_bomb_01.wav", "sounds/combat/dlc6/daze_bomb_02.wav"];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsAOE = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.isSpent();
	}
	function isSpent()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.m.IsSpent || (actor != null && "isRoyalTideCrystalSpent" in ::$bvvar{namespace} && ::$bvvar{namespace}.isRoyalTideCrystalSpent(actor));
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.hysilens_crystal_tide.tooltip.cost}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.hysilens_crystal_tide.tooltip.area}"
			}
		];

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && "hasReturningOath" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasReturningOath(actor))
			ret.push({ id = 6, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.royal_tide.crystal_upgrade}" });
		if (this.isSpent())
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.hysilens_crystal_tide.tooltip.spent}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local user = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return this.isValidEnemyTarget(user, target);
	}

	function onTargetSelected( _targetTile )
	{
		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function getTargetAreaTiles( _targetTile )
	{
		local ret = [];

		if (_targetTile == null)
		{
			return ret;
		}

		ret.push(_targetTile);

		for( local i = 0; i < 6; i = ++i )
		{
			if (_targetTile.hasNextTile(i))
			{
				ret.push(_targetTile.getNextTile(i));
			}
		}

		return ret;
	}

	function isValidEnemyTarget( _user, _target )
	{
		return _user != null && _target != null && !_target.isAlliedWith(_user) && _target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(_user) && !::$bvvar{namespace}.isActorDeadOrDying(_target);
	}

	function addHysilensTidalErosion( _user, _target )
	{
		if (!this.isValidEnemyTarget(_user, _target) || _target.getSkills() == null)
		{
			return false;
		}

		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.hysilens_tidal_erosion");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/hysilens_tidal_erosion_effect");
			effect.setupOwner(_user);
			_target.getSkills().add(effect);
		}
		else
		{
			effect.setupOwner(_user);
			effect.onRefresh();
		}

		if (_target.isPlacedOnMap())
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#66d8ff"), _target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (this.isSpent() || ::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (!this.isValidEnemyTarget(_user, target))
		{
			return false;
		}

		this.m.IsSpent = true;
		local bv = ::$bvvar{namespace}, targets = [];
		if ("isRoyalTideCrystalSpent" in bv) _user.getFlags().set("$bvvar{modId}.royal_tide.crystal_spent", true);
		local empowered = "hasReturningOath" in bv && bv.hasReturningOath(_user);

		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			if (tile == null || !tile.IsOccupiedByActor)
			{
				continue;
			}

			local candidate = tile.getEntity();
			if (this.isValidEnemyTarget(_user, candidate))
			{
				this.addHysilensTidalErosion(_user, candidate);
				targets.push(candidate);
			}
		}

		// Apply erosion to the entire area first; each subsequent strike uses native
		// hit resolution. The neutral carrier has no implicit weapon accuracy bonus.
		if (empowered) foreach (candidate in targets)
		{
			if (!bv.hasReturningOath(_user)) break;
			if (!this.isValidEnemyTarget(_user, candidate)) continue;
			this.Tactical.spawnSpriteEffect("fx_bv_tidal_blade_hit", this.createColor("ffffff"), candidate.getTile(), 0, 30, 0.7, 0.2, 0, 150, 150);
			bv.applyValkyrieWeaponAttack(_user, this, candidate, { WeaponDamageMult = 1.5, HitChance = 35, Source = "royal_tide_crystal" });
		}
		if ("consumeRoyalTideGrowth" in bv) bv.consumeRoyalTideGrowth(_user, "hysilens");
		return true;
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.skill.onCombatFinished();
	}
});
