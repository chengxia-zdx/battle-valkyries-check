this.yixuan_auric_ink_shock_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Spec = null,
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.IsSpent = false;
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.ActionPointCost = this.m.Spec.ActionPointCost;
		this.m.FatigueCost = this.m.Spec.FatigueCost;
		this.m.MinRange = this.m.Spec.MinRange;
		this.m.MaxRange = this.m.Spec.MaxRange;
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
		return this.skill.isUsable() && !this.m.IsSpent && this.hasMeleeWeapon();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, target, this.m.MaxRange, true)) return false;
		return actor.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function isOwnWeaponAttack( _skill, _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target);
		return policy != null && "SourceSkillRef" in policy && ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties != null && this.isOwnWeaponAttack(_skill, _targetEntity)) _properties.MeleeSkill += this.m.Spec == null ? 20 : this.m.Spec.HitChance;
	}

	function getArcaneMastery()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID("$bvvar{modId}.skill.yixuan_arcane_mastery");
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.yixuan_auric_ink_shock.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.yixuan_auric_ink_shock.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.yixuan_auric_ink_shock.tooltip.piercing}" }
		];
		if (this.m.IsSpent) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.yixuan_auric_ink_shock.tooltip.spent}" });
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || _targetTile == null || !_targetTile.IsOccupiedByActor || this.m.IsSpent || !this.hasMeleeWeapon()) return false;
		local target = _targetTile.getEntity();
		if (target == null || target.isAlliedWith(_user) || ::$bvvar{namespace}.isActorDeadOrDying(target)) return false;
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
		local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
		this.m.IsSpent = true;
		local hitPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "yixuan_ink_cast");
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "yixuan_cast");
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
			WeaponDamageMult = this.m.Spec.WeaponDamageMult,
			ArmorDamageMult = this.m.Spec.ArmorDamageMult,
			DirectDamageAdd = 0.0,
			IgnoreDistance = true,
			IgnoreShield = true,
			ParentActionToken = actionToken
		});
		if (result != null && result.Hit && hitPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			::$bvvar{namespace}.playValkyrieSkillAudio(_user, "yixuan_ink_impact", hitPosition);
		if (result != null && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			local passive = this.getArcaneMastery();
			if (passive != null) passive.tryApplyLifePiercing(target, actionToken, null);
		}
		if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "yixuan_ink", result);
		return true;
	}

	function onTurnStart() { this.m.IsSpent = false; }
	function onCombatStarted() { this.m.IsSpent = false; }
	function onCombatFinished() { this.m.IsSpent = false; this.skill.onCombatFinished(); }
});
