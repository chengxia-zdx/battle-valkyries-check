this.aglaea_destined_weaving_dance_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/daze_bomb_01.wav",
			"sounds/combat/dlc6/daze_bomb_02.wav"
		];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
	}

	function getActionPointCost()
	{
		return 0;
	}

	function getFatigueCost()
	{
		return 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.cost}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.target}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.area}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.no_friendly_fire}"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.stance}"
			}
		];

		if (this.m.IsSpent)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.spent}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local user = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return user != null && !::$bvvar{namespace}.isActorDeadOrDying(user)
			&& target != null && !target.isAlliedWith(user) && target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target);
	}

	function onTargetSelected( _targetTile )
	{
		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function addSeam( _target )
	{
		if (_target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.aglaea_seam_stitch");

		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/aglaea_seam_stitch_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}

		return true;
	}

	function addSupremeStance( _user )
	{
		if (_user == null || _user.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_user))
		{
			return;
		}

		local effect = _user.getSkills().getSkillByID("$bvvar{modId}.effects.aglaea_supreme_stance");

		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/aglaea_supreme_stance_effect");
			_user.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null || target.isAlliedWith(_user) || !target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return false;
		}

		this.m.IsSpent = true;
		this.addSupremeStance(_user);

		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			if (!tile.IsOccupiedByActor)
			{
				continue;
			}

			local candidate = tile.getEntity();

			if (candidate == null || candidate.isAlliedWith(_user) || !candidate.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(candidate))
			{
				continue;
			}

			if (this.addSeam(candidate) && candidate.isPlacedOnMap())
			{
				this.spawnIcon("status_effect_34", candidate.getTile());
			}
		}

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

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeBool(this.m.IsSpent);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.IsSpent = _in.readBool();
	}
});
