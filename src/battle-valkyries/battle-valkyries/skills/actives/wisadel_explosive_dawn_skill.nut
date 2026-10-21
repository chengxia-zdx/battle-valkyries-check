this.wisadel_explosive_dawn_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Spec = null
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 7;
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

	function hasRangedWeapon()
	{
		local actor = this.getOwner();
		if (actor == null || actor.getItems() == null)
		{
			return false;
		}

		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.RangedWeapon);
	}

	function getTargets( _user, _targetTile )
	{
		if (_user == null || _targetTile == null)
		{
			return [];
		}

		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, this.m.Spec.Radius, true);
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, tiles);
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.hasRangedWeapon();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local owner = this.getOwner();
		local target = _targetTile.getEntity();
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true))
		{
			return false;
		}

		return owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.wisadel_explosive_dawn.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.wisadel_explosive_dawn.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.wisadel_explosive_dawn.tooltip.area}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.wisadel_explosive_dawn.tooltip.control}" }
		];

		if (!this.hasRangedWeapon())
		{
			ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.wisadel_explosive_dawn.tooltip.weapon_required}" });
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.hasRangedWeapon() || !this.onVerifyTarget(_user.getTile(), _targetTile))
		{
			return false;
		}

		local targets = this.getTargets(_user, _targetTile);
		if (targets.len() == 0)
		{
			return false;
		}

		foreach (target in targets)
		{
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
				WeaponDamageMult = this.m.Spec.WeaponDamageMult,
				ArmorDamageMult = this.m.Spec.ArmorDamageMult,
				DirectDamageAdd = 0.0,
				HitChance = this.m.Spec.HitChance,
				IgnoreDistance = this.m.Spec.IgnoreDistance,
				IgnoreShield = this.m.Spec.IgnoreShield,
				Source = "direct"
			});

			if (result != null && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				::$bvvar{namespace}.applyStatusEffects(_user, target, [{ Type = "dazed", Turns = this.m.Spec.DazedTurns }]);
			}
		}

		return true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
	}
});
