this.sparxie_live_connection_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Spec = null,
		UsedThisRound = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxRangeBonus = 0;
		this.m.UsedThisRound = false;
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.ActionPointCost = this.m.Spec.ActionPointCost;
		this.m.FatigueCost = this.m.Spec.FatigueCost;
		this.m.MinRange = this.m.Spec.MinRange;
		this.m.MaxRange = this.m.Spec.MaxRange;
	}

	function getOwner()
	{
		local container = this.getContainer();
		return container == null ? null : container.getActor();
	}

	function getPassive()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("sparxie_backstage_trick"));
	}

	function hasRangedWeapon()
	{
		local owner = this.getOwner();
		if (owner == null)
		{
			return false;
		}

		local weapon = null;
		try
		{
			weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		}
		catch (e)
		{
			weapon = null;
		}

		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.RangedWeapon);
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.UsedThisRound && this.hasRangedWeapon();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)
			|| _targetTile == null
			|| !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local owner = this.getOwner();
		local target = _targetTile.getEntity();
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true))
		{
			return false;
		}

		try
		{
			return owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
		}
		catch (e)
		{
			return false;
		}
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.sparxie_live_connection.tooltip.attack}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.sparxie_live_connection.tooltip.guest}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.sparxie_live_connection.tooltip.trigger}" }
		];

		if (!this.hasRangedWeapon())
		{
			ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.sparxie_live_connection.tooltip.weapon_required}" });
		}
		else if (this.m.UsedThisRound)
		{
			ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.sparxie_live_connection.tooltip.spent}" });
		}

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null
			|| this.m.UsedThisRound
			|| !this.hasRangedWeapon()
			|| !this.onVerifyTarget(_user.getTile(), _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();
		local passive = this.getPassive();
		local smileMultiplier = passive == null ? 1.0 : passive.getExclusiveSmileMultiplier();
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
		local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
			WeaponDamageMult = (this.m.Spec == null ? 1.0 : this.m.Spec.WeaponDamageMult) * smileMultiplier,
			ArmorDamageMult = this.m.Spec == null ? 1.0 : this.m.Spec.ArmorDamageMult,
			DirectDamageAdd = 0.0,
			HitChance = this.m.Spec == null ? 20 : this.m.Spec.HitChance,
			IgnoreDistance = true,
			// The player action is the managed active itself; this neutral
			// carrier is its child strike and must not count as a second action.
			Source = "followup",
			ParentActionToken = actionToken
		});

		if (result == null || !("Applied" in result) || !result.Applied)
		{
			return false;
		}

		this.m.UsedThisRound = true;
		if (passive != null)
		{
			// The passive installs the marker only when this outer action
			// resolves, so the opening shot cannot gift itself.
			passive.queueLiveConnection(actionToken, target);
		}

		if ("Hit" in result && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			try
			{
				if (target.isPlacedOnMap())
				{
					this.spawnIcon("status_effect_95", target.getTile());
				}
			}
			catch (e)
			{
			}
		}

		return true;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event != null && "Type" in _event && _event.Type == "NewRound")
		{
			this.m.UsedThisRound = false;
		}
	}

	function onCombatStarted()
	{
		this.m.UsedThisRound = false;
	}

	function onNewRound()
	{
		this.m.UsedThisRound = false;
	}

	function onCombatFinished()
	{
		this.m.UsedThisRound = false;
		this.skill.onCombatFinished();
	}
});
