this.himeko_heavenly_flare_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { IsSpent = false },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		// It has no hit roll, but still needs a normal action identity so
		// Victory Rush can snapshot its player-selected primary target.
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 2;
		this.m.MaxRange = 7;
		this.m.IsSpent = false;
	}

	function isUsable() { return this.skill.isUsable() && !this.m.IsSpent; }

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, target, this.m.MaxRange, true)
			&& actor.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.himeko_heavenly_flare.tooltip.armor}" },
			{ id = 5, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.himeko_heavenly_flare.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.himeko_heavenly_flare.tooltip.radius}" }
		];
		if (this.m.IsSpent) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.himeko_heavenly_flare.tooltip.spent}" });
		return ret;
	}

	function chooseBodyPart()
	{
		return this.Math.rand(1, 100) <= 25 ? this.Const.BodyPart.Head : this.Const.BodyPart.Body;
	}

	function getTargets( _user, _targetTile )
	{
		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true);
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, tiles);
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || this.m.IsSpent || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local targets = this.getTargets(_user, _targetTile);
		if (targets.len() == 0) return false;
		this.m.IsSpent = true;
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
		local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
		foreach (target in targets)
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			local bodyPart = this.chooseBodyPart();
			::$bvvar{namespace}.applyValkyrieFixedArmorDamage(_user, this, target, bodyPart, 80, { ActionToken = actionToken, Source = "himeko_heavenly_flare" });
			if (!::$bvvar{namespace}.isActorDeadOrDying(target))
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, target, 25, { ActionToken = actionToken, Source = "himeko_heavenly_flare", BodyPart = bodyPart });
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "himeko_orbital");
		}
		return true;
	}

	function onCombatStarted() { this.m.IsSpent = false; }
	function onCombatFinished() { this.m.IsSpent = false; this.skill.onCombatFinished(); }
});
