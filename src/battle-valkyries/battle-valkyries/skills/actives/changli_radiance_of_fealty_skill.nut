this.changli_radiance_of_fealty_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Spec = null,
		UsesSpent = 0,
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.UsesSpent = 0;
		this.m.IsSpent = false;
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.ActionPointCost = this.m.Spec.ActionPointCost;
		this.m.FatigueCost = this.m.Spec.FatigueCost;
	}

	function getRadius()
	{
		return this.m.Spec == null ? 2 : this.m.Spec.Radius;
	}

	function getEnflamementEffect()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID("$bvvar{modId}.effects.changli_enflamement");
	}

	function hasMeleeWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getItems() == null)
		{
			return false;
		}
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function getTargets( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user))
		{
			return [];
		}
		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(), this.getRadius(), true);
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, tiles);
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable() && !this.m.IsSpent && this.hasMeleeWeapon() && this.getTargets(actor).len() > 0;
	}

	function isOwnWeaponAttack( _skill, _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target);
		return policy != null && "SourceSkillRef" in policy
			&& ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties != null && this.isOwnWeaponAttack(_skill, _targetEntity))
		{
			_properties.MeleeSkill += this.m.Spec == null ? 20 : this.m.Spec.HitChance;
		}
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.changli_radiance_of_fealty.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.changli_radiance_of_fealty.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.changli_radiance_of_fealty.tooltip.layers}" }
		];
		if (this.m.IsSpent)
		{
			ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.changli_radiance_of_fealty.tooltip.spent}" });
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local targets = this.getTargets(_user);
		if (targets.len() == 0 || !this.hasMeleeWeapon() || this.m.IsSpent)
		{
			return false;
		}

		this.m.UsesSpent++;
		this.m.IsSpent = true;
		try
		{
			foreach (target in targets)
			{
				local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
					WeaponDamageMult = this.m.Spec.WeaponDamageMult,
					ArmorDamageMult = this.m.Spec.ArmorDamageMult,
					DirectDamageAdd = 0.0
				});
				if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "changli_flame", result);
			}
		}
		catch (e)
		{
			local effect = this.getEnflamementEffect();
			if (effect != null)
			{
				effect.setCount(4);
			}
			throw e;
		}
		local effect = this.getEnflamementEffect();
		if (effect != null)
		{
			effect.setCount(4);
		}
		return true;
	}

	function onCombatStarted()
	{
		this.m.UsesSpent = 0;
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.UsesSpent = 0;
		this.m.IsSpent = false;
		this.skill.onCombatFinished();
	}
});
