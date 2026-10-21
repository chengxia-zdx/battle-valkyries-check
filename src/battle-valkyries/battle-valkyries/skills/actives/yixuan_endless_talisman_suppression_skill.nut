this.yixuan_endless_talisman_suppression_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Spec = null },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.ActionPointCost = this.m.Spec.ActionPointCost;
		this.m.FatigueCost = this.m.Spec.FatigueCost;
		this.m.MinRange = this.m.Spec.MinRange;
		this.m.MaxRange = this.m.Spec.MaxRange;
	}

	function getTechniquePointsEffect()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID("$bvvar{modId}.effects.yixuan_technique_points");
	}

	function hasMeleeWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getItems() == null) return false;
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isUsable()
	{
		local effect = this.getTechniquePointsEffect();
		return this.skill.isUsable() && effect != null && effect.getCount() == 3 && this.hasMeleeWeapon();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, target, this.m.MaxRange, true)) return false;
		return actor.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function getTargets( _user, _targetTile )
	{
		if (_user == null || _targetTile == null) return [];
		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, this.m.Spec.Radius, true);
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, tiles);
	}

	function isOwnWeaponAttack( _skill, _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target);
		return policy != null && "SourceSkillRef" in policy && ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties != null && this.isOwnWeaponAttack(_skill, _targetEntity)) _properties.MeleeSkill += this.m.Spec == null ? 30 : this.m.Spec.HitChance;
	}

	function getFixedDamage()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return 0;
		return this.Math.min(50, this.Math.floor(actor.getHitpointsMax() * 0.30));
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.yixuan_endless_talisman_suppression.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.yixuan_endless_talisman_suppression.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.yixuan_endless_talisman_suppression.tooltip.piercing}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.yixuan_endless_talisman_suppression.tooltip.points}" }
		];
		local effect = this.getTechniquePointsEffect();
		if (effect == null || effect.getCount() < 3) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.yixuan_endless_talisman_suppression.tooltip.not_ready}" });
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local effect = this.getTechniquePointsEffect();
		if (_user == null || _targetTile == null || effect == null || effect.getCount() != 3 || !this.hasMeleeWeapon()) return false;
		local targets = this.getTargets(_user, _targetTile);
		if (targets.len() == 0) return false;
		effect.setCount(0);
		local fixedDamage = this.getFixedDamage();
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "yixuan_talisman_cast");
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "yixuan_cast");
		local impactPlayed = false;
		foreach (target in targets)
		{
			local hitPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "yixuan_seal");
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
				WeaponDamageMult = this.m.Spec.WeaponDamageMult,
				ArmorDamageMult = this.m.Spec.ArmorDamageMult,
				DirectDamageAdd = 0.0,
				IgnoreDistance = true,
				IgnoreShield = true
			});
			if (!impactPlayed && result != null && result.Hit && hitPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.playValkyrieSkillAudio(_user, "yixuan_ink_impact", hitPosition);
				impactPlayed = true;
			}
			if (result != null && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target) && fixedDamage > 0)
			{
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, target, fixedDamage, { Source = "yixuan_endless_talisman" });
			}
			if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "yixuan_ink", result);
		}
		return true;
	}
});
