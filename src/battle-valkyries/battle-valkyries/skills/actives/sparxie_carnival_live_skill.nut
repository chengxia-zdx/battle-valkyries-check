this.sparxie_carnival_live_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Spec = null,
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.IsSpent = false;
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.ActionPointCost = this.m.Spec.ActionPointCost;
		this.m.FatigueCost = this.m.Spec.FatigueCost;
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

	function isOwnerReady( _owner )
	{
		if (_owner == null || ::$bvvar{namespace}.isActorDeadOrDying(_owner) || !this.hasRangedWeapon())
		{
			return false;
		}

		try
		{
			return _owner.isPlacedOnMap() && _owner.getTile() != null;
		}
		catch (e)
		{
			return false;
		}
	}

	function getRadius()
	{
		return this.m.Spec == null ? 6 : this.m.Spec.Radius;
	}

	function collectLivingVisibleEnemies( _owner )
	{
		if (!this.isOwnerReady(_owner))
		{
			return [];
		}

		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_owner.getTile(), this.getRadius(), true);
		local candidates = ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_owner, tiles);
		local ret = [];
		foreach (candidate in candidates)
		{
			if (::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_owner, candidate, this.getRadius(), true))
			{
				ret.push(candidate);
			}
		}
		return ret;
	}

	function isUsable()
	{
		local owner = this.getOwner();
		return this.skill.isUsable()
			&& !this.m.IsSpent
			&& this.hasRangedWeapon()
			&& this.collectLivingVisibleEnemies(owner).len() > 0;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.sparxie_carnival_live.tooltip.area}" },
			{ id = 5, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.sparxie_carnival_live.tooltip.hit}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.sparxie_carnival_live.tooltip.followup}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.sparxie_carnival_live.tooltip.consume}" }
		];

		if (!this.hasRangedWeapon())
		{
			ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.sparxie_carnival_live.tooltip.weapon_required}" });
		}
		else if (this.m.IsSpent)
		{
			ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.sparxie_carnival_live.tooltip.spent}" });
		}

		return ret;
	}

	function attackTarget( _user, _target, _weaponDamageMult, _armorDamageMult, _hitChance, _autoHit, _parentActionToken )
	{
		if (!this.isOwnerReady(_user)
			|| !::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, _target, this.getRadius(), true))
		{
			return false;
		}

		local result = null;
		try
		{
			result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, _target, {
				WeaponDamageMult = _weaponDamageMult,
				ArmorDamageMult = _armorDamageMult,
				DirectDamageAdd = 0.0,
				HitChance = _hitChance,
				AutoHit = _autoHit,
				IgnoreDistance = true,
				Source = "followup",
				ParentActionToken = _parentActionToken
			});
		}
		catch (e)
		{
			try
			{
				::logInfo("[Battle Valkyries] [SparxieCarnival] attack_exception=" + e);
			}
			catch (logError)
			{
			}
			return false;
		}

		// No post-hit target access: a successful attack may have removed it.
		return result != null && "Applied" in result && result.Applied;
	}

	function onUse( _user, _targetTile )
	{
		if (!this.isOwnerReady(_user) || this.m.IsSpent)
		{
			return false;
		}

		local baseTargets = this.collectLivingVisibleEnemies(_user);
		if (baseTargets.len() == 0)
		{
			return false;
		}

		local passive = this.getPassive();
		local smileSnapshot = passive == null ? 0 : passive.getSmile();
		local smileMultiplier = passive == null ? 1.0 : passive.getExclusiveSmileMultiplier(smileSnapshot);
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
		local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
		this.m.IsSpent = true;

		try
		{
			foreach (target in baseTargets)
			{
				if (!this.isOwnerReady(_user))
				{
					break;
				}
				if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, target, this.getRadius(), true))
				{
					continue;
				}

				this.attackTarget(
					_user,
					target,
					(this.m.Spec == null ? 0.80 : this.m.Spec.WeaponDamageMult) * smileMultiplier,
					this.m.Spec == null ? 1.25 : this.m.Spec.ArmorDamageMult,
					this.m.Spec == null ? 30 : this.m.Spec.HitChance,
					false,
					actionToken);
			}

			for (local i = 0; i < smileSnapshot; i++)
			{
				if (!this.isOwnerReady(_user))
				{
					break;
				}

				// Rebuild the candidate list before every random strike. Never
				// reuse a target that an earlier strike may have killed.
				local candidates = this.collectLivingVisibleEnemies(_user);
				if (candidates.len() == 0)
				{
					break;
				}

				local target = candidates[this.Math.rand(0, candidates.len() - 1)];
				if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, target, this.getRadius(), true))
				{
					continue;
				}

				this.attackTarget(
					_user,
					target,
					(this.m.Spec == null ? 0.25 : this.m.Spec.FollowupWeaponDamageMult) * smileMultiplier,
					this.m.Spec == null ? 0.50 : this.m.Spec.FollowupArmorDamageMult,
					0,
					true,
					actionToken);
			}
		}
		catch (e)
		{
			if (passive != null)
			{
				passive.clearSmile();
			}
			try
			{
				::logInfo("[Battle Valkyries] [SparxieCarnival] resolution_exception=" + e);
			}
			catch (logError)
			{
			}
			return true;
		}

		// Smile is consumed after every synchronous base/follow-up damage roll,
		// even when all enemies died before all random strikes were possible.
		if (passive != null)
		{
			passive.clearSmile();
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
});
